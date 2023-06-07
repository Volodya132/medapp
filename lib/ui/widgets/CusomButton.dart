import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final String text;
  final Widget? child;

  const CustomButton({super.key, required this.onPressed, this.icon, required this.text, this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: child ?? Row (
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null? Icon(icon) : Container(),
            icon != null? const SizedBox(width: 5) : Container(),
            Text(text),
          ],
        ));
  }
}
