import 'package:flutter/material.dart';
import 'package:money_manager/pages/Statistics.dart';
import 'package:money_manager/pages/home.dart';
import 'package:money_manager/shared/adaptive_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      theme: getAdaptiveThemeData(context),
      routes: {
        '/': (BuildContext context) => const HomePage(),
        '/stats': (BuildContext context) => const StatsPage(),
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomePage());
      },
    );
  }
}
