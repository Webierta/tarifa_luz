import 'package:flutter/material.dart';

class StyleApp {
  static const BoxDecoration mainDecoration = BoxDecoration(
    gradient: RadialGradient(
      colors: [
        Color.fromARGB(255, 255, 251, 218),
        // Color(0xFFFFFFFF),
        Color(0xFFE3F2FD),
        Color(0xFF64B5F6),
        Color(0xFF1E88E5),
        Color(0xFF0D47A1)
      ],
      radius: 0.9,
      center: Alignment.topRight,
      stops: [0.1, 0.3, 0.5, 0.7, 0.9],
    ),
  );

  static const BoxDecoration kBoxDeco = BoxDecoration(
    color: Color.fromRGBO(255, 255, 255, 0.1),
    border: Border(
      bottom: BorderSide(color: Color(0xFF1565C0), width: 1.5),
      left: BorderSide(color: Color(0xFF1565C0), width: 1.5),
    ),
  );

  static const ShapeBorderClipper kBorderClipper = ShapeBorderClipper(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );

  static const TextStyle sizeText20 = TextStyle(fontSize: 20.0);

  static const TextStyle size22Black =
      TextStyle(fontSize: 22.0, color: Colors.black);

  static const Color accentColor = Color(0xFFFFDE03);
}
