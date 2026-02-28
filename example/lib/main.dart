import 'package:fat_markdown/fat_markdown.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    final isDark = _themeMode == ThemeMode.system
        ? View.of(context).platformDispatcher.platformBrightness ==
              Brightness.dark
        : _themeMode == ThemeMode.dark;

    setState(() {
      _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeMode == ThemeMode.system
        ? View.of(context).platformDispatcher.platformBrightness ==
              Brightness.dark
        : _themeMode == ThemeMode.dark;

    return MaterialApp(
      title: 'Fat Markdown Example',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        extensions: [
          FatMarkdownTheme(tableStretch: true),
        ],
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        extensions: const [
          FatMarkdownTheme(tableStretch: true),
        ],
      ),
      home: HomePage(
        isDark: isDark,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}
