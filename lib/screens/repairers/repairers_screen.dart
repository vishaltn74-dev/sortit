import 'package:flutter/material.dart';
import 'package:sortit/models/category.dart';
import 'package:sortit/models/issue.dart';
import 'package:sortit/models/repairer.dart';
import 'package:sortit/theme/app_theme.dart';
import 'package:sortit/widgets/repairer_card.dart';
import 'package:sortit/widgets/sponsored_card.dart';
import 'package:sortit/screens/repairer_details/repairer_details_screen.dart';

class RepairersScreen extends StatefulWidget {
  final Category category;
  final Issue issue;

  const RepairersScreen({
    super.key,
    required this.category,
    required this.issue,
  });

  @override
  State<RepairersScreen> createState() => _RepairersScreenState();
}

class _RepairersScreenState extends State<RepairersScreen> {
  bool _isLoading = true;

  List<Repairer> _getMockRepairers() {
    return [
      Repairer(
        id: 'r1',
        name: 'QuickFix Electronics',
        category: 'Appliance Repair',
        rating: 4.8,
        jobsCompleted: 342,
        inspectionFee: 500,
        latitude: 0,
        longitude: 0,
        phone: '9876543210',
        services: ['Washing Machine', 'AC', 'Fridge'],
      ),
      Repairer(
        id: 'r2',
        name: 'Sharma Repairs',
        category: 'General Electrical',
        rating: 4.5,
        jobsCompleted: 128,
        inspectionFee: 300,
        latitude: 0,
        longitude: 0,
        phone: '9876543211',
        services: ['Washing Machine', 'Electrical'],
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final repairers = _getMockRepairers();
    final sponsored = repairers[0];

    return Scaffold(
      backgroundColor: AppTheme.royalBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.royalBlue,
        foregroundColor: AppTheme.pureWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Nearby Repairers'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlueBg,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.location_on, color: AppTheme.pureWhite, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Detecting location...',
                          style: TextStyle(color: AppTheme.pureWhite),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppTheme.pureWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.royalBlue))
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    children: [
                      SponsoredCard(
                        repairer: sponsored,
                        onTap: () => _navigateToDetails(context, sponsored),
                      ),
                      const SizedBox(height: 8),
                      ...repairers.map((r) => RepairerCard(
                        repairer: r,
                        distance: 1.2,
                        onTap: () => _navigateToDetails(context, r),
                      )),
                    ],
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(BuildContext context, Repairer repairer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepairerDetailsScreen(
          repairer: repairer,
          category: widget.category,
          issue: widget.issue,
        ),
      ),
    );
  }
}
