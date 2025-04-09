import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roupa_nossa/components/donations/grid/grid_donation.dart';
import 'package:roupa_nossa/screens/donations/create/donations_create.dart';

class AllDonationsScreen extends StatefulWidget {
  const AllDonationsScreen({Key? key}) : super(key: key);

  @override
  State<AllDonationsScreen> createState() => _AllDonationsScreenState();
}

class _AllDonationsScreenState extends State<AllDonationsScreen> {
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
  final List<Map<String, dynamic>> _donations = [
    {
      'id': '1',
      'title': 'Camiseta Azul',
      'category': 'Camisetas',
      'size': 'M',
      'description': 'Camiseta azul em bom estado, pouco usada.',
      'imageUrl':
          'https://images.tcdn.com.br/img/img_prod/978582/camiseta_poliester_azul_royal_p_linha_sublima_brasil_2143_1_25dda3f2548c3bcba314654a02c7ced8.png',
      'donorName': 'Maria S.',
      'donatedAt': '2023-05-15',
      'phoneNumber': '5543998142217',
    },
    {
      'id': '2',
      'title': 'Calça Jeans',
      'category': 'Calças',
      'size': '42',
      'description': 'Calça jeans masculina, seminova.',
      'imageUrl':
          'https://rivierawear.com.br/cdn/shop/files/S7818ae00b9084262835f54fff6d61f1fU.jpg?v=1688494129',
      'donorName': 'João P.',
      'donatedAt': '2023-05-14',
      'phoneNumber': '5543998142217',
    },
    {
      'id': '3',
      'title': 'Tênis Esportivo',
      'category': 'Calçados',
      'size': '39',
      'description': 'Tênis para corrida, usado poucas vezes.',
      'imageUrl':
          'https://energyexpress.com.br/cdn/shop/products/tenis-esportivo-casual-masculino-branco-light-bound-moda-053-938_800x.jpg?v=1632319697',
      'donorName': 'Ana C.',
      'donatedAt': '2023-05-13',
      'phoneNumber': '5543998142217',
    },
    {
      'id': '4',
      'title': 'Vestido Vermelho',
      'category': 'Vestidos',
      'size': 'G',
      'description': 'Vestido vermelho pra ficar chique.',
      'imageUrl':
          'https://images.unsplash.com/photo-1612336307429-8a898d10e223?ixlib=rb-4.0.3&auto=format&fit=crop&w=1374&q=80',
      'donorName': 'Carla M.',
      'donatedAt': '2023-05-12',
      'phoneNumber': '5543998142217',
    },
    {
      'id': '5',
      'title': 'Boné Preto',
      'category': 'Outros',
      'size': 'Único',
      'description': 'Boné preto ajustável, como novo.',
      'imageUrl':
          'https://static.dafiti.com.br/p/Resina-Bon%C3%A9-Liso-B%C3%A1sico-Resina-6-Gomos-Aba-Curva-Snapback-Regul%C3%A1vel-Chap%C3%A9u-Preto-6880-84505031-1-zoom.jpg',
      'donorName': 'Pedro S.',
      'donatedAt': '2023-05-11',
      'phoneNumber': '5543998142217',
    },
    {
      'id': '6',
      'title': 'Camiseta Listrada',
      'category': 'Camisetas',
      'size': 'P',
      'description': 'Camiseta listrada em preto e branco.',
      'imageUrl':
          'https://images.tcdn.com.br/img/img_prod/497460/camiseta_listrada_949_1_7030684ffef0bf63d6f7064e0120c982.jpeg',
      'donorName': 'Lucia R.',
      'donatedAt': '2023-05-10',
      'phoneNumber': '5543998142217',
    },
  ];

  List<Map<String, dynamic>> get filteredDonations {
    if (_selectedCategory == 'Todos') {
      return _donations;
    } else {
      return _donations
          .where((donation) => donation['category'] == _selectedCategory)
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
        return DonationGridItem(donation: filteredDonations[index]);
      },
    );
  }
}
