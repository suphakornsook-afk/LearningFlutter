import 'package:flutter/material.dart';
import '../../models/effect_particle.dart';

class AnimatedSparkle extends StatefulWidget {
  final EffectParticle particle;

  const AnimatedSparkle({super.key, required this.particle});

  @override
  State<AnimatedSparkle> createState() => _AnimatedSparkleState();
}

class _AnimatedSparkleState extends State<AnimatedSparkle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetY;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _offsetY = Tween<double>(
      begin: 0,
      end: -60,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _scale = Tween<double>(
      begin: 0.5,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward().then((_) {
      widget.particle.isFinished = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.particle.x,
          top: widget.particle.y + _offsetY.value,
          child: Opacity(
            opacity: _opacity.value,
            child: Transform.scale(
              scale: _scale.value,
              child: widget.particle.isScoreText
                  ? Text(
                      widget.particle.text,
                      style: const TextStyle(
                        color: Color(0xFFFFD54F),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 8),
                          Shadow(color: Colors.amber, blurRadius: 16),
                        ],
                      ),
                    )
                  : Text(
                      widget.particle.text,
                      style: TextStyle(fontSize: widget.particle.fontSize),
                    ),
            ),
          ),
        );
      },
    );
  }
}
