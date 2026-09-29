import 'package:flutter/material.dart';
import 'package:sortit/models/issue.dart';
import 'package:sortit/theme/app_theme.dart';

class IssueTile extends StatelessWidget {
  final Issue issue;
  final VoidCallback onTap;

  const IssueTile({
    super.key,
    required this.issue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppTheme.trueBlack,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  issue.name,
                  style: const TextStyle(
                    color: AppTheme.pureWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.accentYellow,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
