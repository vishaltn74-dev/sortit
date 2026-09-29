import 'package:flutter/material.dart';
import 'package:sortit/models/category.dart';
import 'package:sortit/models/issue.dart';
import 'package:sortit/theme/app_theme.dart';
import 'package:sortit/widgets/primary_button.dart';
import 'package:sortit/screens/repairers/repairers_screen.dart';

class DiagnosisScreen extends StatefulWidget {
  final Category category;
  final Issue issue;

  const DiagnosisScreen({
    super.key,
    required this.category,
    required this.issue,
  });

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.pureWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.royalBlue))
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppTheme.accentYellow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.build, size: 40, color: AppTheme.trueBlack),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Center(
                    child: Text(
                      'Diagnosis',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      '\${widget.category.name} - \${widget.issue.name}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.greyText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Possible causes:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _buildCauseItem('Clogged filter'),
                  _buildCauseItem('Blocked drain hose'),
                  _buildCauseItem('Drain pump issue'),
                  
                  const Spacer(),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildEstimateCard(
                          'Repair',
                          '₹500 - ₹1,500',
                          isBlack: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildEstimateCard(
                          'Replacement',
                          '₹12,000+',
                          isBlack: false,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: 'Find Repairers',
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, a1, a2) => RepairersScreen(
                            category: widget.category,
                            issue: widget.issue,
                          ),
                          transitionsBuilder: (context, a1, a2, child) {
                            return FadeTransition(opacity: a1, child: child);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildCauseItem(String cause) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppTheme.royalBlue, size: 20),
          const SizedBox(width: 12),
          Text(cause, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildEstimateCard(String title, String price, {required bool isBlack}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isBlack ? AppTheme.trueBlack : AppTheme.accentYellow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isBlack ? AppTheme.pureWhite : AppTheme.trueBlack,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: TextStyle(
              color: isBlack ? AppTheme.pureWhite : AppTheme.trueBlack,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
