import 'package:calculadora/pages/calculator.pages.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 213, 212, 217),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'serif',
            color: Colors.black,
            fontSize: 24,
          ),
          color: Color.fromARGB(255, 39, 28, 31),
        ),
      ),
      home: CalculatorPage(),
    );
  }
}
