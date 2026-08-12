import 'package:flutter/material.dart';

class VocabFlashcardPage extends StatefulWidget {
  const VocabFlashcardPage({super.key});

  @override
  State<VocabFlashcardPage> createState() => _VocabFlashcardPageState();
}

class _VocabFlashcardPageState extends State<VocabFlashcardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vocab Flashcard Page')),
      body: Center(child: Text('Vocab Flashcard Content')),
    );
  }
}
