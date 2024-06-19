import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../home_view.dart';

class LoginView extends HookConsumerWidget {
  final CameraDescription? camera;
  const LoginView({super.key, required this.camera});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNameController = useTextEditingController(text: '');
    final passwordController = useTextEditingController(text: '');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text('ユーザー名'),
              TextField(
                controller: userNameController,
                onSubmitted: (String value) {
                  userNameController.text = value;
                },
              ),
              const SizedBox(height: 24),
              const Text('パスワード'),
              TextField(
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.text,
                onSubmitted: (String value) {
                  passwordController.text = value;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                child: Container(
                  height: 40,
                  width: 120,
                  alignment: Alignment.center,
                  child: const Text(
                    'ログイン',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                onPressed: () {
                  // ホーム画面へ
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeView(camera: camera),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
