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
      backgroundColor: AppTheme.bgLightGrey,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Image.asset(
              'assets/images/bg_gradient.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: AppTheme.pureWhite))
              : Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      foregroundColor: AppTheme.pureWhite,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppTheme.pureWhite.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.build, size: 40, color: AppTheme.pureWhite),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Center(
                            child: Text(
                              'Diagnosis',
                              style: TextStyle(
                                fontSize: 28,
                                color: AppTheme.pureWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              '${widget.category.name} - ${widget.issue.name}',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.pureWhite.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
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
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Possible causes:',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 16),
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
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCauseItem(String cause) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.primaryRed.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: AppTheme.primaryRed, size: 16),
          ),
          const SizedBox(width: 16),
          Text(cause, style: const TextStyle(fontSize: 16, color: AppTheme.trueBlack)),
        ],
      ),
    );
  }

  Widget _buildEstimateCard(String title, String price, {required bool isBlack}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isBlack ? AppTheme.trueBlack : Colors.white, width: isBlack ? 2 : 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.greyText,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(
              color: AppTheme.trueBlack,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
