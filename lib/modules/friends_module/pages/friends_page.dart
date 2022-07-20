import 'package:flutter/material.dart';
import 'package:build_context/build_context.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sabia_app/components/button/button.dart';
import 'package:sabia_app/components/loading/loading_view.dart';
import 'package:sabia_app/components/modal/modal.dart';
import 'package:sabia_app/components/search/input_search.dart';
import 'package:sabia_app/components/user/profile_image.dart';
import 'package:sabia_app/model/user_model.dart';
import 'package:sabia_app/modules/friends_module/store/friends_page_store.dart';
import 'package:sabia_app/routes/app_routes.dart';
import 'package:sabia_app/stores/routing_store.dart';
import 'package:sabia_app/utils/phone_utils.dart';
import 'package:sabia_app/utils/styles.dart';
import 'package:sabia_app/model/contact_model.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  TextEditingController _searchInputController =
      TextEditingController(text: "");
  final FriendsPageStore _store = Modular.get<FriendsPageStore>();

  @override
  void initState() {
    super.initState();

    _store.getCurrentUserFriends();

    _searchInputController.text = _store.searchString;
    _searchInputController.addListener(_inputSearchDidChange);
  }

  void _inputSearchDidChange() {
    _store.setSearchString(_searchInputController.text);
  }

  TextTheme get textTheme => Theme.of(context).textTheme;

  Widget _renderTextTile(String text) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      title: Text(
        text,
        style: textTheme.subtitle2.copyWith(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _renderSabiaFriend(
    UserModel friend,
  ) {
    return InkWell(
      onTap: () {
        Modular.get<RoutingStore>().replaceToRoute(
          APP_ROUTE.USER_PROFILE.pathWithId(friend.id),
        );
      },
      child: Card(
        child: ListTile(
          visualDensity: VisualDensity.compact,
          leading: SizedBox(
            width: 40,
            child: ProfileImage(
              name: friend.name,
              imageUrl: friend.imageUrl,
              height: 40,
            ),
          ),
          title: Text(
            friend.name,
            style: textTheme.subtitle1.copyWith(
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderContactData(
    String text,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 12,
          color: kSuccessColor,
        ),
        SizedBox(width: 6),
        Text(
          text,
          style: textTheme.subtitle2,
        ),
      ],
    );
  }

  Widget _renderContact(ContactModel contact) {
    final isSabiaUser = _store.arePhonesValidUser(contact.phones);

    return Card(
      child: ListTile(
        visualDensity: VisualDensity.compact,
        trailing: SizedBox(
          width: 150,
          child: Button(
            small: true,
            label: isSabiaUser ? "Adicionar\n amigo" : "Convidar\npara o Sabiá",
            type: isSabiaUser ? ButtonType.success : ButtonType.primary,
            onPressed: isSabiaUser
                ? () => _store.didAddUserWithPhones(contact.phones)
                : () {
                    Modal.custom(
                      title: "Convidar para o Sabiá",
                      barrierDismissible: true,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (contact.phones.isNotEmpty)
                            Text(
                              "WhatsApp:",
                              style: textTheme.subtitle2,
                            ),
                          ...contact.phones
                              .map((phone) => FlatButton(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          phone,
                                          style:
                                              TextStyle(color: kSuccessColor),
                                        )),
                                        Icon(
                                          FontAwesomeIcons.whatsapp,
                                          color: kSuccessColor,
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      Modular.to.pop();
                                      _store.inviteContactByWhatsApp(phone);
                                    },
                                  ))
                              .toList(),
                          if (contact.emails.isNotEmpty) ...[
                            SizedBox(height: 18),
                            Text(
                              "E-mail:",
                              style: textTheme.subtitle2,
                            ),
                          ],
                          ...contact.emails
                              .map((email) => FlatButton(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          email,
                                          style: TextStyle(color: kOrangeColor),
                                        )),
                                        Icon(
                                          FontAwesomeIcons.solidEnvelope,
                                          color: kOrangeColor,
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      Modular.to.pop();
                                      _store.inviteContactByEmail(email);
                                    },
                                  ))
                              .toList(),
                        ],
                      ),
                      confirmButton: FlatButton(
                        child: Text("Cancelar"),
                        onPressed: () => Modular.to.pop(),
                      ),
                    );
                  },
          ),
        ),
        title: Text(
          contact.name,
          style: textTheme.subtitle1.copyWith(
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...contact.phones
                .map(
                  (phone) => _renderContactData(
                    displayPhoneFromString(phone),
                    FontAwesomeIcons.mobileAlt,
                  ),
                )
                .toList(),
            ...contact.emails
                .map(
                  (email) => _renderContactData(
                    email,
                    FontAwesomeIcons.envelope,
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _listSection(
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8),
      child: Text(
        text,
        style: textTheme.headline4.copyWith(fontSize: 18),
      ),
    );
  }

  Widget _listText(
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        text,
        style: textTheme.bodyText1,
      ),
    );
  }

  List<Widget> _getListChildren() {
    List<Widget> children = [
      InputSearch(
        controller: _searchInputController,
        label: "pesquise amigos ou contatos...",
      ),
      SizedBox(height: 20),
      if (_store.currentUserFriends.isNotEmpty) ...[
        _listSection("Amigos no Sabiá"),
        if (_store.filteredCurrentUserFriends.isEmpty)
          _renderTextTile(
            "Nenhum amigo encontrado com a pesquisa atual.",
          )
        else
          ..._store.filteredCurrentUserFriends.map(_renderSabiaFriend).toList(),
        SizedBox(height: 40),
      ],
      _listSection("Seus contatos"),
      if (!_store.hasContactsPermission) ...[
        _listText(
          "Conecte seus contatos e descubra quais amigos estão usando o Sabiá!",
        ),
        Button(
          outlined: true,
          label: "Conectar contatos",
          onPressed: _store.requestContactPermission,
        ),
      ],
      if (_store.notFriendContacts.isNotEmpty) ...[
        if (_store.filteredNotFriendContacts.isEmpty)
          _renderTextTile(
            "Nenhum contato encontrado com a pesquisa atual.",
          )
        else
          ..._store.filteredNotFriendContacts.map(_renderContact).toList(),
      ],
    ];

    return children;
  }

  Widget _renderBody() {
    return Observer(
      builder: (_) {
        final children = _getListChildren();
        return ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          itemCount: children.length,
          itemBuilder: (BuildContext context, int index) {
            return children[index];
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrayBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Amigos",
          maxLines: 2,
          style: context.textTheme.headline6.copyWith(
            fontSize: 22,
          ),
        ),
      ),
      body: Observer(
        builder: (_) => _store.isFetching ? LoadingView() : _renderBody(),
      ),
    );
  }
}
