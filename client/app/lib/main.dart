import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Views/user/login_view.dart';
import 'Views/user/sign_up_view.dart';

import 'ar_hooks_tap_measurement.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('ja');
  // TODO: 実機用にカメラ機能をオンにする
  // final cameras = await availableCameras();
  const firstCamera = null; //cameras.first;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userName = prefs.getString('userName');
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Noto Sans JP',
      ),
      home: TapMeasurementPage(),
      //userName == null ? SignUpView(camera:camera) : LoginView(camera: camera),
    );
  }
}
