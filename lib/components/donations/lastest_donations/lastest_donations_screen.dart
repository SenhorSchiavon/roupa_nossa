import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:roupa_nossa/components/donations/card/donations_card.dart';
import 'package:roupa_nossa/components/donations/single/single_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LatestDonations extends StatefulWidget {
  const LatestDonations({Key? key}) : super(key: key);

  @override
  State<LatestDonations> createState() => _LatestDonationsState();
}

class _LatestDonationsState extends State<LatestDonations> {
  List<Map<String, dynamic>> donations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDonations();
  }

  Future<void> fetchDonations() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['URL_BACKEND']}/api/doacao'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          donations = data.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        throw Exception('Erro ao carregar doações');
      }
    } catch (e) {
      print('Erro: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: donations.length,
      itemBuilder: (context, index) {
        final donation = donations[index];
        print('Doação: $donation');
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
            imageUrl: donation['roupa']['imagemUrl'],
            title: donation['roupa']['nome'],
            category: donation['roupa']['categoria'],
            size: donation['roupa']['tamanho'],
            donorName: donation['usuario']['nome'],
            timeAgo: 'recentemente', // calcular se quiser
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    );
  }
}
