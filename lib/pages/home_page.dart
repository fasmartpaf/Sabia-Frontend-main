import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sabia_app/components/general/unread_marker.dart';
import 'package:sabia_app/components/icon/app_icon.dart';
import 'package:sabia_app/components/image/svg_image.dart';
import 'package:sabia_app/components/loading/loading_view.dart';
import 'package:sabia_app/modules/friends_module/friends_module.dart';
import 'package:sabia_app/modules/user/user_module.dart';
import 'package:sabia_app/modules/user/user_library_module.dart';
import 'package:sabia_app/routes/app_routes.dart';
import 'package:sabia_app/services/payments_with_stores_service.dart';
import 'package:sabia_app/stores/auth_store.dart';
import 'package:sabia_app/stores/book_store.dart';
import 'package:sabia_app/stores/notifications_store.dart';
import 'package:sabia_app/utils/styles.dart';
import './notifications_page.dart';
import '../modules/feed_module/pages/feed_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthStore _authStore;
  final _pageController = PageController();
  final InAppPurchaseClass _inAppPurchaseClass =
      Modular.get<InAppPurchaseClass>();

  @override
  void initState() {
    super.initState();
    this._authStore = Modular.get<AuthStore>();
    _pageController.addListener(_pageIndexListener);
    checkPaymaents();
  }

  Future<void> checkPaymaents() async {
    try {
      await _inAppPurchaseClass.initInAppPurchase();
      await _inAppPurchaseClass.checkStatus();
      if (!_inAppPurchaseClass.userPremium.value) {
        await this._authStore.logout();
        await Modular.to.navigator.pushReplacementNamed(APP_ROUTE.LOGIN.path);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  dispose() {
    _pageController.removeListener(_pageIndexListener);
    super.dispose();
  }

  void _pageIndexListener() {
    // hack to dispose UserModule, refreshing _renderBody() when page index change
    setState(() {});
  }

  void onChangeCurrentPage(int index) {
    if (index > 4) {
      this._didWantToAdd();
      return;
    }
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _didWantToAdd() {
    Modular.get<BookStore>().setSelectedBookForFormId("new");
  }

  int get _currentPageIndex {
    if (!_pageController.hasClients) return 0;

    return _pageController.page?.round() ?? 0;
  }

  Widget renderModuleRouter(
    ChildModule module, {
    @required int index,
  }) {
    if (this._currentPageIndex != index) {
      return LoadingView();
    }
    return RouterOutlet(module: module);
  }

  Widget _renderBody() => PageView(
        controller: _pageController,
        children: [
          FeedPage(),
          NotificationsPage(),
          renderModuleRouter(
            UserLibraryModule(),
            index: 2,
          ),
          renderModuleRouter(
            FriendsModule(),
            index: 3,
          ),
          renderModuleRouter(
            UserModule(onChangeHomePageIndex: onChangeCurrentPage),
            index: 4,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (!_authStore.isAuthenticated) return LoadingView();
        return Scaffold(
          body: _renderBody(),
          bottomNavigationBar: AnimatedBuilder(
            animation: _pageController,
            builder: (_, __) => BottomNavigationBar(
              currentIndex: _currentPageIndex,
              onTap: onChangeCurrentPage,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              selectedItemColor: kSuccessColor,
              items: [
                BottomNavigationBarItem(
                  icon: SVGImage(
                    "birdhouse",
                    color: _currentPageIndex == 0
                        ? kSuccessColor
                        : kGrayInactiveColor,
                  ),
                  label: "Sobre",
                ),
                BottomNavigationBarItem(
                  icon: Observer(
                    builder: (_) => Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        SVGImage(
                          "sound",
                          color: _currentPageIndex == 1
                              ? kSuccessColor
                              : kGrayInactiveColor,
                        ),
                        if (Modular.get<NotificationsStore>().hasAnyUnread)
                          Positioned(
                            top: -10,
                            right: -10,
                            child: UnreadMarker(),
                          ),
                      ],
                    ),
                  ),
                  label: "Notificações",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.book,
                    size: _currentPageIndex == 2 ? 22 : 20,
                    color: _currentPageIndex == 2
                        ? kSuccessColor
                        : kGrayInactiveColor,
                  ),
                  label: "Biblioteca",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.users,
                    size: _currentPageIndex == 3 ? 22 : 20,
                    color: _currentPageIndex == 3
                        ? kSuccessColor
                        : kGrayInactiveColor,
                  ),
                  label: "Amigos",
                ),
                BottomNavigationBarItem(
                  icon: SVGImage(
                    "chick",
                    color: _currentPageIndex == 4
                        ? kSuccessColor
                        : kGrayInactiveColor,
                  ),
                  label: "Perfil",
                ),
                BottomNavigationBarItem(
                  icon: FloatingActionButton(
                    mini: true,
                    backgroundColor: kOrangeColor,
                    child: Icon(AddIcon),
                    onPressed: this._didWantToAdd,
                  ),
                  label: "Adicionar livro",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
