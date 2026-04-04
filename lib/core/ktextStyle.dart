import 'package:flutter/material.dart';

TextStyle kTextStyle({double fontSize = 15, bool isBold = false, Color fontColor = Colors.black}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    color: fontColor,
  );
}