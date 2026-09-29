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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.accentYellow,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.trueBlack.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Sponsored',
                    style: TextStyle(
                      color: AppTheme.trueBlack,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppTheme.trueBlack, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      repairer.rating.toString(),
                      style: const TextStyle(
                        color: AppTheme.trueBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.trueBlack,
                  child: Text(
                    repairer.name[0],
                    style: const TextStyle(
                      color: AppTheme.pureWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        repairer.name,
                        style: const TextStyle(
                          color: AppTheme.trueBlack,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        repairer.category,
                        style: TextStyle(
                          color: AppTheme.trueBlack.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: AppTheme.trueBlack,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward, color: AppTheme.accentYellow, size: 20),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
