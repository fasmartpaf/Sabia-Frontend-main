import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sabia_app/components/button/button.dart';
import 'package:sabia_app/components/button/submit_button.dart';
import 'package:sabia_app/components/container/no_pop_container.dart';
import 'package:sabia_app/components/form/input_text.dart';
import 'package:sabia_app/components/image/svg_image.dart';
import 'package:sabia_app/components/scaffold/will_pop_scaffold.dart';
import 'package:sabia_app/components/text/section_title.dart';
import 'package:sabia_app/pages/profile_form_page/profile_form_store.dart';
import 'package:sabia_app/stores/auth_store.dart';
import 'package:sabia_app/stores/routing_store.dart';
import 'package:sabia_app/utils/styles.dart';

class ProfileFormPage extends StatefulWidget {
  @override
  _ProfileFormPageState createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  ProfileFormStore _store;

  @override
  void initState() {
    super.initState();

    this._store = ProfileFormStore(
      Modular.get<AuthStore>(),
      Modular.get<RoutingStore>(),
    );
  }

  Widget _renderInput({
    String label,
    String value,
    bool isDisabled = false,
    String errorText,
    Function(String) onChanged,
    TextInputType textInputType = TextInputType.text,
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
        withListTile: false,
        value: value,
        errorText: errorText,
        textInputType: textInputType,
        onChanged: onChanged,
        isDisabled: isDisabled,
        textCapitalization: textCapitalization,
      ),
    );
  }

  Widget _renderForm() {
    final textTheme = Theme.of(context).textTheme;
    return ListView(children: [
      _renderInput(
        label: "Nome completo *",
        value: _store.name,
        errorText: _store.validateNameMessage,
        onChanged: _store.setName,
        textCapitalization: TextCapitalization.words,
      ),
      _renderInput(
        label: "E-mail *",
        value: _store.email,
        errorText: _store.validateEmailMessage,
        onChanged: _store.setEmail,
        textInputType: TextInputType.emailAddress,
        textCapitalization: TextCapitalization.none,
      ),
      _renderInput(
        label: "Celular *",
        value: _store.phone,
        onChanged: _store.setPhone,
        isDisabled: true,
        textInputType: TextInputType.phone,
      ),
      _renderInput(
        label: "Localidade",
        value: _store.location,
        onChanged: _store.setLocation,
      ),
      SizedBox(height: 12),
      ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                "Privacidade do perfil",
                style: TextStyle(fontSize: 14),
              ),
            ),
            Row(children: [
              Expanded(
                  child: Button(
                label: "Privado",
                small: true,
                outlined: _store.isPublicProfile,
                onPressed: () => _store.setIsPublicProfile(false),
              )),
              SizedBox(width: 10),
              Expanded(
                  child: Button(
                label: "Público",
                small: true,
                outlined: !_store.isPublicProfile,
                onPressed: () => _store.setIsPublicProfile(true),
              )),
            ]),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6, left: 16.0),
          child: Text(
            _store.isPublicProfile
                ? "Todos os usuários poderão ver e pesquisar seus livros."
                : "Somente seus amigos poderão ver e pesquisar seus livros.",
            style: textTheme.caption.copyWith(fontSize: 14),
          ),
        ),
      ),
    ]);
  }

  Widget _renderBody() {
    return Observer(
      builder: (_) {
        return Column(
          children: <Widget>[
            Expanded(
              child: _renderForm(),
            ),
            SafeArea(
              child: SubmitButton(
                label: "Salvar alterações",
                onPressed: _store.submit,
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
              SectionTitle("Dados alterados com sucesso"),
            ],
          );
        }

        return WillPopScaffold(
          title: "Alterar dados",
          child: _renderBody(),
        );
      },
    );
  }
}
