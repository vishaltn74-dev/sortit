import 'package:flutter/material.dart';
import 'package:sortit/models/category.dart';
import 'package:sortit/theme/app_theme.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  final bool isBlack;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    this.isBlack = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isBlack ? AppTheme.trueBlack : AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isBlack ? [] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              _getIcon(category.icon),
              color: isBlack ? AppTheme.pureWhite : AppTheme.trueBlack,
              size: 32,
            ),
            Text(
              category.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isBlack ? AppTheme.pureWhite : AppTheme.trueBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'ac': return Icons.ac_unit;
      case 'phone': return Icons.smartphone;
      case 'washing_machine': return Icons.local_laundry_service;
      case 'laptop': return Icons.laptop_mac;
      case 'bicycle': return Icons.pedal_bike;
      case 'electrical': return Icons.electrical_services;
      default: return Icons.build;
    }
  }
}
