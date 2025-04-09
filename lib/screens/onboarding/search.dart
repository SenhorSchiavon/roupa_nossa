import 'package:flutter/material.dart';

class SearchAnimation extends StatefulWidget {
  const SearchAnimation({Key? key}) : super(key: key);

  @override
  State<SearchAnimation> createState() => _SearchAnimationState();
}

class _SearchAnimationState extends State<SearchAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _moveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      lowerBound: 0,
      upperBound: 1,
    );

    _moveAnimation = Tween<double>(begin: -100, end: 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Adiciona um listener para inverter a direção
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward(); // Inicia a animação indo para a direita
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
              Image.asset(
                'assets/images/tshirt3.png',
                width: 150,
                height: 150,
                colorBlendMode: BlendMode.srcIn,
              ),
              Transform.translate(
                offset: Offset(_moveAnimation.value, 0),
                child: Image.asset(
                  'assets/images/magnifying_glass.png',
                  width: 150,
                  height: 150,
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
