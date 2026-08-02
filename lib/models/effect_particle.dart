class EffectParticle {
  final double x;
  final double y;
  final String text;
  final double fontSize;
  final bool isScoreText;
  bool isFinished = false;

  EffectParticle({
    required this.x,
    required this.y,
    required this.text,
    required this.fontSize,
    this.isScoreText = false,
  });
}
