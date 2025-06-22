import 'package:flutter/material.dart';
import 'package:roupa_nossa/components/donations/grid/grid_donation.dart';
import 'package:roupa_nossa/components/donations/single/single_view.dart';
import 'package:roupa_nossa/services/doacoes/doacaoService.dart';
import 'package:roupa_nossa/services/interesses/interesseService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDonationsScreen extends StatefulWidget {
  const MyDonationsScreen({Key? key}) : super(key: key);

  @override
  State<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> _favoritedDonations = [];
  List<Map<String, dynamic>> _myDonations = [];
  List<Map<String, dynamic>> _receivedDonations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) setState(() {});
    });

    _fetchDonations();
  }

  Future<void> _fetchDonations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('id')?.toString() ?? '';

      final data = await DoacaoService().fetchRoupas();
      final recebidasRaw = await DoacaoService().fetchDoacoesFinalizadas();

      final favoritos = await InteresseService().getFavoritosByUsuario(
        int.parse(userId),
      );

      final minhas =
          data
              .where(
                (d) =>
                    d['usuario']['id'].toString() == userId &&
                    d['foiDoada'] == false,
              )
              .toList();

      final recebidas =
          recebidasRaw
              .where((d) => d['usuario']['id'].toString() == userId)
              .toList();

      setState(() {
        _myDonations = minhas;
        _receivedDonations = recebidas;
        _favoritedDonations = favoritos;
        _isLoading = false;
      });
    } catch (e, stack) {
      print('❌ Erro ao buscar doações: $e');
      print(stack);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildTabBar(),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildDonationsList(_favoritedDonations, 'favoritas'),
                          _buildDonationsList(_myDonations, 'doadas'),
                          _buildDonationsList(_receivedDonations, 'recebidas'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Minhas Doações',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          for (int i = 0; i < 3; i++)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _tabController.animateTo(i);
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        _tabController.index == i
                            ? Colors.white
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  margin: const EdgeInsets.all(4),
                  child: Center(
                    child: Text(
                      i == 0
                          ? 'Favoritas'
                          : i == 1
                          ? 'Ativas'
                          : 'Finalizadas',
                      style: TextStyle(
                        color:
                            _tabController.index == i
                                ? const Color(0xFF2196F3)
                                : Colors.white,
                        fontWeight:
                            _tabController.index == i
                                ? FontWeight.bold
                                : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Then in your build method, replace the TabBarView with:

  Widget _buildDonationsList(
    List<Map<String, dynamic>> donations,
    String type,
  ) {
    if (donations.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma doação $type encontrada.',
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: donations.length,
      itemBuilder: (context, index) {
        final donation = donations[index];
        return DonationGridItem(
          donation: donation,
          onTap: () async {
            final updated = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DonationDetailsScreen(donation: donation),
              ),
            );

            if (updated == true) {
              await _fetchDonations();
            }
          },
        );
      },
    );
  }
}
