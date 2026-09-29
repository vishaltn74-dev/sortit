import 'package:flutter/material.dart';
import 'package:sortit/models/repairer.dart';
import 'package:sortit/theme/app_theme.dart';

class SponsoredCard extends StatelessWidget {
  final Repairer repairer;
  final VoidCallback onTap;

  const SponsoredCard({
    super.key,
    required this.repairer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF003366)], // Premium blue gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.pureWhite.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'SPONSORED',
                    style: TextStyle(
                      color: AppTheme.pureWhite,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppTheme.accentOrange, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      repairer.rating.toString(),
                      style: const TextStyle(
                        color: AppTheme.pureWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.pureWhite,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      repairer.name[0],
                      style: const TextStyle(
                        color: Color(0xFF4A90E2),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        repairer.name,
                        style: const TextStyle(
                          color: AppTheme.pureWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        repairer.category,
                        style: TextStyle(
                          color: AppTheme.pureWhite.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.pureWhite.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward, color: AppTheme.pureWhite, size: 20),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
