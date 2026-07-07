import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/util/my_button.dart';

class DialogBox extends StatelessWidget {
  const DialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 120,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new note",
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(text: "Add", onPressed: () {}),
                MyButton(text: "cancel", onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
