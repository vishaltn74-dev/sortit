import 'package:flutter/material.dart';
import 'package:sortit/models/category.dart';
import 'package:sortit/models/issue.dart';
import 'package:sortit/models/repairer.dart';
import 'package:sortit/theme/app_theme.dart';
import 'package:sortit/widgets/primary_button.dart';
import 'package:sortit/screens/booking/booking_screen.dart';

class RepairerDetailsScreen extends StatelessWidget {
  final Repairer repairer;
  final Category category;
  final Issue issue;

  const RepairerDetailsScreen({
    super.key,
    required this.repairer,
    required this.category,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryRed,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.pureWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Hero(
                  tag: 'avatar_\${repairer.id}',
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: AppTheme.accentOrange,
                    child: Text(
                      repairer.name[0],
                      style: const TextStyle(
                        fontSize: 32,
                        color: AppTheme.trueBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  repairer.name,
                  style: const TextStyle(
                    fontSize: 24,
                    color: AppTheme.pureWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: AppTheme.accentOrange, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      repairer.rating.toString(),
                      style: const TextStyle(
                        color: AppTheme.pureWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '\${repairer.jobsCompleted} jobs',
                      style: TextStyle(
                        color: AppTheme.pureWhite.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                color: AppTheme.pureWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(Icons.monetization_on, 'Inspection Fee', '₹\${repairer.inspectionFee}'),
                  const Divider(height: 40),
                  _buildDetailRow(Icons.location_on, 'Distance', '1.2 km away'),
                  const Divider(height: 40),
                  const Text(
                    'Services',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: repairer.services.map((s) => Chip(
                      label: Text(s),
                      backgroundColor: AppTheme.bgLightGrey,
                      side: BorderSide.none,
                    )).toList(),
                  ),
                  
                  const Spacer(),
                  
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: 'Book Repair',
                          isYellow: true,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingScreen(
                                  repairer: repairer,
                                  category: category,
                                  issue: issue,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.bgLightGrey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: AppTheme.trueBlack),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: AppTheme.greyText)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
