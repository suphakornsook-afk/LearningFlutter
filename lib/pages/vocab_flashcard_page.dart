import 'package:flutter/material.dart';
import 'dart:math';
import '../data/vocab.dart';

class VocabFlashcardPage extends StatefulWidget {
  const VocabFlashcardPage({super.key});

  @override
  State<VocabFlashcardPage> createState() => _VocabFlashcardPageState();
}

class _VocabFlashcardPageState extends State<VocabFlashcardPage> {
  Vocab? _currentVocab;

  @override
  void _randomizeVocab() {
    if (vocabList.isEmpty) return;
    final random = Random();
    int newIndex;

    do {
      newIndex = random.nextInt(vocabList.length);
    } while (vocabList.length > 1 &&
        vocabList[newIndex] == _currentVocab &&
        _currentVocab != null);

    setState(() {
      _currentVocab = vocabList[newIndex];
    });
  }

  void initState() {
    super.initState();
    _randomizeVocab();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Vocab Flashcard Page'),
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 253, 228, 198),
                ),
              ),
            ),
            Center(
              child: Container(
                width: double.infinity,
                height: 250,
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 232, 240),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        _currentVocab?.word ?? "Loading...",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 20,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(20),
                              backgroundColor: const Color(0xFFE65388),
                              foregroundColor: Colors.white,
                              elevation: 5,
                            ),
                            child: Icon(Icons.restart_alt, size: 20),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(20),
                              backgroundColor: const Color(0xFF73F3D0),
                              foregroundColor: Colors.white,
                              elevation: 5,
                            ),
                            child: Icon(Icons.play_arrow, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
