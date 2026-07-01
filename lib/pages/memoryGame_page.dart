import 'package:flutter/material.dart';

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({super.key});

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  final List<IconData> _cardIcons = [
    Icons.favorite,
    Icons.favorite,
    Icons.star,
    Icons.star,
    Icons.face,
    Icons.face,
    Icons.home,
    Icons.home,
    Icons.alarm,
    Icons.alarm,
    Icons.lightbulb,
    Icons.lightbulb,
    Icons.cake,
    Icons.cake,
    Icons.pets,
    Icons.pets,
  ];

  List<bool> _cardFlipped = [];

  List<bool> _cardMatched = [];

  int? _firstCardIndex;
  bool _isBusy = false;

  void _resetGame() {
    _cardIcons.shuffle();
    _cardFlipped = List.generate(_cardIcons.length, (index) => false);
    _cardMatched = List.generate(_cardIcons.length, (index) => false);
    _firstCardIndex = null;
    _isBusy = false;
  }

  void _onCardTap(int index) async {
    if (_cardFlipped[index] || _cardMatched[index] || _isBusy) return;

    setState(() {
      _cardFlipped[index] = true;
    });

    if (_firstCardIndex == null) {
      _firstCardIndex = index;
    } else {
      int firstIndex = _firstCardIndex!;

      if (_cardIcons[firstIndex] == _cardIcons[index]) {
        setState(() {
          _cardMatched[firstIndex] = true;
          _cardMatched[index] = true;
          _firstCardIndex = null;
        });

        if (_cardMatched.every((matched) => matched)) {
          _showWinDialog();
        }
      } else {
        _isBusy = true;
        Future.delayed(Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _cardFlipped[_firstCardIndex!] = false;
              _cardFlipped[index] = false;
              _firstCardIndex = null;
              _isBusy = false;
            });
          }
        });
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("You Win!"),
          content: Text("Congratulations! You've matched all the cards."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _resetGame();
                });
              },
              child: Text("Play Again"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        //transparent appbar
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Memory Game", style: TextStyle(color: Colors.black)),
      ),

      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 152, 248, 222),
                const Color.fromARGB(255, 152, 248, 96),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  Expanded(
                    child: GridView.builder(
                      itemCount: _cardIcons.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                      ),
                      itemBuilder: (context, index) {
                        bool showFront =
                            _cardFlipped[index] || _cardMatched[index];
                        return GestureDetector(
                          onTap: () {
                            // Handle card tap
                            _onCardTap(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: showFront
                                  ? Colors.white
                                  : const Color.fromARGB(255, 34, 112, 90),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: showFront
                                  ? Icon(
                                      _cardIcons[index],
                                      size: 32,
                                      color: Colors.teal,
                                    )
                                  : const Icon(
                                      Icons.question_mark,
                                      size: 32,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _resetGame();
                      });
                    },
                    child: const Text("Reset Game"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
