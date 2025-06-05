import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color.fromARGB(
    255,
    7,
    1,
    27,
  ); // Deep dark purple
  static const Color card = Color(0xFF2A2A40); // Slightly lighter for cards

  // Neon Accents
  static const Color neonPurple = Color.fromARGB(
    255,
    177,
    93,
    255,
  ); // Neon purple accent
  static const Color neonBlue = Color.fromARGB(
    255,
    85,
    130,
    255,
  ); // Cyan-blue glow
  static const Color neonGreen = Color.fromARGB(
    255,
    75,
    243,
    9,
  ); // Matrix green
  static const Color neonPink = Color.fromARGB(
    255,
    255,
    80,
    220,
  ); // Optional neon pink

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;

  // Button Colors
  static const Color button = Color.fromARGB(255, 162, 68, 250);
  static const Color buttonText = Colors.black;

  // Focus Timer Ring (Optional)
  static const Color timerRing = neonBlue;

  // Shadows & Glow
  static const Color glow = neonBlue;
}
