import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Domain/theme_color.dart';
import 'Views/user/login_view.dart';
import 'Views/user/sign_up_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('ja');
  // TODO: 実機用にカメラ機能をオンにする
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userName = prefs.getString('userName');
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(
    ProviderScope(
      child: MyApp(userName: userName, camera: firstCamera),
    ),
  );
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
