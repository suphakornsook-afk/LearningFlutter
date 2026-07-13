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
  Color hintColor = Colors.purple;
  bool hasWon = false;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    setState(() {
      targetNumber = _random.nextInt(100) + 1;
      hintMessage = "Try Guess 1 to 100!";
      hintColor = Colors.purple;
      hasWon = false;
      _controller.clear();
    });
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
        hintMessage = "$guessedNumber is Too low! Try Again";
        hintColor = Colors.blue[900]!;
      } else if (guessedNumber > targetNumber) {
        hintMessage = "$guessedNumber is too high! Try Again";
        hintColor = Colors.amber[900]!;
      } else {
        hintMessage = "Correct!! The Number is $targetNumber 🎉";
        hintColor = Colors.green[800]!;
        hasWon = true;
      }
    });
    _controller.clear();
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
                Container(
                  padding: const EdgeInsets.all(28.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                        child: Text(
                          hintMessage,
                          key: ValueKey<String>(hintMessage),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: hintColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 30),
                      if (!hasWon) ...[
                        SizedBox(
                          width: 140,
                          child: TextField(
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                            decoration: InputDecoration(
                              hintText: '??',
                              hintStyle: TextStyle(
                                color: Colors.purple.withOpacity(0.3),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.purpleAccent,
                                  width: 2.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: checkGuess,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 3,
                            ),
                            child: const Text(
                              'ส่งคำตอบ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (hasWon) ...[
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: startNewGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 3,
                            ),
                            icon: const Icon(Icons.refresh),
                            label: const Text(
                              'Restart!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
