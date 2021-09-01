import 'package:flutter/material.dart';

import 'commons.dart';

final appTheme = ThemeData(
  primaryColor: Commons.bgColor,
  primarySwatch: MaterialColor(
    0xFF4CAF50,
    <int, Color>{
      50: Color(0xFFE8F5E9),
      100: Color(0xFFC8E6C9),
      200: Color(0xFFA5D6A7),
      300: Color(0xFF81C784),
      400: Color(0xFF66BB6A),
      500: Color(0xFF4CAF50),
      600: Color(0xFF43A047),
      700: Color(0xFF388E3C),
      800: Color(0xFF2E7D32),
      900: Color(0xFF1B5E20),
    },
  ),
  unselectedWidgetColor: Colors.white,
  accentIconTheme: IconThemeData(color: Commons.bgColor),
  textTheme: const TextTheme(bodyText1: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w400)),
  iconTheme: IconThemeData(color: Commons.bgColor),
  fontFamily: 'Nunito',
  hintColor: Commons.hintColor,
);
