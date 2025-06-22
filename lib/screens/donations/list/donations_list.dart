// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:roupa_nossa/components/donations/grid/grid_donation.dart';
import 'package:roupa_nossa/components/donations/single/single_view.dart';
import 'package:roupa_nossa/components/ui/search_input/search_input.dart';
import 'package:roupa_nossa/screens/donations/create/donations_create.dart';
import 'package:roupa_nossa/services/doacoes/doacaoService.dart';

class AllDonationsScreen extends StatefulWidget {
  final String? filter;
  const AllDonationsScreen({Key? key, this.filter}) : super(key: key);

  @override
  State<AllDonationsScreen> createState() => _AllDonationsScreenState();
}

class _AllDonationsScreenState extends State<AllDonationsScreen> {
  List<Map<String, dynamic>> _donations = [];
  bool _isLoading = true;
  String _searchTerm = '';
  String _selectedCategory = 'Todos';
  final DoacaoService _doacaoService = DoacaoService();
  Future<List<Map<String, dynamic>>> fetchRoupas() async {
    try {
      return await _doacaoService.fetchRoupas();
    } catch (e) {
      print('Erro ao buscar roupas: $e');
      return [];
    }
  }

  final List<String> _categories = [
    'Todos',
    'Camisetas',
    'Calças',
    'Calçados',
    'Vestidos',
    'Outros',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isLoading) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final initialFilter = args is String ? args : widget.filter;

      fetchRoupas().then((data) {
        setState(() {
          _donations = data;
          _isLoading = false;

          if (initialFilter != null && _categories.contains(initialFilter)) {
            _selectedCategory = initialFilter;
          }
        });
      });
    }
  }

  List<Map<String, dynamic>> get filteredDonations {
    final filteredByCategory =
        _selectedCategory == 'Todos'
            ? _donations
            : _donations.where((donation) {
              final roupa = donation['roupa'];
              if (roupa == null) return false;
              return roupa['categoria']?.toString().toLowerCase() ==
                  _selectedCategory.toLowerCase();
            }).toList();

    if (_searchTerm.isEmpty) return filteredByCategory;

    final search = _searchTerm.trim().toLowerCase();

    return filteredByCategory.where((donation) {
      final roupa = donation['roupa'];
      if (roupa == null) return false;

      return roupa['nome']?.toString().toLowerCase().contains(search) == true ||
          roupa['descricao']?.toString().toLowerCase().contains(search) ==
              true ||
          roupa['categoria']?.toString().toLowerCase().contains(search) == true;
    }).toList();
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
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                'Todas as Doações',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SearchInput(
                  onChanged: (value) {
                    setState(() {
                      _searchTerm = value;
                    });
                  },
                ),
              ),
            ],
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

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => DonationDetailsScreen(
                      donation: filteredDonations[index], // ✅ Aqui está o fix
                    ),
              ),
            );
          },
          child: DonationGridItem(donation: filteredDonations[index]),
        );
      },
    );
  }
}
