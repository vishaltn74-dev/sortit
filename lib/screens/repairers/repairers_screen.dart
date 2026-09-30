import 'package:flutter/material.dart';
import 'package:sortit/widgets/admob_banner.dart';

class RepairersScreen extends StatelessWidget {
  const RepairersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repairers')),
      body: Column(
        children: const [
          Expanded(
            child: Center(child: Text('Repairers Screen')),
          ),
          AdMobBanner(),
        ],
      ),
    );
  }
}
