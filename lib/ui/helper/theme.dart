import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const COLOR_PRIMARY = Colors.white;
final COLOR_ACCENT = Color(0xff0f92d9);

final kLightTheme = ThemeData.light().copyWith(
    primaryColor: COLOR_PRIMARY,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: COLOR_PRIMARY,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: COLOR_ACCENT,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // <-- Radius
        ),)
    ),
    iconTheme: IconThemeData(
      color: COLOR_ACCENT,
    )
);

final kDarkTheme = ThemeData.dark().copyWith(
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      // Status bar color
      statusBarColor: Colors.red,
      // Status bar brightness (optional)
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.light, // For iOS (dark icons)
    ),
  ),

);