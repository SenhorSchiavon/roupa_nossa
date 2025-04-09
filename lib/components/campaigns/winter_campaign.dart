import 'package:flutter/material.dart';
import 'package:roupa_nossa/components/campaigns/campaign_detail_page.dart';

class WinterCampaign extends StatelessWidget {
  const WinterCampaign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CampaignDetailPage(
      title: 'Campanha de Inverno',
      description:
          'A Campanha de Inverno tem como objetivo arrecadar agasalhos, cobertores, meias e outros itens que ajudem a aquecer pessoas em situação de vulnerabilidade durante os meses mais frios do ano.\n\nO frio intenso pode ser fatal para quem vive nas ruas ou em moradias precárias. Com sua doação, podemos garantir que essas pessoas tenham o mínimo de conforto e proteção contra as baixas temperaturas.',
      color: const Color(0xFF4CAF50),
      icon: Icons.ac_unit,
      stats: [
        {
          'icon': Icons.thermostat,
          'value': '+5.000',
          'label': 'Agasalhos doados',
        },
        {'icon': Icons.bed, 'value': '+1.200', 'label': 'Cobertores entregues'},
        {'icon': Icons.home, 'value': '28', 'label': 'Abrigos atendidos'},
        {
          'icon': Icons.calendar_month,
          'value': '90',
          'label': 'Dias de campanha',
        },
      ],
      steps: [
        {
          'title': 'Separe itens de inverno',
          'description':
              'Casacos, blusas de lã, cachecóis, gorros, luvas, meias e cobertores em bom estado são prioridade.',
        },
        {
          'title': 'Verifique as condições',
          'description':
              'Certifique-se de que os itens estão limpos, sem rasgos ou manchas, e ainda podem aquecer adequadamente.',
        },
        {
          'title': 'Entregue nos pontos de coleta',
          'description':
              'Leve suas doações aos pontos de coleta espalhados pela cidade ou agende uma coleta em domicílio.',
        },
        {
          'title': 'Seja um voluntário',
          'description':
              'Além de doar, você pode ajudar na triagem, organização e distribuição dos itens arrecadados.',
        },
      ],
      testimonials: [
        {
          'name': 'Maria Conceição',
          'role': 'Moradora de rua',
          'text':
              'O cobertor que recebi salvou minha vida numa noite em que a temperatura chegou a 5°C. Não sei o que seria de mim sem essa ajuda.',
        },
        {
          'name': 'João Pereira',
          'role': 'Coordenador de abrigo',
          'text':
              'As doações da campanha de inverno são essenciais para nosso abrigo. Conseguimos atender mais de 200 pessoas graças à generosidade dos doadores.',
        },
        {
          'name': 'Fernanda Lima',
          'role': 'Voluntária',
          'text':
              'Participar da distribuição de agasalhos me mostrou uma realidade que muitos ignoram. É gratificante poder ajudar quem mais precisa.',
        },
      ],
    );
  }
}
