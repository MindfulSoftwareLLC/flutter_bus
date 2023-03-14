import 'package:flutter/material.dart';
import 'package:flutter_bus/flutter_bus.dart';
import 'package:theme_changed_event/current_theme_name.dart';

import 'theme_changed_event.dart';
import 'themes.dart';

ThemeChangedEvent nextThemeChangedEvent(int initialThemeIndex) {
  return ThemeChangedEvent(
      themeSeedColorNames[initialThemeIndex],
      ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
              seedColor: themeSeedColors[initialThemeIndex])),
      ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
              seedColor: themeSeedColors[initialThemeIndex],
              brightness: Brightness.dark)));
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterBusBuilder<ThemeChangedEvent>(
      builder: (context, themeEvent) {
        //Since no initialData is supplied,
        // the event will be null for the first build() only
        ThemeData lightTheme;
        ThemeData darkTheme;
        if (themeEvent == null) {
          lightTheme = ThemeData.light();
          darkTheme = ThemeData.dark();
        } else {
          lightTheme = themeEvent.lightTheme;
          darkTheme = themeEvent.darkTheme;
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FlutterBus ThemeChangedEvent Demo',
          theme: lightTheme,
          darkTheme: darkTheme,
          home: const MyHomePage(title: 'FlutterBus ThemeChangedEvent Demo'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _themeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: CurrentThemeText(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_themeIndex == themeSeedColors.length - 1) {
            _themeIndex = 0;
          } else {
            _themeIndex++;
          }
          FlutterBus.publish(nextThemeChangedEvent(_themeIndex));
        },
        tooltip: 'Change Themes',
        child: const Icon(Icons.color_lens_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
