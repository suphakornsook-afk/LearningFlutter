import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/counter_page.dart';
import 'package:flutter_application_2/pages/first_page.dart';
import 'package:flutter_application_2/pages/home_page.dart';
import 'package:flutter_application_2/pages/profile_page.dart';
import 'package:flutter_application_2/pages/settings_page.dart';
import 'package:flutter_application_2/pages/soundboard_page.dart';
import 'package:flutter_application_2/pages/mockup_page.dart';
import 'package:flutter_application_2/pages/cookie_page.dart';
import 'package:flutter_application_2/pages/memoryGame_page.dart';
import 'package:flutter_application_2/pages/ball_sort_page.dart';
import 'package:flutter_application_2/pages/pill_tracker_page.dart';
import 'package:flutter_application_2/pages/noti_service.dart';
import 'package:flutter_application_2/pages/todo_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_2/pages/food_random_page.dart';
import 'package:flutter_application_2/pages/number_guessing_page.dart';
import 'package:flutter_application_2/pages/goods_sort_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init notifications
  await NotiService().initNotification();

  await Hive.initFlutter();
  var box = await Hive.openBox('noteBox');

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
        '/profilepage': (context) => ProfilePage(),
        '/counterpage': (context) => CounterPage(),
        '/settingspage': (context) => SettingsPage(),
        '/soundboardpage': (context) => SoundboardPage(),
        '/mockuppage': (context) => MockupPage(),
        '/cookiepage': (context) => CookiePage(),
        '/memorygamepage': (context) => MemoryGamePage(),
        '/ballsortpage': (context) => BallSortPage(),
        '/pilltrackerpage': (context) => PillTrackerPage(),
        '/todopage': (context) => TodoPage(),
        '/foodrandompage': (context) => FoodRandomPage(),
        '/numberguessingpage': (context) => NumberGuessingPage(),
        '/goodssortpage': (context) => GoodsSortPage(),
      },
    );
  }
}
