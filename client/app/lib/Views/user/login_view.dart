import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Usecases/provider.dart';
import '../home_view.dart';

class LoginView extends HookConsumerWidget {
  final CameraDescription? camera;
  const LoginView({super.key, required this.camera});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNameController = useTextEditingController(text: '');
    final passwordController = useTextEditingController(text: '');

    Future<void> putLogin() async {
      final url = Uri.parse('http://192.168.2.152:8080/login');
      final headers = {'Content-Type': 'application/json'};
      final requestBody = jsonEncode({
        'username': userNameController.text,
        'password': passwordController.text,
      });
      try {
        final response =
            await http.post(url, headers: headers, body: requestBody);
        final jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          // ホーム画面へ
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeView(camera: camera),
            ),
          );
          final userId = jsonResponse['user_id'];
          ref.read(userIdProvider.notifier).state = userId;
          ref.read(userNameProvider.notifier).state = userNameController.text;
        } else {
          final msg = jsonResponse['detail'];
          // エラーダイアログ
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Failed to Login: $msg'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        // エラーダイアログ
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Undefined Error: $e'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

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
                onPressed: () async {
                  if (userNameController.text == '') return;
                  putLogin();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
