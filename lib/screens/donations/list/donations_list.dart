import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roupa_nossa/components/donations/grid/grid_donation.dart';
import 'package:roupa_nossa/screens/donations/create/donations_create.dart';
import 'package:roupa_nossa/services/doacoes/get_doacoes.dart';

class AllDonationsScreen extends StatefulWidget {
  const AllDonationsScreen({Key? key}) : super(key: key);

  @override
  State<AllDonationsScreen> createState() => _AllDonationsScreenState();
}

class _AllDonationsScreenState extends State<AllDonationsScreen> {
  List<Map<String, dynamic>> _donations = [];
  bool _isLoading = true;
  String _selectedCategory = 'Todos';
  final List<String> _categories = [
    'Todos',
    'Camisetas',
    'Calças',
    'Calçados',
    'Vestidos',
    'Outros',
  ];

  // Sample data - replace with your actual data source
  @override
  void initState() {
    super.initState();
    fetchRoupas().then((data) {
      setState(() {
        _donations = data;
        _isLoading = false;
      });
    });
  }

  List<Map<String, dynamic>> get filteredDonations {
    if (_selectedCategory == 'Todos') {
      return _donations;
    } else {
      return _donations
          .where((donation) => donation['categoria'] == _selectedCategory)
          .toList();
    }
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
              _buildHeader(),
              const SizedBox(height: 16),
              _buildCategoryFilter(),
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
                      child:
                          filteredDonations.isEmpty
                              ? _buildEmptyState()
                              : _buildDonationsGrid(),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          const Text(
            'Todas as Doações',
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

  Widget _buildCategoryFilter() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color:
                      isSelected ? Colors.white : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      color:
                          isSelected ? const Color(0xFF2196F3) : Colors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Nenhuma doação encontrada',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),

      itemCount: filteredDonations.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65, // Tente ajustar aqui (ex: 0.6 ~ 0.75)
      ),
      itemBuilder: (context, index) {
        // Protege contra 'roupa' null
        print(filteredDonations[index]);

        return DonationGridItem(donation: filteredDonations[index]);
      },
    );
  }
}
