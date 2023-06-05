import 'package:flutter/material.dart';


const textStyleForInput = TextStyle(color: Color(0xff9a9fa3));

const inputColor = Color(0xfff1f2f5);
final enabledBorder =  OutlineInputBorder(
    borderSide: const  BorderSide(width: 15, color: inputColor),
    borderRadius: BorderRadius.circular(15.0)
);

final focusedBorder = OutlineInputBorder(
borderSide: const  BorderSide(width: 15, color: inputColor),
borderRadius: BorderRadius.circular(15.0)
);