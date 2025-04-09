import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/cache_record.dart';

class ConnectivityIndicator extends StatefulWidget {
  const ConnectivityIndicator({super.key});

  @override
  State<ConnectivityIndicator> createState() => _ConnectivityIndicatorState();
}

class _ConnectivityIndicatorState extends State<ConnectivityIndicator> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<ConnectivityResult> connectivity =
        Provider.of<List<ConnectivityResult>>(context);

    bool isConnected = [
      ConnectivityResult.wifi,
      ConnectivityResult.mobile,
    ].any((element) => connectivity.contains(element));

    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(seconds: 3000),
      child: Container(
        color: isConnected ? theme.scaffoldBackgroundColor : Colors.deepOrange,
        width: double.infinity,
        child:
            isConnected
                ? SizedBox(width: double.infinity, height: 0)
                : Padding(
                  padding: EdgeInsets.only(
                    top: 4,
                    bottom: MediaQuery.paddingOf(context).bottom,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Sin conexión',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              CacheRecord? record =
                                  objectbox.store
                                      .box<CacheRecord>()
                                      .getAll()
                                      .firstOrNull;

                              if (record == null) return SizedBox();

                              return Text(
                                'Última actualización ${DateFormat('dd/MM/yy hh:mm:ss z').format(record.date)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
