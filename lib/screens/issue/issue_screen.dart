import 'package:flutter/material.dart';

class IssueScreen extends StatelessWidget {
  const IssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Issue')),
      body: const Center(child: Text('Issue Screen')),
    );
  }
}
