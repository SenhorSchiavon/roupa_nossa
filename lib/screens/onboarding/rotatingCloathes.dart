import 'package:flutter/material.dart';
import 'dart:math' as math;

class RotatingClothesAnimation extends StatefulWidget {
  const RotatingClothesAnimation({Key? key}) : super(key: key);

  @override
  State<RotatingClothesAnimation> createState() => _RotatingClothesAnimationState();
}

class _RotatingClothesAnimationState extends State<RotatingClothesAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Primeira camisa
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Image.asset(
                  'assets/images/tshirt1.png',
                  color: Colors.white.withOpacity(0.8),
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),
              // Segunda camisa com leve deslocamento

            ],
          );
        },
      ),
    );
  }
}