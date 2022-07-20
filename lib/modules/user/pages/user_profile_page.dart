import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:build_context/build_context.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../components/icon/app_icon.dart';
import '../../../components/modal/image_picker_modal.dart';
import '../../../components/book/book_image_widget.dart';
import '../../../components/button/button.dart';
import '../../../components/loading/loading_view.dart';
import '../../../components/text/section_title.dart';
import '../../../components/user/user_profile_widget.dart';
import '../../../model/book/book_loan_model.dart';
import '../../../model/book/book_model.dart';
import '../../../routes/app_routes.dart';
import '../../../stores/auth_store.dart';
import '../../../stores/book_loan_store.dart';
import '../../../stores/book_store.dart';
import '../../../stores/routing_store.dart';
import '../../../services/media_service.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';

import '../../../stores/user_store.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  final bool displayContact;
  final String predefinedMessage;

  final void Function(int index) onChangeHomePageIndex;

  const UserProfilePage(
    this.userId, {
    this.displayContact = false,
    this.predefinedMessage,
    this.onChangeHomePageIndex,
    Key key,
  }) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isPickingImage = false;
  BookStore _bookStore;
  BookLoanStore _bookLoanStore;
  UserStore _userStore;

  @override
  void initState() {
    super.initState();
    _userStore = Modular.get<UserStore>();

    _userStore.setUserId(this.widget.userId);

    this._bookStore = Modular.get<BookStore>();
    this._bookLoanStore = Modular.get<BookLoanStore>();
  }

  bool get _isCurrentUser => this._userStore.isCurrentUser;
  bool get _isUserFriend =>
      !this._isCurrentUser &&
      _userStore.isFriendOfCurrentUser(_userStore.user.id);
  bool get _displayContact => this.widget.displayContact;

  void _openUrl(String url) {
    final encodedUrl = Uri.encodeFull(url);
    tryToOpenUrl(encodedUrl);
  }

  Future<void> didSelectPickerSource({bool fromGallery}) async {
    final MediaService _mediaService = MediaService();
    final image = await _mediaService.pickImage(
      fromGallery: fromGallery,
    );

    final croppedImage = image == null
        ? null
        : await _mediaService.cropImage(
            image,
            toolbarColor: kOrangeColor,
            toolbarWidgetColor: Colors.white,
            title: "Sua foto do perfil",
          );

    if (croppedImage != null) {
      await this._userStore.setUserProfileImage(croppedImage);
    }
  }

  _openImagePickerModal() {
    bool isNewImage = this._userStore.user.image == null;

    ImagePickerModal.open(
      isNewImage: isNewImage,
      didSelect: (int index) async {
        setState(() => this._isPickingImage = true);
        if (index == -1) {
          await this._userStore.removeUserProfileImage();
        } else {
          await didSelectPickerSource(fromGallery: index == 1);
        }
        setState(() => this._isPickingImage = false);
      },
    );
  }

  Widget _separator() => SizedBox(height: 8);

  Widget _sectionTitle(String title) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SectionTitle(
            title,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  Widget _buildBookLoan(BuildContext context, dynamic item) {
    if (!(item is BookLoanModel)) return SizedBox();
    final BookLoanModel bookLoan = item;
    final book = bookLoan.book;
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              this._bookStore.setSelectedBookForDetailsId(book.id);
            },
            child: SizedBox(
              height: 180,
              child: Observer(
                builder: (_) => BookImageWidget(
                  imageUrl: book.coverUrl,
                  alt: book.title,
                ),
              ),
            ),
          ),
          SizedBox(height: 6),
          Text(
            bookLoan.status.labelTo,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyText1.copyWith(
              color: kOrangeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBook(BuildContext context, dynamic item) {
    if (!(item is BookModel)) return SizedBox();
    final BookModel book = item;

    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              this._bookStore.setSelectedBookForDetailsId(book.id);
            },
            child: SizedBox(
              height: 180,
              child: Observer(
                builder: (_) => BookImageWidget(
                  imageUrl: book.coverUrl,
                  alt: book.title,
                ),
              ),
            ),
          ),
          SizedBox(height: 6),
          Text(
            book.status.label,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyText1.copyWith(
              color: kSuccessColor,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _section({
    String title,
    List<dynamic> itemsList,
    Widget Function(BuildContext, dynamic) itemBuilder,
    Function onTapTitle,
  }) {
    List<Widget> list = [
      InkWell(
        onTap: onTapTitle,
        child: Row(
          children: [
            Expanded(
              child: _sectionTitle(title),
            ),
            if (onTapTitle != null)
              Text(
                "ver mais",
                style: TextStyle(
                  color: kOrangeColor,
                ),
              ),
          ],
        ),
      ),
      _separator(),
    ];

    if (itemsList.isNotEmpty) {
      list.add(LimitedBox(
        maxHeight: 220,
        child: ListView.separated(
          separatorBuilder: (_, __) => SizedBox(width: 30),
          itemCount: itemsList.length,
          scrollDirection: Axis.horizontal,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final item = itemsList[index];
            return itemBuilder(context, item);
          },
        ),
      ));
    }

    return list;
  }

  List<Widget> renderEmptyLibrary(String title) {
    if (!_isCurrentUser) return [];
    return [
      _sectionTitle(title),
      SizedBox(height: 8),
      Text("Isso aqui está muito vazio! Vamos adicionar seu primeiro livro?"),
      _separator(),
      Button(
        label: "Cadastrar livro",
        fullWidth: true,
        onPressed: () => _bookStore.setSelectedBookForFormId("new"),
      ),
    ];
  }

  Widget _renderUserProfile() {
    return UserProfileWidget(
      _userStore.user,
      hideInformation: !_isCurrentUser && !_isUserFriend,
      onTapProfileImage: !_isCurrentUser || this._isPickingImage
          ? null
          : this._openImagePickerModal,
      isFetchingProfileImage: _isCurrentUser && this._isPickingImage,
      beforeWidgets: [
        if (_isCurrentUser)
          Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Center(
                child: Text(
                  "Meu Perfil",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: 24,
                      ),
                ),
              ),
              Positioned(
                right: -10,
                top: -10,
                child: IconButton(
                  iconSize: 16,
                  icon: Icon(LogoutIcon),
                  onPressed: Modular.get<AuthStore>().logout,
                ),
              )
            ],
          )
        else
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(NavigationBackIcon),
              color: kSuccessColor,
              onPressed: () => Modular.get<RoutingStore>()
                  .moveToMainRoute(APP_ROUTE.HOME.path),
            ),
          ),
      ],
      afterWidgets: _isCurrentUser
          ? [
              SizedBox(height: 16),
              Button(
                label: "Editar perfil",
                outlined: true,
                onPressed: () {
                  Modular.get<RoutingStore>()
                      .moveToRoute(APP_ROUTE.PROFILE_FORM.path);
                },
              ),
            ]
          : [
              Button(
                label: _isUserFriend ? "Seguindo" : "Seguir",
                outlined: _isUserFriend,
                onPressed: () {
                  if (_isUserFriend) {
                    _userStore.didRemoveUserAsFriend(_userStore.user.id);
                  } else {
                    _userStore.didAddUserAsFriend(_userStore.user.id);
                  }
                },
              )
            ],
    );
  }

  Widget _withPadding(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: child,
      );

  Widget renderBody() {
    return Observer(
      builder: (_) {
        if (_userStore.isFetching || _userStore.user == null) {
          return LoadingView();
        }

        List<Widget> columnChildren = [];

        if (this._displayContact) {
          columnChildren = this._renderContact();
        } else {
          columnChildren = [
            _renderUserProfile(),
            if (_isCurrentUser)
              _withPadding(Observer(
                builder: (_) {
                  if (_bookLoanStore.currentUserBorrowedBookLoans.isEmpty) {
                    return SizedBox();
                  }
                  return Column(
                    children: _section(
                      title: "O que estou lendo",
                      itemsList: _bookLoanStore.currentUserBorrowedBookLoans,
                      itemBuilder: this._buildBookLoan,
                    ),
                  );
                },
              )),
            _withPadding(
              Observer(
                builder: (_) {
                  if (!_isUserFriend && !_userStore.user.isPublicProfile) {
                    return Text(
                        "Este perfil é privado. Siga ele para visualizar :)");
                  }
                  if (_userStore.isFetchingBooks) {
                    return LoadingView();
                  }
                  final sectionTitle =
                      _isCurrentUser ? "Minha biblioteca" : "Biblioteca";
                  List<Widget> children = [];

                  if (_userStore.booksLibrary.isEmpty) {
                    children = renderEmptyLibrary(sectionTitle);
                  } else {
                    children = _section(
                      title: sectionTitle,
                      itemsList: this._userStore.booksLibrary,
                      itemBuilder: this._buildBook,
                      onTapTitle: this.widget.onChangeHomePageIndex == null ||
                              !_isCurrentUser ||
                              _userStore.booksLibrary.isEmpty
                          ? null
                          : () => this.widget.onChangeHomePageIndex(2),
                    );
                  }

                  return Column(
                    children: children,
                  );
                },
              ),
            ),
          ];
        }

        return SingleChildScrollView(
          child: Column(
            children: columnChildren,
          ),
        );
      },
    );
  }

  List<Widget> _renderContact() {
    final phone = _userStore.user.phone;
    final email = _userStore.user.email;
    final predefinedMessage = this.widget.predefinedMessage ?? "";
    return [
      _renderUserProfile(),
      _withPadding(Button(
        label: "Inicie uma conversa",
        icon: FontAwesomeIcons.whatsapp,
        fullWidth: true,
        onPressed: () => this._openUrl(
          "whatsapp://send?phone=${phone.replaceAll("+", "")}&text=$predefinedMessage",
        ),
      )),
      _withPadding(Button(
        label: "Faça uma ligação",
        outlined: true,
        fullWidth: true,
        icon: FontAwesomeIcons.phoneAlt,
        onPressed: () => this._openUrl(
          "tel:$phone",
        ),
      )),
      if (email.isNotEmpty)
        _withPadding(Button(
          label: "Escreva um e-mail",
          outlined: true,
          fullWidth: true,
          icon: FontAwesomeIcons.envelope,
          onPressed: () => this._openUrl(
            "mailto:$email?subject=$predefinedMessage",
          ),
        )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: this.renderBody(),
    );
  }
}
