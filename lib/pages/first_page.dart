import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/home_page.dart';
import 'package:flutter_application_2/pages/profile_page.dart';
import 'package:flutter_application_2/pages/settings_page.dart';

class FirstPage extends StatefulWidget {
  FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  //this index keeps track of the current page to display
  int _selectedIndex = 0;

  //this to updates the new selected index
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [
    //homepage
    HomePage(),
    //profilepage
    ProfilePage(),
    //settingspage
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My 1st Flutter"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      drawer: Drawer(
        backgroundColor: Colors.greenAccent[400],
        child: Column(
          children: [
            DrawerHeader(child: Icon(Icons.favorite, size: 48)),

            //homepage
            ListTile(
              leading: Icon(Icons.home),
              title: Text("HOME"),
              onTap: () {
                //pop drawer first
                Navigator.pop(context);
                //go to HomePage
                Navigator.pushNamed(context, '/homepage');
              },
            ),

            //setting page list tile
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("SETTINGS"),
              onTap: () {
                //pop drawer first
                Navigator.pop(context);
                //go to SettingsPage
                Navigator.pushNamed(context, '/settingspage');
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: "Profile"),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
