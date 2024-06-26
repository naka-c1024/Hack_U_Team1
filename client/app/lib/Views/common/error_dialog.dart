import 'package:flutter/material.dart';

Widget errorDialog(BuildContext context, String message) {
  return AlertDialog(
    title: const Text('Error'),
    content: Text(message),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('OK'),
      ),
    ],
  );
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return errorDialog(context, message);
    },
  );
}
