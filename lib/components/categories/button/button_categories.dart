import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonCategorias extends StatelessWidget {
  final void Function(String)? onCategorySelected;
  ButtonCategorias({
    super.key,
    required List<Map<String, dynamic>> categorias,
    this.onCategorySelected,
  }) : _categorias = categorias;

  final List<Map<String, dynamic>> _categorias;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categorias.length,
        itemBuilder: (context, index) {
          final categoria = _categorias[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 85,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => onCategorySelected?.call(categoria['name']),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          categoria['iconPath'],
                          width: 30,
                          height: 30,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF2196F3),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        categoria['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
