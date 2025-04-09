import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roupa_nossa/components/categories/button/button_categories.dart';
import 'package:roupa_nossa/components/donations/lastest_donations/lastest_donations_screen.dart';
import 'package:roupa_nossa/components/ui/search_input/search_input.dart';
import 'package:roupa_nossa/components/banner_home/banner.dart';

class HomeView extends StatefulWidget {
  final VoidCallback? onVerTodasPressed;
  final VoidCallback? onProfilePressed;
  final String userName;

  const HomeView({
    super.key,
    this.onVerTodasPressed,
    this.onProfilePressed,
    required this.userName,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<Map<String, dynamic>> _categorias = [
    {'name': 'Camisetas', 'iconPath': 'assets/icons/camisa.svg'},
    {'name': 'Calças', 'iconPath': 'assets/icons/calca.svg'},
    {'name': 'Calçados', 'iconPath': 'assets/icons/sapato.svg'},
    {'name': 'Vestidos', 'iconPath': 'assets/icons/vestido.svg'},
    {'name': 'Outros', 'iconPath': 'assets/icons/outros.svg'},
  ];

  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Doe roupas, transforme vidas',
      'description':
          'Suas doações podem fazer a diferença na vida de muitas pessoas',
      'color': const Color(0xFF2196F3),
      'icon': Icons.favorite,
    },
    {
      'title': 'Campanha de Inverno',
      'description': 'Ajude a aquecer quem precisa neste inverno',
      'color': const Color(0xFF4CAF50),
      'icon': Icons.ac_unit,
    },
    {
      'title': 'Roupas Infantis',
      'description': 'Precisamos de doações para crianças de todas as idades',
      'color': const Color(0xFFFFC107),
      'icon': Icons.child_care,
    },
  ];

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2196F3),
              const Color(0xFF2196F3).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              _buildHeader(),
              const SizedBox(height: 8),
              _buildSearchAndNotifications(),
              const SizedBox(height: 16),
              BannerHome(
                bannerController: _bannerController,
                banners: _banners,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          'Categorias',
                          onSeeAllPressed: () {},
                        ),
                        const SizedBox(height: 16),
                        ButtonCategorias(categorias: _categorias),
                        const SizedBox(height: 32),
                        _buildSectionHeader(
                          'Últimas doações',
                          onSeeAllPressed: () {},
                        ),
                        const SizedBox(height: 16),
                        const LatestDonations(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espaço no final da lista
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.recycling,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Roupa Nossa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Compartilhe o que não usa mais',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              if (widget.onProfilePressed != null) {
                widget.onProfilePressed!();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndNotifications() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Expanded(child: SearchInput()),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    required VoidCallback onSeeAllPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            if (widget.onVerTodasPressed != null) {
              widget.onVerTodasPressed!();
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF2196F3),
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Ver todas', style: TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}
