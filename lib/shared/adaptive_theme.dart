import 'dart:io';
import 'package:flutter/material.dart';

final ThemeData _androidTheme = ThemeData(
    primarySwatch: Colors.orange,
    brightness: Brightness.light,
    indicatorColor: Colors.grey,
    primaryColor: Colors.blueAccent,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.deepPurple,
      textTheme: ButtonTextTheme.primary,
    ),
    listTileTheme: ListTileThemeData(selectedTileColor: Colors.amber[100]));

final ThemeData _iOSTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  primaryColor: Colors.blueAccent,
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.deepPurple,
    textTheme: ButtonTextTheme.primary,
  ),
);

ThemeData getAdaptiveThemeData(context) {
  return Platform.isAndroid ? _androidTheme : _iOSTheme;
}
