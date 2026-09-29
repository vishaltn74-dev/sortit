import 'package:flutter/material.dart';
import 'package:sortit/models/repairer.dart';
import 'package:sortit/theme/app_theme.dart';
import 'package:sortit/widgets/primary_button.dart';

class ConfirmationScreen extends StatefulWidget {
  final Repairer repairer;
  final String date;
  final String time;

  const ConfirmationScreen({
    super.key,
    required this.repairer,
    required this.date,
    required this.time,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            bottom: false,
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: AppTheme.pureWhite,
                ),
                Expanded(
                  child: Center(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppTheme.pureWhite,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 50,
                          color: AppTheme.accentOrange,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
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
                      const Center(
                        child: Text(
                          'Booking Confirmed',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.trueBlack,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Your repairer is scheduled',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.greyText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Booking ID', style: TextStyle(color: AppTheme.greyText)),
                          const Text('FN-2847', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.trueBlack)),
                        ],
                      ),
                      const Divider(height: 32, color: AppTheme.bgLightGrey),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Repairer', style: TextStyle(color: AppTheme.greyText)),
                          Text(widget.repairer.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.trueBlack)),
                        ],
                      ),
                      const Divider(height: 32, color: AppTheme.bgLightGrey),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Schedule', style: TextStyle(color: AppTheme.greyText)),
                          Text('${widget.date}, ${widget.time}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.trueBlack)),
                        ],
                      ),
                      
                      const SizedBox(height: 48),
                      PrimaryButton(
                        text: 'Done',
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        text: 'Call Repairer',
                        isOutline: true,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
