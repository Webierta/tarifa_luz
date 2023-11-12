import 'package:flutter/material.dart';

class StyleApp {
  static const primaryColor = Color(0xff2196f3);
  static const primaryColorOpacity01 = Color(0x1a2196f3);
  static const primaryColorOpacity05 = Color(0x802196f3);
  static const primaryColorOpacity07 = Color(0xb32196f3);
  static const primaryColorOpacity08 = Color(0xcc2196f3);

  static const primaryContainer = Color(0xff2196f3);
  static const secondaryContainer = Color(0xff2196f3);
  static const primaryContainerOpacity01 = Color(0x1a2196f3);
  static const primaryContainerOpacity05 = Color(0x802196f3);
  static const primaryContainerOpacity07 = Color(0xb32196f3);
  static const primaryContainerOpacity08 = Color(0xcc2196f3);

  static const onBackgroundColor = Color(0xffffffff);
  static const backgroundColor = Color(0xFF263238);
  // Color(0xff90caf9);

  static const blueGrey50 = Color(0xFFECEFF1);
  static const blueGrey100 = Color(0xFFCFD8DC);
  static const blueGrey200 = Color(0xFFB0BEC5);
  static const blueGrey300 = Color(0xFF90A4AE);
  static const blueGrey400 = Color(0xFF78909C);
  static const blueGrey = Color(0xFF607D8B);
  static const blueGrey600 = Color(0xFF546E7A);
  static const blueGrey700 = Color(0xFF455A64);
  static const blueGrey800 = Color(0xFF37474F);
  static const blueGrey900 = Color(0xFF263238);

  static const BoxDecoration mainDecoration = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: [
          0.2,
          0.5,
          0.8,
          0.7
        ],
        colors: [
          primaryContainerOpacity01,
          primaryContainerOpacity05,
          primaryContainerOpacity08,
          primaryContainerOpacity07
        ]),
  );

  static const BoxDecoration kBoxDeco = BoxDecoration(
    color: Color.fromRGBO(255, 255, 255, 0.1),
    border: Border(
      bottom: BorderSide(color: blueGrey400, width: 1.5),
      left: BorderSide(color: blueGrey400, width: 1.5),
    ),
  );

  static const ShapeBorderClipper kBorderClipper = ShapeBorderClipper(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );

  static const Color accentColor = Color(0xFFFFDE03);
}
