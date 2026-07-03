import 'package:flutter/material.dart';

class TubeModel {
  final List<Color> balls;

  final int capacity = 4;

  TubeModel({required this.balls});

  bool get isEmpty => balls.isEmpty;
  bool get isFull => balls.length >= capacity;

  Color? get topBall => balls.isNotEmpty ? balls.last : null;

  bool get isSolve {
    if (balls.isEmpty) return true;
    if (balls.length != capacity) return false;
    return balls.every((ball) => ball == balls.first);
  }
}

class BallSortPage extends StatefulWidget {
  const BallSortPage({super.key});

  @override
  State<BallSortPage> createState() => _BallSortPageState();
}

class _BallSortPageState extends State<BallSortPage> {
  List<TubeModel> _tubes = [];

  int? _selectedTubeIndex;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    setState(() {
      _selectedTubeIndex = null;
      _tubes = [
        TubeModel(balls: [Colors.red, Colors.blue, Colors.green, Colors.red]),
        TubeModel(balls: [Colors.red, Colors.green, Colors.red, Colors.blue]),
        TubeModel(
          balls: [Colors.green, Colors.blue, Colors.blue, Colors.green],
        ),
        TubeModel(balls: []),
        TubeModel(balls: []),
      ];
    });
  }

  void _onTubeTab(int index) {
    if (_selectedTubeIndex == null) {
      if (_tubes[index].isEmpty) return;
      setState(() {
        _selectedTubeIndex = index;
      });
    } else {
      int sourceIndex = _selectedTubeIndex!;

      if (sourceIndex == index) {
        setState(() {
          _selectedTubeIndex = null;
        });
        return;
      }
      final sourceTube = _tubes[sourceIndex];
      final targetTube = _tubes[index];

      if (!targetTube.isFull &&
          (targetTube.isEmpty || targetTube.topBall == sourceTube.topBall)) {
        setState(() {
          Color movedBall = sourceTube.balls.removeLast();
          targetTube.balls.add(movedBall);
          _selectedTubeIndex = null;
        });

        _checkWinCondition();
      } else {
        setState(() {
          _selectedTubeIndex = null;
        });
      }
    }
  }

  void _checkWinCondition() {
    bool hasWon = _tubes.every((tube) => tube.isSolve);

    if (hasWon) {
      _showWinDialog();
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          "Congratulations!",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("You've solved the puzzle!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initGame();
            },
            child: Text("Play Again"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        //transparent appbar
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Ball Sort Page", style: TextStyle(color: Colors.black)),
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
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,

                  children: List.generate(_tubes.length, (tubeIndex) {
                    final tube = _tubes[tubeIndex];
                    bool isSelected = _selectedTubeIndex == tubeIndex;

                    return GestureDetector(
                      onTap: () {
                        _onTubeTab(tubeIndex);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 220,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black54,
                                  width: 4,
                                ),
                                right: BorderSide(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black54,
                                  width: 4,
                                ),
                                bottom: BorderSide(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black54,
                                  width: 4,
                                ),
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              color: Colors.white24,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: List.generate(tube.balls.length, (
                                ballIndex,
                              ) {
                                final ballColor = tube.balls.reversed
                                    .toList()[ballIndex];
                                return Container(
                                  width: 44,
                                  height: 44,
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(
                                    color: ballColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Tube ${tubeIndex + 1}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _initGame,
                      icon: Icon(Icons.refresh),
                      label: Text("Reset Game"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text("Go Back"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
