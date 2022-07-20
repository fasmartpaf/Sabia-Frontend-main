import 'dart:developer';

import 'package:flutter/material.dart';
import "package:build_context/build_context.dart";
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sabia_app/components/icon/app_icon.dart';
import 'package:sabia_app/model/book/book_model.dart';

import '../../../../components/modal/image_picker_modal.dart';
import '../../../../components/animation/lottie_animation.dart';
import '../../../../components/book/book_image_widget.dart';
import '../../../../components/button/button.dart';
import '../../../../components/container/no_pop_container.dart';
import '../../../../components/form/input_image_picker.dart';
import '../../../../components/form/input_text.dart';
import '../../../../components/image/svg_image.dart';
import '../../../../components/loading/loading_view.dart';
import '../../../../components/modal/modal.dart';
import '../../../../components/scaffold/will_pop_scaffold.dart';
import '../../../../components/text/card_message_text.dart';
import '../../../../components/text/list_tile_text.dart';
import '../../../../components/text/section_title.dart';
import '../../../../services/barcode_scan_service.dart';
import '../../../../services/media_service.dart';
import '../../../../stores/book_store.dart';
import '../../../../utils/styles.dart';

import 'book_form_store.dart';

class BookFormPage extends StatefulWidget {
  @override
  _BookFormPageState createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _authorFocusNode = FocusNode();

  BookStore _bookStore;
  BookFormStore _store;
  String qrCodeText = "";

  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();

    this._bookStore = Modular.get<BookStore>();
    this._store = BookFormStore(this._bookStore);
  }

  dispose() {
    _titleFocusNode?.dispose();
    _authorFocusNode?.dispose();
    _store.dispose();
    super.dispose();
  }

  void _openScanner() async {
    qrCodeText = await BarcodeScanService.scan() ?? "";
    _store.setIsbn(qrCodeText);
    _store.tryToGetBookDataFromIsbn();
  }

  void _backToManuallyEditIsbn() {
    _store.setIsManualIsbn(true);
    _store.setIsbnView();
  }

  Widget _renderInput({
    TextEditingController controller,
    FocusNode focusNode,
    Widget iconWidget,
    String label,
    String value,
    String helperText,
    String errorText,
    bool isDisabled = false,
    bool autofocus = false,
    Function() onTap,
    Function() onEditingComplete,
    Function(String) onChanged,
    TextInputAction textInputAction = TextInputAction.next,
    TextInputType textInputType = TextInputType.text,
    List<TextInputFormatter> inputFormatters,
    int maxLength,
    TextCapitalization textCapitalization,
  }) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(left: 16.0, bottom: 8, top: 12),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: InputText(
        maxLength: maxLength,
        focusNode: focusNode,
        controller: controller,
        isDisabled: isDisabled,
        autofocus: autofocus,
        withListTile: false,
        value: value,
        errorText: errorText,
        helperText: helperText,
        textInputType: textInputType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        onTap: onTap,
        onEditingComplete: onEditingComplete,
        onChanged: onChanged,
        suffixIconWidget: iconWidget,
        textCapitalization: textCapitalization,
      ),
    );
  }

  Future<void> didSelectPickerSource({bool fromGallery}) async {
    setState(() => this._isPickingImage = true);
    final MediaService _mediaService = MediaService();
    final image = await _mediaService.pickImage(
      fromGallery: fromGallery,
    );

    if (image != null) _store.addImage(image);

    setState(() => this._isPickingImage = false);
  }

  _openImagePickerModal(int index) {
    bool isNewImage = index > _store.images.length - 1;

    ImagePickerModal.open(
      isNewImage: isNewImage,
      didSelect: (int selectedIndex) {
        if (selectedIndex == -1) {
          _store.removeImage(index);
        } else {
          didSelectPickerSource(fromGallery: selectedIndex == 1);
        }
      },
    );
  }

  Widget _renderEditingForm() {
    if (_bookStore.selectedBook.status == BookStatus.lend) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Este livro está emprestado",
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.headline5.copyWith(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              "Não é possível editar um livro emprestado.",
              textAlign: TextAlign.center,
            ),
            Text(
              "Volte aqui quando ele retornar pra sua biblioteca :)",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    Widget _renderOption({
      String title,
      String subtitle,
      BookStatus status,
    }) {
      final isChecked = status == _store.status;
      Color color = isChecked ? kSuccessColor : kGrayActiveColor;
      return ListTile(
        dense: true,
        onTap: () => _store.setStatus(status),
        leading: Icon(
          isChecked ? FontAwesomeIcons.checkSquare : FontAwesomeIcons.square,
          color: color,
        ),
        title: Text(
          title,
          style: TextStyle(color: color),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
      );
    }

    return ListView(
      children: <Widget>[
        _renderOption(
          title: "Indisponível",
          subtitle: "Aparece apenas na sua biblioteca",
          status: BookStatus.library,
        ),
        Divider(),
        _renderOption(
          title: "Estou lendo",
          subtitle:
              "Aparece para seus contatos, porém não estará disponível para empréstimo",
          status: BookStatus.reading,
        ),
        Divider(),
        _renderOption(
          title: "Disponível para empréstimo",
          subtitle: "Seus contatos poderão pedir emprestado.",
          status: BookStatus.available,
        ),
        Divider(),
        _renderOption(
          title: "Doação",
          subtitle: "Você deseja doar seu livro para seus contatos.",
          status: BookStatus.donation,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Button(
            label: "Atualizar",
            fullWidth: true,
            icon: SaveIcon,
            onPressed: _store.update,
          ),
        ),
        SizedBox(height: 40),
        Button(
          flat: true,
          fullWidth: true,
          label: "Excluir o livro",
          icon: DeleteIcon,
          onPressed: () => Modal.confirmDelete(
            onConfirm: _bookStore.deleteBook,
          ),
        ),
      ],
    );
  }

  Widget _renderIsbnForm() {
    if (_store.isSearchingBook) {
      return NoPopContainer(
        backgroundColor: kGrayBackgroundColor,
        children: [
          CardMessageText(
            "Só um minutinho enquanto localizo seu livro...",
          ),
          LottieAnimation.typing(
            width: 140,
            repeat: true,
          ),
        ],
      );
    }

    List<Widget> children = [];
    if (_store.isManualIsbn) {
      children.addAll([
        _renderInput(
          label: "Código ISBN *",
          value: _store.isbn,
          onChanged: _store.setIsbn,
          autofocus: true,
          errorText: _store.validateIsbnMessage,
          iconWidget: Icon(FontAwesomeIcons.barcode),
          maxLength: 13,
        ),
        ListTile(
          title: _store.isbn.isEmpty
              ? Button(
                  label: "Voltar",
                  outlined: true,
                  onPressed: () {
                    _store.setIsManualIsbn(false);
                  },
                )
              : Button(
                  label: "Continuar",
                  icon: Icons.chevron_right,
                  onPressed: _store.tryToGetBookDataFromIsbn,
                ),
        ),
        ListTile(
          title: Button(
            outlined: true,
            fullWidth: true,
            label: "Ler código de barras",
            icon: Icons.camera_alt,
            onPressed: () {
              _openScanner();
              _store.setIsManualIsbn(false);
            },
          ),
        ),
      ]);
    } else {
      children.addAll([
        ListTile(
          title: Button(
            label: "Ler código de barras",
            fullWidth: true,
            icon: Icons.camera_alt,
            onPressed: () {
              _openScanner();
            },
          ),
        ),
        ListTile(
          title: Button(
            label: "Digitar manualmente",
            fullWidth: true,
            outlined: true,
            onPressed: () {
              _store.setIsManualIsbn(true);
            },
          ),
        ),
        Divider(
          height: 40,
          endIndent: 36,
          indent: 36,
        ),
        Button(
          label: "Ignorar",
          flat: true,
          fullWidth: true,
          onPressed: () {
            Modal.confirm(
              title: "Tem certeza?",
              message:
                  "O código ISBN facilita a localização do seu livro para agilizar o cadastro!",
              confirmLabel: "Continuar sem ISBN",
              cancelLabel: "Voltar",
              onConfirm: _store.setMetadataView,
            );
          },
        ),
      ]);
    }

    return ListView(children: [
      ListTileText("Informe o código ISBN do seu livro:"),
      ...children,
    ]);
  }

  Widget _renderConfirmMetadata() {
    return ListView(children: [
      ListTileText("Este é o seu livro?"),
      Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 240,
              child: BookImageWidget(
                imageUrl: _store.coverUrl,
                alt: _store.title,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _store.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: context.textTheme.headline6.copyWith(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              _store.authors,
              textAlign: TextAlign.center,
              style: context.textTheme.headline6.copyWith(fontSize: 16),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
      ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Button(
              label: "Não",
              outlined: true,
              fullWidth: false,
              icon: Icons.thumb_down,
              onPressed: _store.setIsbnIsWrong,
            ),
            Button(
              label: "SIM",
              fullWidth: false,
              icon: Icons.thumb_up,
              onPressed: _store.setImagesView,
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _renderMetadataForm() {
    return ListView(
      padding: EdgeInsets.only(
        bottom: 30,
      ),
      children: [
        ListTileText("Informe os detalhes do seu livro:"),
        _renderInput(
          label: "Título *",
          value: _store.title,
          onChanged: _store.setTitle,
          focusNode: _titleFocusNode,
          errorText: _store.validateTitleMessage,
          textCapitalization: TextCapitalization.words,
          onEditingComplete: () => _authorFocusNode.requestFocus(),
        ),
        _renderInput(
          label: "Nome do(s) autor(es) *",
          value: _store.authors,
          onChanged: _store.setAuthors,
          focusNode: _authorFocusNode,
          helperText: "Separe os nomes com vírgulas",
          errorText: _store.validateAuthorsMessage,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _renderNotFoundByIsbnView() {
    return ListView(children: [
      ListTileText(
        "Desculpe, não consegui localizar seu livro.",
        trailing: Icon(Icons.warning),
      ),
      ListTileText(
        "Verifique se o código ISBN está correto ou continue para cadastrar manualmente.",
      ),
      _renderInput(
        label: "",
        isDisabled: true,
        textInputType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        value: _store.isbn,
        onChanged: _store.setIsbn,
        errorText: _store.validateIsbnMessage,
        iconWidget: Icon(FontAwesomeIcons.barcode),
        onTap: this._backToManuallyEditIsbn,
      ),
      ListTile(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Button(
          label: "Voltar",
          fullWidth: false,
          outlined: true,
          onPressed: this._backToManuallyEditIsbn,
        ),
        Button(
          label: "Continuar",
          fullWidth: false,
          icon: Icons.chevron_right,
          onPressed: _store.setMetadataView,
        ),
      ])),
    ]);
  }

  Widget _renderImagesForm() {
    if (this._isPickingImage) {
      return LoadingView();
    }
    return ListView(children: [
      ListTileText("Insira fotos do seu livro:"),
      InputImagePicker(
        imagesList: _store.images,
        onTap: this._openImagePickerModal,
      ),
      if (_store.validateImagesMessage != null)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Text(
              _store.validateImagesMessage,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ),
    ]);
  }

  Widget _renderBody() {
    Widget child = Container();

    if (_bookStore.isEditingBook) {
      child = _renderEditingForm();
    } else if (_store.isIsbnView) {
      child = _renderIsbnForm();
    } else if (_store.isConfirmMetadataView) {
      child = _renderConfirmMetadata();
    } else if (_store.isMetadataView) {
      child = _renderMetadataForm();
    } else if (_store.isNotFoundByIsbnView) {
      child = _renderNotFoundByIsbnView();
    } else if (_store.isImagesView) {
      child = _renderImagesForm();
    }

    return Observer(
      builder: (_) {
        return Column(
          children: <Widget>[
            Expanded(
              child: child,
            ),
            if (_store.shouldDisplaySubmitButton)
              SafeArea(
                child: Row(
                  children: <Widget>[
                    Button(
                      label: "Voltar",
                      flat: true,
                      onPressed: _store.backView,
                    ),
                    Expanded(
                      child: Button(
                        label: _store.submitButtonLabel,
                        icon: _store.submitButtonIcon,
                        square: true,
                        fullWidth: true,
                        padding: EdgeInsets.all(20),
                        onPressed: _store.submit,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (_store.isWaitingForm) {
          return NoPopContainer(
            children: [
              SVGImage("checkmark", color: kSuccessColor),
              SizedBox(height: 40),
              SectionTitle("Tudo pronto"),
              SizedBox(height: 8),
              CardMessageText(
                "Só um minutinho enquanto a gente divulga para outros ninhos.",
              ),
              LottieAnimation.typing(
                width: 140,
                repeat: true,
              ),
            ],
          );
        }

        return WillPopScaffold(
          title: _bookStore.isAddingBook ? "Novo livro" : "Editar livro",
          onBackPressed: () {
            if (_bookStore.isAddingBook) {
              Modal.confirm(
                title: "Deseja sair?",
                message: "As informações inseridas serão perdidas.",
                confirmLabel: "Sair",
                onConfirm: _bookStore.unselectBook,
              );
            } else {
              Modular.to.pop();
            }
          },
          shouldPop: false,
          child: _renderBody(),
        );
      },
    );
  }
}
