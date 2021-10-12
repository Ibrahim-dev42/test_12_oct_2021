import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_12_oct_2021/auth/provider/home_provider.dart';
import 'package:test_12_oct_2021/utils/NavKey.dart';
import 'package:test_12_oct_2021/utils/app_routes.dart';

import 'auth/view/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

var routes = <String, WidgetBuilder>{
  AppRoutes.routesHome: (c) => HomeScreen(),
};

class MyApp extends StatelessWidget {
  Locale _appLocale = Locale('en');

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));
    return MultiProvider(
        builder: (context, widget) => MaterialApp(
            navigatorKey: NavKey.navKey,
            locale: _appLocale,
            supportedLocales: [
              const Locale('en', ''), // English
            ],
            theme: ThemeData(
                primaryColor: Colors.white,
                accentColor: Colors.white,
                unselectedWidgetColor: Colors.grey,
                highlightColor: Colors.white),
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.routesHome,
            routes: routes),
        providers: [
          ChangeNotifierProvider(
            create: (_) => HomeProvider(_),
          ),
        ]);
  }
}
