import 'package:flutter/material.dart';

abstract class CustomTheme {
  bool isNight;
  Color primaryColor;
  Color backgroundColor;
  CustomTheme({this.isNight = true});
  copyWith({isNight}) => this.isNight = isNight;
}

class NightTheme extends CustomTheme {
  NightTheme({isNight = true}) : super(isNight: isNight);
  Color primaryColor = Color(0xFFF5F5F5);
  Color backgroundColor = Colors.grey[900];
}

class DayTheme extends CustomTheme {
  DayTheme({isNight = true}) : super(isNight: isNight);
  Color primaryColor = Colors.grey[900];
  Color backgroundColor = Colors.white;
}
