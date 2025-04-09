import 'package:flutter/material.dart';
import 'package:roupa_nossa/components/campaigns/children_clothes_campaing.dart';
import 'package:roupa_nossa/components/campaigns/transform_lives_campaign.dart';
import 'package:roupa_nossa/components/campaigns/winter_campaign.dart';

class BannerHome extends StatefulWidget {
  final PageController bannerController;
  final List<Map<String, dynamic>> banners;

  const BannerHome({
    Key? key,
    required this.bannerController,
    required this.banners,
  }) : super(key: key);

  @override
  State<BannerHome> createState() => _BannerHomeState();
}

class _BannerHomeState extends State<BannerHome> {
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.bannerController.addListener(_handlePageChange);
  }

  @override
  void dispose() {
    widget.bannerController.removeListener(_handlePageChange);
    super.dispose();
  }

  void _handlePageChange() {
    if (widget.bannerController.page?.round() != _currentBannerIndex) {
      setState(() {
        _currentBannerIndex = widget.bannerController.page?.round() ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 210,
          child: PageView.builder(
            controller: widget.bannerController,
            itemCount: widget.banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [banner['color'], banner['color'].withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: banner['color'].withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(
                        banner['icon'],
                        size: 150,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            banner['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            banner['description'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Navegação para a página da campanha correspondente
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    // Navegar para a página correta com base no índice
                                    if (index == 0) {
                                      return const TransformLivesCampaign();
                                    } else if (index == 1) {
                                      return const WinterCampaign();
                                    } else {
                                      return const ChildrenClothesCampaign();
                                    }
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: banner['color'],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Saiba mais'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.banners.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _currentBannerIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
