import 'package:flutter/material.dart';
import 'package:roupa_nossa/screens/chat/list_chat.dart';
import 'package:roupa_nossa/screens/donations/create/donations_create.dart';
import 'package:roupa_nossa/screens/donations/list/donations_list.dart';
import 'package:roupa_nossa/screens/home/home_view.dart';
import 'package:roupa_nossa/screens/perfil/pefil_view.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  final String userName;
  const MainScreen({super.key, required this.userName});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> get _pages => [
    HomeView(
      userName: widget.userName,
      onVerTodasPressed: () {
        setState(() {
          _selectedIndex = 1;
        });
      },
      onProfilePressed: () {
        setState(() {
          _selectedIndex = 3;
        });
      },
    ),
    AllDonationsScreen(),
    ChatListScreen(),
    PerfilView(),
    DonationRegistrationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      extendBody: true, // Important for curved navigation bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: StylishBottomBar(
          option: AnimatedBarOptions(
            // Use AnimatedBar for a more modern look
            barAnimation: BarAnimation.fade,
            iconStyle: IconStyle.animated,
          ),
          items: [
            BottomBarItem(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              title: const Text('Home'),
              backgroundColor: Colors.blue,
              selectedColor: Colors.blue,
            ),
            BottomBarItem(
              icon: const Icon(Icons.search_outlined),
              selectedIcon: const Icon(Icons.search),
              title: const Text('Buscar'),
              backgroundColor: Colors.blue,
              selectedColor: Colors.blue,
            ),

            BottomBarItem(
              icon: const Icon(Icons.chat_outlined),
              selectedIcon: const Icon(Icons.chat),
              title: const Text('Chats'),
              backgroundColor: Colors.blue,
              selectedColor: Colors.blue,
            ),
            BottomBarItem(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              title: const Text('Perfil'),
              backgroundColor: Colors.blue,
              selectedColor: Colors.blue,
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          fabLocation: StylishBarFabLocation.center,
          hasNotch: true,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white.withOpacity(0.9)],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DonationRegistrationScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add_shopping_cart, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
