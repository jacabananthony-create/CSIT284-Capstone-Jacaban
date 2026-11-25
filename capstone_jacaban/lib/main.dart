import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'models/library.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(library: Library()));
}

class MyApp extends StatelessWidget {
  final Library library;
  const MyApp({super.key, required this.library});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Borrowing Tracker',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: HomeScreen(library: library),
    );
  }
}