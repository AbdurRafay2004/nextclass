import 'package:flutter/material.dart';

/// Converts a hex color string (e.g., '#87CEEB' or '87CEEB') to a [Color].
Color hexToColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

/// Converts a [Color] to a hex string (e.g., '#87CEEB').
String colorToHex(Color color) {
  return '#${color.toARGB32().toRadixString(16).substring(2, 8).toUpperCase()}';
}
