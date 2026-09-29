import 'package:flutter/material.dart';

class SponsoredCard extends StatelessWidget {
  const SponsoredCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Sponsored Card'),
      ),
    );
  }
}
