import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  double progress = 0.0;
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
                painter: _SemiCirclePainter(progress: percent),
                child: SizedBox(
                  width: 200,
                  height: 100,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "${(percent).toInt()}%",
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

class _SemiCirclePainter extends CustomPainter {
  final double progress;
  _SemiCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    const strokeWidth = 14.0;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      3.14,
      3.14,
      false,
      backgroundPaint,
    );

    final progressPaint = Paint()
      ..color = const Color(0xFF52C273)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      3.14,
      3.14 * (progress / 100),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SemiCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
