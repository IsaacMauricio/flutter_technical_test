import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'theme.dart';

class TechnicalTest extends StatelessWidget {
  const TechnicalTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: context.watch<ValueNotifier<ThemeMode>>().value,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: HomeScreen(),
    );
  }
}
