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
              Positioned.fill(
                child: Image.asset(
                  _getImagePath(category.icon),
                  fit: BoxFit.cover,
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
    return 'assets/images/$iconName.jpg';
  }
}
