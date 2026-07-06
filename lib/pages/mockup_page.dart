import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/noti_service.dart';

class MockupPage extends StatelessWidget {
  const MockupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        //transparent appbar
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Mockup Page", style: TextStyle(color: Colors.black)),
      ),

      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 247, 222, 222),
                const Color.fromARGB(255, 248, 96, 96),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "This is a mockup page.",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 44, 44, 44),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    NotiService().showNotification(
                      title: "Title",
                      body: "Body",
                    );
                  },
                  child: const Text("Send Notification"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Go Back"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
