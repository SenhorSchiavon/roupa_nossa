import 'package:flutter/material.dart';
import 'package:roupa_nossa/components/donations/card/donations_card.dart';
import 'package:roupa_nossa/components/donations/single/single_view.dart'; // <- Certifique-se que esse import está correto

class LatestDonations extends StatelessWidget {
  const LatestDonations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> donations = [
      {
        'id': '1',
        'imageUrl':
            'https://images.unsplash.com/photo-1576566588028-4147f3842f27?ixlib=rb-4.0.3&auto=format&fit=crop&w=764&q=80',
        'title': 'Camiseta Azul',
        'category': 'Camisetas',
        'size': 'M',
        'donorName': 'Maria S.',
        'timeAgo': 'há 2 horas',
        'description': 'Camiseta azul em bom estado, pouco usada.',
        'donatedAt': '2023-05-15',
        'phoneNumber': '5511999999999',
      },
      {
        'id': '2',
        'imageUrl':
            'https://images.unsplash.com/photo-1542272604-787c3835535d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1026&q=80',
        'title': 'Calça Jeans',
        'category': 'Calças',
        'size': '42',
        'donorName': 'João P.',
        'timeAgo': 'há 1 dia',
        'description': 'Calça jeans masculina, seminova.',
        'donatedAt': '2023-05-14',
        'phoneNumber': '5511999999999',
      },
      {
        'id': '3',
        'imageUrl':
            'https://images.unsplash.com/photo-1612336307429-8a898d10e223?ixlib=rb-4.0.3&auto=format&fit=crop&w=1374&q=80',
        'title': 'Vestido Vermelho',
        'category': 'Vestidos',
        'size': 'G',
        'donorName': 'Ana C.',
        'timeAgo': 'há 3 dias',
        'description': 'Vestido estampado para o verão.',
        'donatedAt': '2023-05-13',
        'phoneNumber': '5511999999999',
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: donations.length,
      itemBuilder: (context, index) {
        final donation = donations[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DonationDetailsScreen(donation: donation),
              ),
            );
          },
          child: DonationCard(
            imageUrl: donation['imageUrl'],
            title: donation['title'],
            category: donation['category'],
            size: donation['size'],
            donorName: donation['donorName'],
            timeAgo: donation['timeAgo'],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    );
  }
}
