import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String text) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('An error accurred'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(text),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
