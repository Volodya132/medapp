import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show(BuildContext context, String message,
      { required String actionLabel, required VoidCallback onAction }) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: actionLabel,
        onPressed: onAction,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}