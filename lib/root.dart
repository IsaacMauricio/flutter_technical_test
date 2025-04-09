import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'technical_test.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<ConnectivityResult>>(
          initialData: [],
          create: (context) => Connectivity().onConnectivityChanged,
          updateShouldNotify: (previous, current) => true,
        ),
        ChangeNotifierProvider(
          create: (context) => ValueNotifier(ThemeMode.system),
        ),
      ],
      child: TechnicalTest(),
    );
  }
}
