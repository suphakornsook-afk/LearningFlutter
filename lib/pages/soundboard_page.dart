import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SoundboardPage extends StatefulWidget {
  const SoundboardPage({super.key});

  @override
  State<SoundboardPage> createState() => _SoundboardPageState();
}

class _SoundboardPageState extends State<SoundboardPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, String>> _soundButtons = [
    {'title': 'surprise', 'file': '/soundEffect/surprise.mp3'},
    {'title': 'fart', 'file': '/soundEffect/fart.mp3'},
    {'title': 'joke drum', 'file': '/soundEffect/joke_drum.mp3'},
  ];

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSoundEffect(String fileName) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(fileName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Soundboard"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: _soundButtons.map((buttonData) {
            return ElevatedButton(
              onPressed: () => _playSoundEffect(buttonData['file']!),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.music_note, size: 40),
                  SizedBox(height: 10),
                  Text(
                    buttonData['title']!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
