import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color primaryColorLight = Colors.teal;
Color primaryColorDark = Colors.tealAccent;

ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: primaryColorLight,
  appBarTheme: AppBarTheme(
    centerTitle: false,

    surfaceTintColor: Colors.transparent,
    color: Colors.grey.shade200,
    elevation: 1,
    scrolledUnderElevation: 1,

    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  cardTheme: CardTheme(elevation: 1, color: Colors.grey.shade100),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColorLight,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: primaryColorLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
  ),
  scaffoldBackgroundColor: Colors.white,
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: primaryColorDark,
  appBarTheme: AppBarTheme(
    centerTitle: false,
    surfaceTintColor: Colors.transparent,
    color: Colors.grey.shade800,
    elevation: 1,
    scrolledUnderElevation: 1,

    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  ),
  cardTheme: CardTheme(elevation: 1, color: Colors.grey.shade900),
  textButtonTheme: TextButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: primaryColorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColorDark,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
  ),

  scaffoldBackgroundColor: Colors.black,
);
