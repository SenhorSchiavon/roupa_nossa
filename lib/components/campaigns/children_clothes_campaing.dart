import 'package:flutter/material.dart';
import 'package:roupa_nossa/components/campaigns/campaign_detail_page.dart';

class ChildrenClothesCampaign extends StatelessWidget {
  const ChildrenClothesCampaign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CampaignDetailPage(
      title: 'Roupas Infantis',
      description:
          'A campanha de Roupas Infantis busca arrecadar vestuário para crianças de todas as idades, desde bebês até adolescentes. As crianças crescem rapidamente e muitas famílias não têm condições de comprar roupas novas com frequência.\n\nAlém de roupas do dia a dia, também arrecadamos uniformes escolares, roupas de inverno, calçados e roupas para ocasiões especiais, como formaturas e festas de fim de ano.',
      color: const Color(0xFFFFC107),
      icon: Icons.child_care,
      stats: [
        {
          'icon': Icons.child_friendly,
          'value': '+3.800',
          'label': 'Crianças beneficiadas',
        },
        {'icon': Icons.checkroom, 'value': '+15.000', 'label': 'Peças doadas'},
        {'icon': Icons.school, 'value': '42', 'label': 'Escolas parceiras'},
        {
          'icon': Icons.family_restroom,
          'value': '+950',
          'label': 'Famílias atendidas',
        },
      ],
      steps: [
        {
          'title': 'Separe roupas por idade',
          'description':
              'Organize as peças por faixa etária (0-2 anos, 3-5 anos, 6-10 anos, 11-14 anos, 15+ anos) para facilitar a distribuição.',
        },
        {
          'title': 'Verifique a qualidade',
          'description':
              'As roupas devem estar limpas, sem manchas, rasgos ou botões faltando. Pense se você vestiria seu filho com aquela peça.',
        },
        {
          'title': 'Registre no aplicativo',
          'description':
              'Cadastre as peças informando tamanho, tipo de roupa e faixa etária para ajudar na organização da campanha.',
        },
        {
          'title': 'Entregue sua doação',
          'description':
              'Leve as roupas a um ponto de coleta ou agende uma retirada em sua casa através do aplicativo.',
        },
      ],
      testimonials: [
        {
          'name': 'Luciana Mendes',
          'role': 'Mãe de 3 filhos',
          'text':
              'As roupas que recebemos para meus filhos foram um alívio para nosso orçamento. Eles ficaram felizes com as roupas novas para ir à escola.',
        },
        {
          'name': 'Pedro Almeida',
          'role': 'Diretor de escola',
          'text':
              'Muitos de nossos alunos vêm de famílias carentes. A campanha de roupas infantis ajudou a melhorar a autoestima e frequência escolar das crianças.',
        },
        {
          'name': 'Juliana Costa',
          'role': 'Assistente social',
          'text':
              'As crianças ficam radiantes ao receber roupas novas. É mais que vestuário, é dignidade e inclusão social para elas.',
        },
      ],
    );
  }
}
