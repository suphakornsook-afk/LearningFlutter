import 'package:flutter/material.dart';
import 'dart:math';
import 'util/skill_card.dart';

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
  int currentLevel = 1;
  int guessCount = 0;

  List<SkillCardData> myHandSkills = [];
  List<SkillCardData> rolledSkills = [];
  bool isSelectingPerk = false;

  List<Color> bgColors = [
    const Color.fromARGB(255, 247, 222, 222),
    const Color.fromARGB(255, 248, 96, 96),
  ];

  bool isShieldActive = false;
  bool isHotAndColdActive = false;

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
      hintMessage =
          "Level: $currentLevel | Try Guess $minNumber to $maxNumber!";
      hintColor = Colors.purple;
      hasWon = false;
      isSelectingPerk = false;
      isShieldActive = false;
      isHotAndColdActive = false;
      guessCount = 0;
      _controller.clear();
    });
  }

  void rollThreeSkills() {
    final allSkills = getAvailableSkills(context);

    allSkills.shuffle();
    setState(() {
      rolledSkills = allSkills.take(3).toList();
      isSelectingPerk = true;
    });
  }

  void useScanAreaSkill() {
    if (hasWon) return;
    setState(() {
      int range = maxNumber - minNumber;
      int reduction = (range * 0.1).round();
      if (minNumber + reduction < targetNumber) minNumber += reduction;
      if (maxNumber - reduction > targetNumber) maxNumber -= reduction;
      hintMessage =
          "Skill Activated: Scanned Area!\nNew Range: $minNumber to $maxNumber";
      hintColor = Colors.deepOrange;
    });
  }

  void changeBackgroundColors() {
    // รายการคู่สี Gradient สวย ๆ ไว้สุ่มเปลี่ยน
    final colorPresets = [
      [const Color(0xFFE0F7FA), const Color(0xFF00ACC1)], // ฟ้า-น้ำเงิน
      [const Color(0xFFE8F5E9), const Color(0xFF43A047)], // เขียวเหนี่ยวทรัพย์
      [const Color(0xFFFFF3E0), const Color(0xFFFB8C00)], // ส้มพาสเทล
      [const Color(0xFFF3E5F5), const Color(0xFF8E24AA)], // ม่วงลึกลับ
      [const Color(0xFFECEFF1), const Color(0xFF546E7A)], // เทามินิมอล
    ];
    setState(() {
      // สุ่มเลือกคู่สีใหม่
      bgColors = colorPresets[_random.nextInt(colorPresets.length)];
      hintMessage = "Background Changed!";
      hintColor = Colors.blueGrey[800]!;
    });
  }

  void useTimeStoneSkill() {
    setState(() {
      guessCount = (guessCount - 2).clamp(0, double.infinity).toInt();

      hintMessage =
          "Time Stone Activated!\nRewinded 2 turns. Current Guesses: $guessCount";
      hintColor = Colors.cyan[700]!;
    });
  }

  void useShieldSkill() {
    setState(() {
      isShieldActive = true;
      hintMessage =
          "The Shield Activated!\nYour next wrong guess will not count!";
      hintColor = Colors.blue[700]!;
    });
  }

  void useHotAndColdSkill() {
    setState(() {
      isHotAndColdActive = true;
      hintMessage =
          "Hot & Cold Radar Activated!\nYour next guess will reveal the temperature distance!";
      hintColor = Colors.deepOrangeAccent;
    });
  }

  void checkGuess() {
    setState(() {
      guessCount++;
    });

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
        if (isShieldActive) {
          isShieldActive = false;
          hintMessage += " (Shield Absorbed!)";
        } else {
          guessCount++;
        }
        if (isHotAndColdActive) {
          isHotAndColdActive = false; // ใช้แล้วหมดไป
          int distance = (targetNumber - guessedNumber).abs();
          if (distance <= 5) {
            hintMessage +=
                "\n Temperature: 🔥 Burning Hot! (inside a 5 radius)";
          } else if (distance <= 15) {
            hintMessage += "\n Temperature: ☀️ Warm (inside a 15 radius)";
          } else {
            hintMessage += "\n Temperature: ❄️ Cold (outside a 15 radius)";
          }
        }
      } else if (guessedNumber > targetNumber) {
        hintMessage = "$guessedNumber is too high! Try Again";
        hintColor = Colors.amber[900]!;
        if (isShieldActive) {
          isShieldActive = false;
          hintMessage += " (Shield Absorbed!)";
        } else {
          guessCount++;
        }
        if (isHotAndColdActive) {
          isHotAndColdActive = false; // ใช้แล้วหมดไป
          int distance = (targetNumber - guessedNumber).abs();
          if (distance <= 5) {
            hintMessage +=
                "\n Temperature: 🔥 Burning Hot! (inside a 5 radius)";
          } else if (distance <= 15) {
            hintMessage += "\n Temperature: ☀️ Warm (inside a 15 radius)";
          } else {
            hintMessage += "\n Temperature: ❄️ Cold (outside a 15 radius)";
          }
        }
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
      currentLevel++;

      const num decayRate = 0.7;
      num factor = pow(decayRate, guessCount - 1);
      num bonus = (maxNumber / 2) * factor;
      maxNumber = maxNumber + bonus.round();

      isSelectingPerk = false;
    });
  }

  void playCard(int index) {
    //Activate Card Effect
    myHandSkills[index].action(this);

    setState(() {
      //After use card remove it
      myHandSkills.removeAt(index);
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
              colors: bgColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Container(
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
                      mainAxisSize: MainAxisSize.min,
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
                                  leading: Icon(
                                    skill.icon,
                                    color: Colors.purple,
                                  ),
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
                                  borderRadius: BorderRadiusGeometry.circular(
                                    16,
                                  ),
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
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (myHandSkills.isNotEmpty && !hasWon)
                        const Text(
                          "Your Hand Cards",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(blurRadius: 5, color: Colors.black),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(myHandSkills.length, (index) {
                            final skill = myHandSkills[index];
                            return GestureDetector(
                              onTap: () => playCard(index),
                              child: Container(
                                width: 85,
                                height: 110,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.purple,
                                    width: 2,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      skill.icon,
                                      color: Colors.purple,
                                      size: 28,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      skill.name,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Tap to Use",
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
