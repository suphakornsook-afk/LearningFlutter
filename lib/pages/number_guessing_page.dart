import 'package:flutter/material.dart';
import 'dart:math';

class NumberGuessingPage extends StatefulWidget {
  const NumberGuessingPage({super.key});

  @override
  State<NumberGuessingPage> createState() => _NumberGuessingPageState();
}

class _NumberGuessingPageState extends State<NumberGuessingPage> {
  final Random _random = Random();
  final TextEditingController _controller = TextEditingController();

  late int targetNumber;
  String hintMessage = "Try Guess 1 to 100!";

  @override
  void initState() {
    super.initState();
    targetNumber = _random.nextInt(100) + 1;
  }

  void checkGuess() {
    final String input = _controller.text;
    if (input.isEmpty) return;

    final int? guessedNumber = int.tryParse(input);

    if (guessedNumber == null || guessedNumber < 1 || guessedNumber > 100) {
      setState(() {
        hintMessage = "Type only 1 to 100!";
      });
      return;
    }
    setState(() {
      if (guessedNumber < targetNumber) {
        hintMessage = "Too low! Try Again";
      } else if (guessedNumber > targetNumber) {
        hintMessage = "Too high! Try Again";
      } else {
        hintMessage = "Correct!! The Number is $targetNumber 🎉";
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Number Guessing Game"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
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
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hintMessage,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                SizedBox(height: 40),
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: '??',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: checkGuess,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('ส่งคำตอบ', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
