import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:sabia_app/utils/styles.dart';
import './components/close_keyboard_gesture_detector.dart';
import './routes/app_routes.dart';
import 'package:oktoast/oktoast.dart';

class App extends StatelessWidget {
  final bool isProductionServer;

  const App({
    Key key,
    this.isProductionServer,
  }) : super(key: key);

  List<NavigatorObserver> _getNavigatorObservers() {
    if (this.isProductionServer) {
      return [
        FirebaseAnalyticsObserver(analytics: Modular.get<FirebaseAnalytics>()),
      ];
    }
    return [];
  }

  ThemeData _getTheme(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ThemeData(
      buttonColor: kOrangeColor,
      buttonTheme: ButtonThemeData(
        buttonColor: kOrangeColor,
        textTheme: ButtonTextTheme.accent,
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.white),
      ),
      textTheme: GoogleFonts.ralewayTextTheme(
        textTheme,
      )
          .apply(
            bodyColor: kTextColor,
            displayColor: kTextColor,
          )
          .copyWith(
            headline6: GoogleFonts.bentham(
              textStyle: textTheme.headline6.copyWith(),
            ),
            headline5: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            subtitle1: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            subtitle2: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12,
            ),
          )
          .apply(
            bodyColor: kTextColor,
            displayColor: kTextColor,
          ),
      backgroundColor: kYellowBackgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      position: ToastPosition.bottom,
      handleTouth: true,
      dismissOtherOnShow: true,
      child: CloseKeyboardGestureDetector(
        child: MaterialApp(
          title: 'Sabia',
          theme: _getTheme(context),
          debugShowCheckedModeBanner: false,
          initialRoute: APP_ROUTE.LOGIN.path,
          onGenerateRoute: Modular.generateRoute,
          navigatorKey: Modular.navigatorKey,
          navigatorObservers: _getNavigatorObservers(),
        ),
      ),
    );
  }
}
