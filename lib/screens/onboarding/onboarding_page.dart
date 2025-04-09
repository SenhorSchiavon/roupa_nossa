import 'package:flutter/material.dart';
import 'package:roupa_nossa/screens/onboarding/donate.dart';
import 'package:roupa_nossa/screens/onboarding/rotatingCloathes.dart';
import 'package:roupa_nossa/screens/onboarding/search.dart';


class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String animationType;

  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.animationType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: _buildAnimation(animationType),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimation(String type) {
    switch (type) {
      case 'RotatingClothes':
        return const RotatingClothesAnimation();
      case 'DonateAnimation':
        return const DonateAnimation();
      case 'SearchAnimation':
        return const SearchAnimation();
      default:
        return const SizedBox.shrink();
    }
  }
}