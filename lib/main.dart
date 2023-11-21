import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
            appBarTheme:
                const AppBarTheme(color: Colors.white, elevation: 0.0)),
        home: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/beautiful-mountains.jpg"),
                fit: BoxFit.cover),
          ),
          child: const HomeScreen(),
        ));
  }
}
