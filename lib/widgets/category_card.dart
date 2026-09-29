import 'package:flutter/material.dart';
import 'package:sortit/models/category.dart';
import 'package:sortit/theme/app_theme.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = category.icon == 'ac' || category.icon == 'phone';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 24,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              if (hasImage)
                Positioned.fill(
                  child: Image.asset(
                    _getImagePath(category.icon),
                    fit: BoxFit.cover,
                  ),
                ),
              if (!hasImage)
                Positioned.fill(
                  child: Center(
                    child: Icon(
                      _getIcon(category.icon),
                      size: 64,
                      color: AppTheme.primaryRed.withValues(alpha: 0.15),
                    ),
                  ),
                ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.trueBlack,
                    // Subtle shadow to ensure text is readable over any image
                    shadows: [
                      Shadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 4,
                      )
                    ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getImagePath(String iconName) {
    if (iconName == 'ac') return 'assets/images/ac.jpg';
    if (iconName == 'phone') return 'assets/images/phone.jpg';
    return 'assets/images/handyman.jpg';
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'washing_machine': return Icons.local_laundry_service;
      case 'laptop': return Icons.laptop_mac;
      case 'bicycle': return Icons.pedal_bike;
      case 'electrical': return Icons.electrical_services;
      default: return Icons.build;
    }
  }
}
