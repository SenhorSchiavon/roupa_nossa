import 'package:flutter/material.dart';
import 'package:roupa_nossa/components/donations/grid/grid_donation.dart';

class MyDonationsScreen extends StatefulWidget {
  const MyDonationsScreen({Key? key}) : super(key: key);

  @override
  State<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _favoritedDonations = [
    {
      'id': '1',
      'nome': 'Blusa de Lã Cinza',
      'categoria': 'Blusas',
      'tamanho': 'M',
      'descricao': 'Blusa quente e confortável, ideal para o inverno.',
      'imagemUrl':
          'https://down-br.img.susercontent.com/file/6d3540e7267fd24696e58174c7b1e305',
      'doador': 'Maria S.',
      'donatedAt': '2023-05-10',
      'phoneNumber': '5511999999999',
    },
    {
      'id': '2',
      'nome': 'Camisa Social Branca',
      'categoria': 'Camisas',
      'tamanho': 'G',
      'descricao': 'Camisa de algodão branca, pouco usada.',
      'imagemUrl':
          'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcTyzYBfltS7lct8oRsgcv4XyyZr1DZgqiB-LkRHFS_6v3ybA5T5f6w9kcWc940nozPsDVsegJ0auEtELvIeABL7o0qGGQIYrc776Y1dm8ripUhVAC1NLO3Uc-0pAMdQwP70iSN8BrLLbto&usqp=CAc',
      'doador': 'Carlos A.',
      'donatedAt': '2023-05-11',
      'phoneNumber': '5511999999999',
    },
  ];

  final List<Map<String, dynamic>> _myDonations = [
    {
      'id': '3',
      'nome': 'Vestido Longo Floral',
      'categoria': 'Vestidos',
      'tamanho': 'P',
      'descricao': 'Vestido leve, ótimo para primavera e verão.',
      'imagemUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-bKmoKD8WhG4hqLqQk4ithEwomwwujzyyxA&s',
      'doador': 'Você',
      'donatedAt': '2023-05-09',
      'phoneNumber': '5511999999999',
    },
    {
      'id': '4',
      'nome': 'Short Jeans',
      'categoria': 'Shorts',
      'tamanho': '38',
      'descricao': 'Short jeans feminino, em ótimo estado.',
      'imagemUrl':
          'https://images.tcdn.com.br/img/img_prod/663219/short_jeans_sal_e_pimenta_strass_ref_049_5355_1_db48f86d4297fc29b3fe273a0280f429.jpeg',
      'doador': 'Você',
      'donatedAt': '2023-05-08',
      'phoneNumber': '5511999999999',
    },
  ];

  final List<Map<String, dynamic>> _receivedDonations = [
    {
      'id': '5',
      'nome': 'Jaqueta de Couro',
      'categoria': 'Jaquetas',
      'tamanho': 'G',
      'descricao': 'Jaqueta de couro sintético preta, seminova.',
      'imagemUrl':
          'https://vinncistore.com.br/cdn/shop/products/jaqueta-racer-de-couro-masculina-jaqueta-racer-de-couro-masculina-vinnci-store-marrom-p-650684_288x.jpg?v=1685586999',
      'doador': 'Fernanda L.',
      'donatedAt': '2023-05-07',
      'phoneNumber': '5511999999999',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
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
                          ? 'Doadas'
                          : 'Recebidas',
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
      return Expanded(
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
              child: IndexedStack(
                index: _tabController.index,
                children: [
                  _buildDonationsList(_favoritedDonations, 'favoritas'),
                  _buildDonationsList(_myDonations, 'doadas'),
                  _buildDonationsList(_receivedDonations, 'recebidas'),
                ],
              ),
            ),
          ),
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
        return DonationGridItem(donation: donation);
      },
    );
  }
}
