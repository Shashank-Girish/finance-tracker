import 'package:expense_tracker/screens/category_page.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/models/database_provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DatabaseProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/category',
      routes: {
        // '/': (context) => const HomePage(),
        '/category': (context) => const CategoryPage(),
        // '/entry': (context) => const EntryPage(),
      },
    );
  }
}
