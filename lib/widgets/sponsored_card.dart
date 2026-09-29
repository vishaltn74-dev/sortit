import 'package:flutter/material.dart';
import 'package:sortit/models/repairer.dart';
import 'package:sortit/theme/app_theme.dart';

class SponsoredCard extends StatefulWidget {
  final Repairer repairer;
  final VoidCallback onTap;

  const SponsoredCard({
    super.key,
    required this.repairer,
    required this.onTap,
  });

  @override
  State<SponsoredCard> createState() => _SponsoredCardState();
}

class _SponsoredCardState extends State<SponsoredCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color(0xFFD32F2F), // Strong red
                  Color(0xFFFF5252), // Lighter strong red
                  Color(0xFFB71C1C), // Deep crimson
                ],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment(_animation.value - 1.0, -1.0),
                end: Alignment(_animation.value + 1.0, 1.0),
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD32F2F).withValues(alpha: 0.4),
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
                        color: AppTheme.pureWhite.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1),
                      ),
                      child: const Text(
                        'SPONSORED',
                        style: TextStyle(
                          color: AppTheme.pureWhite,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellowAccent, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          widget.repairer.rating.toString(),
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.repairer.name[0],
                          style: const TextStyle(
                            color: Color(0xFFD32F2F),
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
                            widget.repairer.name,
                            style: const TextStyle(
                              color: AppTheme.pureWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.repairer.category,
                            style: TextStyle(
                              color: AppTheme.pureWhite.withValues(alpha: 0.8),
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
                        border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1),
                      ),
                      child: const Icon(Icons.arrow_forward, color: AppTheme.pureWhite, size: 20),
                    )
                  ],
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
