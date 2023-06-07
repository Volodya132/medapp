import 'package:flutter/material.dart';

import '../helper/inputConstants.dart';


class InputWidget extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onIconPressed;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final bool obscureText;
  final validator;

  const InputWidget({Key? key, IconData? this.icon, this.onIconPressed, this.hintText, this.onChanged, this.obscureText =false, this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      decoration: InputDecoration(
          prefixIcon: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: onIconPressed,
            icon: Icon(icon)),
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          filled: true,
          hintStyle: textStyleForInput,
          hintText: hintText,
          fillColor: inputColor),
      onChanged: onChanged,
      obscureText: obscureText,
      validator: validator,

    );
  }
}