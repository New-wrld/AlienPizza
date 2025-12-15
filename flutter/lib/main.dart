import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mainbody.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color _seedColor = Colors.lightBlue;

  @override
  void initState() {
    super.initState();
    _loadThemeColor();
  }

  Future<void> _loadThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getString('theme_color');
    if (colorValue != null) {
      setState(() {
        _seedColor = Color(int.parse(colorValue, radix: 16));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlienPizza',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
      ),
      home: MyHomePage(
        title: 'AlienPizza',
        onThemeChanged: _loadThemeColor,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.onThemeChanged});
  final String title;
  final VoidCallback onThemeChanged;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MainBody(
      title: widget.title,
      onThemeChanged: widget.onThemeChanged,
    );
  }
}