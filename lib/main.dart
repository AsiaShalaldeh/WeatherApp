import 'package:flutter/material.dart';
import 'package:weatherapp/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
            appBarTheme:
                const AppBarTheme(color: Colors.white, elevation: 0.0)),
        home: Container(
          height: double.infinity,
          width: double.infinity,
          // constraints: BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/beautiful-mountains.jpg"),
                fit: BoxFit.cover),
          ),
          child: HomeScreen(),
        ));
  }
}
