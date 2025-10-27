import 'package:flutter/material.dart';

class ScreenSize {
  static late double width;
  static late double height;
  static initialize(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }
}
