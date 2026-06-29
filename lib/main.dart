import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/counter_page.dart';
import 'package:flutter_application_2/pages/first_page.dart';
import 'package:flutter_application_2/pages/home_page.dart';
import 'package:flutter_application_2/pages/profile_page.dart';
import 'package:flutter_application_2/pages/settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
      routes: {
        '/firstpage': (context) => FirstPage(),
        '/homepage': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/counterpage': (context) => CounterPage(),
        '/settingspage': (context) => SettingsPage(),
      },
    );
  }
}
