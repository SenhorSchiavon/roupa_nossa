import 'package:flutter/material.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample rewards data - replace with your actual data
    final List<Map<String, dynamic>> rewards = [
      {
        'id': '1',
        'title': 'Desconto de 10%',
        'description': 'Desconto em qualquer loja parceira',
        'icon': Icons.discount,
        'color': const Color(0xFF4CAF50),
        'isUnlocked': true,
        'requiredDonations': 1,
      },
      {
        'id': '2',
        'title': 'Frete Grátis',
        'description': 'Frete grátis em compras online',
        'icon': Icons.local_shipping,
        'color': const Color(0xFF2196F3),
        'isUnlocked': true,
        'requiredDonations': 3,
      },
      {
        'id': '3',
        'title': 'Desconto de 20%',
        'description': 'Desconto especial em lojas parceiras',
        'icon': Icons.card_giftcard,
        'color': const Color(0xFFFFC107),
        'isUnlocked': false,
        'requiredDonations': 5,
      },
      {
        'id': '4',
        'title': 'Cupom de R\$50',
        'description': 'Cupom para usar em qualquer loja parceira',
        'icon': Icons.confirmation_number,
        'color': const Color(0xFF9C27B0),
        'isUnlocked': false,
        'requiredDonations': 10,
      },
      {
        'id': '5',
        'title': 'Produto Grátis',
        'description': 'Escolha um produto grátis em lojas parceiras',
        'icon': Icons.redeem,
        'color': const Color(0xFFE91E63),
        'isUnlocked': false,
        'requiredDonations': 15,
      },
    ];

    // Current user donations count - replace with actual data
    const int userDonationsCount = 3;

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
              _buildProgressIndicator(userDonationsCount),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, color: Colors.orange),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'As recompensas exibidas são fictícias e ainda estão em fase de testes. Não devem ser levadas em consideração como benefícios reais.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

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
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: rewards.length,
                        itemBuilder: (context, index) {
                          final reward = rewards[index];
                          return _buildRewardCard(
                            reward: reward,
                            userDonationsCount: userDonationsCount,
                          );
                        },
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
            'Minhas Recompensas',
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

  Widget _buildProgressIndicator(int donationsCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$donationsCount doações realizadas',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Próxima: 5 doações',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: donationsCount / 5, // Progress to next reward
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard({
    required Map<String, dynamic> reward,
    required int userDonationsCount,
  }) {
    final bool isUnlocked = userDonationsCount >= reward['requiredDonations'];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: reward['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(reward['icon'], color: reward['color'], size: 32),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reward['description'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Necessário: ${reward['requiredDonations']} doações',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isUnlocked
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUnlocked ? Icons.check : Icons.lock,
                color: isUnlocked ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
