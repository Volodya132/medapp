import 'package:flutter/material.dart';

import '../helper/inputConstants.dart';


class InputWidget extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onIconPressed;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final bool obscureText;
  final validator;
  final bool readOnly;
  final VoidCallback? onTap;

  final TextEditingController? controller;

  const InputWidget({Key? key, IconData? this.icon, this.onIconPressed, this.hintText, this.onChanged, this.obscureText =false, this.validator, this.readOnly = false, this.onTap, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: controller,
      onTap: onTap,
      readOnly: readOnly,
      decoration: InputDecoration(
          prefixIcon:icon != null ?IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: onIconPressed,
            icon: Icon(icon)) : null,
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