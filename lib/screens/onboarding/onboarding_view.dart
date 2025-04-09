import 'package:flutter/material.dart';
import 'package:roupa_nossa/commons/routes.dart';
import 'package:roupa_nossa/screens/onboarding/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 3;

  List<Map<String, dynamic>> onboardingData = [
    {
      'title': 'Bem-vindo ao \n Roupa Nossa',
      'description': 'O aplicativo que conecta quem precisa com quem quer doar roupas.',
      'animation': 'RotatingClothes',
    },
    {
      'title': 'Doe suas roupas',
      'description': 'Fotografe, cadastre e compartilhe as roupas que você não usa mais.',
      'animation': 'DonateAnimation',
    },
    {
      'title': 'Encontre o que precisa',
      'description': 'Busque roupas disponíveis para doação próximas a você.',
      'animation': 'SearchAnimation',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF2196F3),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _numPages,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    title: onboardingData[index]['title'],
                    description: onboardingData[index]['description'],
                    animationType: onboardingData[index]['animation'],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicators
                  Row(
                    children: List.generate(
                      _numPages,
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                  // Next or Get Started button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _numPages - 1) {
                        // Navigate to home screen
                        Navigator.pushReplacementNamed(context, NamedRoutes.auth);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2196F3),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentPage == _numPages - 1 ? 'Começar' : 'Próximo',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}