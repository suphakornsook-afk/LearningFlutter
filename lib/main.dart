import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("My 1st Flutter")),
        drawer: Drawer(
          backgroundColor: Colors.greenAccent[400],
          child: Column(
            children: [
              DrawerHeader(child: Icon(Icons.favorite, size: 48)),

              //homepage
              ListTile(leading: Icon(Icons.home), title: Text("HOME")),

              //setting page list tile
              ListTile(leading: Icon(Icons.settings), title: Text("SETTINGS")),
            ],
          ),
        ),

        body: GridView.builder(
          itemCount: 64,
          gridDelegate:
              //how mayny in each row
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: (context, index) =>
              Container(color: Colors.redAccent, margin: EdgeInsets.all(2)),
        ),
      ),
    );
  }
}
