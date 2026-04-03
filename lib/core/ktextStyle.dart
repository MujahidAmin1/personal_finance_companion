import 'package:flutter/material.dart';

import 'appcolors.dart';

TextStyle kTextStyle ({double fontSize = 15, isBold = false, fontColor = Colors.black}){
  return TextStyle(
    fontSize: fontSize,
    fontWeight: isBold == false ? FontWeight.normal : FontWeight.bold,
    color: fontColor,

  );
}