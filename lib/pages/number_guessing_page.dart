import 'package:flutter/material.dart';
import 'util/skill_card.dart';
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

  int minNumber = 1;
  int maxNumber = 100;

  List<SkillCardData> myHandSkills = [];
  List<SkillCardData> rolledSkills = [];
  bool isSelectingPerk = false;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    setState(() {
      minNumber = 1;
      maxNumber = 100;
      targetNumber = _random.nextInt(maxNumber) + minNumber;
      hintMessage = "Try Guess $minNumber to $maxNumber!";
      hintColor = Colors.purple;
      hasWon = false;
      isSelectingPerk = false;
      _controller.clear();
    });
  }

  void rollThreeSkills() {
    final allSkills = getAvailableSkills(
      context,
      onScanActive: useScanAreaSkill,
    );

    allSkills.shuffle();
    setState(() {
      isSelectingPerk = true;
      rolledSkills = allSkills.take(3).toList();
    });
  }

  void useScanAreaSkill() {
    if (hasWon) return;
    setState(() {
      int range = maxNumber - minNumber;
      int reduction = (range * 0.1).round();
      if (minNumber - reduction < targetNumber) {
        minNumber += reduction;
      }
      if (maxNumber - reduction > targetNumber) {
        maxNumber -= reduction;
      }
      hintMessage =
          "Skill Activated: Scaned Area!\nNew Range: $minNumber to $maxNumber";
      hintColor = Colors.deepOrange;
    });
  }

  void checkGuess() {
    final String input = _controller.text;
    if (input.isEmpty) return;

    final int? guessedNumber = int.tryParse(input);

    if (guessedNumber == null ||
        guessedNumber < minNumber ||
        guessedNumber > maxNumber) {
      setState(() {
        hintMessage = "Type only $minNumber to $maxNumber!";
        hintColor = Colors.redAccent;
      });
      return;
    }
    setState(() {
      if (guessedNumber < targetNumber) {
        hintMessage = "$guessedNumber is Too low! Try Again";
        hintColor = Colors.blue[900]!;
        if (guessedNumber >= minNumber) minNumber = guessedNumber + 1;
      } else if (guessedNumber > targetNumber) {
        hintMessage = "$guessedNumber is too high! Try Again";
        hintColor = Colors.amber[900]!;
        if (guessedNumber <= maxNumber) maxNumber = guessedNumber - 1;
      } else {
        hintMessage = "Correct!! The Number is $targetNumber 🎉";
        hintColor = Colors.green[800]!;
        hasWon = true;
        rollThreeSkills();
      }
    });
    _controller.clear();
  }

  void selectSkill(SkillCardData selected) {
    setState(() {
      myHandSkills.add(selected);
      isSelectingPerk = false;
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
                      if (!hasWon && !isSelectingPerk) ...[
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

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

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
                      if (hasWon && isSelectingPerk) ...[
                        const Text(
                          "Choose 1 Skill Perk!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: rolledSkills.map((skill) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              color: Colors.purple[50],
                              child: ListTile(
                                leading: Icon(skill.icon, color: Colors.purple),
                                title: Text(
                                  skill.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(skill.description),
                                onTap: () => selectSkill(skill),
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      if (hasWon && !isSelectingPerk) ...[
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: startNewGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.arrow_forward),
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
