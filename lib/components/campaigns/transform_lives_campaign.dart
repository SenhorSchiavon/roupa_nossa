import 'package:flutter/material.dart';
import 'package:roupa_nossa/components/campaigns/campaign_detail_page.dart';

class TransformLivesCampaign extends StatelessWidget {
  const TransformLivesCampaign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CampaignDetailPage(
      title: 'Doe roupas, transforme vidas',
      description:
          'A campanha "Doe roupas, transforme vidas" tem como objetivo arrecadar peças de vestuário em bom estado para pessoas em situação de vulnerabilidade social. Cada doação pode fazer uma grande diferença na vida de alguém que precisa de apoio para recomeçar.\n\nAceitamos todos os tipos de roupas, desde que estejam limpas e em boas condições de uso. Roupas básicas como camisetas, calças, casacos e roupas íntimas novas são especialmente necessárias.',
      color: const Color(0xFF2196F3),
      icon: Icons.favorite,
      stats: [
        {
          'icon': Icons.people,
          'value': '+2.500',
          'label': 'Pessoas beneficiadas',
        },
        {'icon': Icons.checkroom, 'value': '+10.000', 'label': 'Peças doadas'},
        {'icon': Icons.location_on, 'value': '15', 'label': 'Pontos de coleta'},
        {
          'icon': Icons.volunteer_activism,
          'value': '45',
          'label': 'Voluntários',
        },
      ],
      steps: [
        {
          'title': 'Separe as roupas',
          'description':
              'Selecione peças em bom estado que você não usa mais. Lave e dobre as roupas antes de doar.',
        },
        {
          'title': 'Registre sua doação',
          'description':
              'Cadastre as peças no aplicativo para que possamos organizar a logística de coleta e distribuição.',
        },
        {
          'title': 'Entregue ou agende coleta',
          'description':
              'Leve suas doações a um ponto de coleta ou agende uma coleta em sua residência através do aplicativo.',
        },
        {
          'title': 'Acompanhe o impacto',
          'description':
              'Receba atualizações sobre como sua doação está ajudando pessoas na comunidade.',
        },
      ],
      testimonials: [
        {
          'name': 'Carlos Silva',
          'role': 'Beneficiário',
          'text':
              'As roupas que recebi me deram dignidade para procurar emprego. Hoje estou trabalhando e consegui recomeçar minha vida.',
        },
        {
          'name': 'Ana Oliveira',
          'role': 'Voluntária',
          'text':
              'Ver o sorriso no rosto das pessoas quando recebem roupas novas é uma experiência transformadora. Cada peça doada representa esperança.',
        },
        {
          'name': 'Roberto Santos',
          'role': 'Doador frequente',
          'text':
              'Doar regularmente me fez perceber quanto consumimos sem necessidade. Agora compro menos e com mais consciência.',
        },
      ],
    );
  }
}
