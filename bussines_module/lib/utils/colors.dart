import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: const Color(0xFF6FFFE9),
  primaryColorDark: const Color(0xFF3A506B),
  secondaryHeaderColor: const Color(0xFF5BC0BE),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  textTheme: TextTheme(
    bodySmall: GoogleFonts.roboto(color: const Color(0xFF3A506B)),
    bodyMedium: GoogleFonts.roboto(color: const Color(0xFF757575)),
    bodyLarge: GoogleFonts.roboto(color: const Color(0xFFBDBDBD)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF6FFFE9),
    titleTextStyle: GoogleFonts.roboto(color: const Color(0xFF3A506B)),
  ),
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFF5F5F5),
    error: Color(0xFFD32F2F),
    secondary: Color(0xFF5BC0BE),
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: const Color(0xFF0B132B),
  primaryColorDark: const Color(0xFF1C2541),
  secondaryHeaderColor: const Color(0xFF3A506B),
  scaffoldBackgroundColor: const Color(0xFF0B132B),
  textTheme: TextTheme(
    bodySmall: GoogleFonts.roboto(color: const Color(0xffFBFBFF)),
    bodyMedium: GoogleFonts.roboto(color: const Color(0xffFBFBFF)),
    bodyLarge: GoogleFonts.roboto(color: const Color(0xffFBFBFF)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF0B132B),
    titleTextStyle:
        GoogleFonts.roboto(color: const Color(0xffFBFBFF), fontSize: 20),
    centerTitle: true,
  ),
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF0B132B),
    error: Color(0xFFEF5350),
  ),
);
