import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String _text;
  VoidCallback onPressed;
  MyButton({super.key, required this._text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.white70,
      child: Text(_text),
    );
  }
}
