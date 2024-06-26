import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Views/user/login_view.dart';
import 'Views/user/sign_up_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('ja');
  // TODO: 実機用にカメラ機能をオンにする
  // final cameras = await availableCameras();
  final firstCamera = null; //cameras.first;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userName = prefs.getString('userName');
  runApp(
    ProviderScope(
      child: MyApp(userName: userName, camera: firstCamera),
    ),
  );
}

class ThemeColors {
  static const Color keyGreen = Color(0xFF75D000);
  static const Color keyRed = Color(0xFFE55B20);
  static const Color black = Color(0xFF131313);
  static const Color lineGray1 = Color(0xFFA8A8A8);
  static const Color lineGray2 = Color(0xFF3E3E3E);
  static const Color textGray1 = Color(0xFF636363);
  static const Color bgGray1 = Color(0xFFD9D9D9);
  static const Color bgGray2 = Color(0xFFC4C4C4);
  static const Color bgGray3 = Color(0xFFF2F2F2);
}

class MyApp extends StatelessWidget {
  final String? userName;
  final CameraDescription? camera;
  const MyApp({
    required this.userName,
    required this.camera,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hack U team 1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ThemeColors.keyGreen),
        primaryColor: ThemeColors.keyGreen,
        splashColor: ThemeColors.bgGray1,
        useMaterial3: true,
        fontFamily: 'Noto Sans JP',
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            splashFactory: InkRipple.splashFactory,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale("ja")],
      home: userName == null
          ? SignUpView(camera: camera)
          : LoginView(camera: camera),
    );
  }
}
