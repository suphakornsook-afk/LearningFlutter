import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  double percent = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress Page')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: percent / 100,
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.green,
                  minHeight: 10,
                ),
              ),
              SizedBox(height: 20),
              Slider(
                value: percent,
                min: 0,
                max: 100,
                divisions: 100,
                label: "${percent.round()}",
                onChanged: (value) {
                  setState(() {
                    percent = value;
                  });
                },
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                value: percent / 100,
                backgroundColor: Colors.grey.shade200,
                color: Colors.blue,
                strokeWidth: 8,
              ),
              SizedBox(height: 20),
              CustomPaint(
                size: Size(200, 100),
                // painter: _ProgressPageState(progress: percent),
                child: SizedBox(
                  width: 200,
                  height: 100,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "cannot apply semi-circle today, cause need package, so I will apply it tomorrow",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
