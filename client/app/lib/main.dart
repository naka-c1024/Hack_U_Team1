import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/Views/login_view.dart';
import 'package:app/Views/sign_up_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: userName == null ? SignUpView(camera:camera) : LoginView(camera: camera),
    );
  }
}
