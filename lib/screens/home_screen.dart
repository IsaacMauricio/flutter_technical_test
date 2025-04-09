import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../widgets/image_picker_button.dart';
import 'user_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.paddingOf(context);
    ThemeData theme = Theme.of(context);

    SystemChrome.setSystemUIOverlayStyle(
      theme.appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle(),
    );

    return Scaffold(
      primary: false,
      body: AnimationLimiter(
        child: ListView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: padding.top,
            bottom: padding.bottom + 24,
          ),
          children:
              [
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Builder(
                              builder: (context) {
                                ThemeMode currentThemeMode =
                                    context
                                        .read<ValueNotifier<ThemeMode>>()
                                        .value;

                                return IconButton(
                                  onPressed: () {
                                    context
                                        .read<ValueNotifier<ThemeMode>>()
                                        .value = currentThemeMode.index == 2
                                            ? ThemeMode.values[0]
                                            : ThemeMode.values[currentThemeMode
                                                    .index +
                                                1];
                                  },
                                  icon: Icon(
                                    currentThemeMode == ThemeMode.light
                                        ? Icons.sunny
                                        : currentThemeMode == ThemeMode.dark
                                        ? Icons.bedtime_outlined
                                        : Icons.brightness_4_outlined,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: 72),
                            Row(
                              children: [
                                Image.asset(
                                  theme.brightness == Brightness.light
                                      ? 'assets/images/logo/ios_tinted_dark.png'
                                      : 'assets/images/logo/ios_tinted_light.png',
                                  width: 92,
                                  height: 92,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Text(
                        'Flutter technical Test',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    Text(
                      'Isaac Mauricio',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 128),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserListScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.person),
                      label: Text('Ver usuarios'),
                    ),
                    SizedBox(height: 8),
                    ImagePickerButton.text(),
                  ]
                  .mapIndexed(
                    (index, element) => AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(child: element),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
