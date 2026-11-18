import 'package:flutter/material.dart';

import 'models/library.dart';
import 'screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Library library = Library();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Borrowing Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: HomeScreen(library: library),
    );
  }
}