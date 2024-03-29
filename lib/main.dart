import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/database-provider.dart';
import 'package:weatherapp/providers/selected-city-provider.dart';
import 'package:weatherapp/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SelectedCityProvider>(
            create: (context) => SelectedCityProvider()),
        ChangeNotifierProvider<DatabaseProvider>(
            create: (context) => DatabaseProvider.instance),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // title: 'Weather App',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Colors.white, elevation: 0.0),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
