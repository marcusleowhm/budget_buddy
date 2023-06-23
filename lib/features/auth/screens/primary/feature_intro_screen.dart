import 'package:flutter/material.dart';

class FeatureIntroScreen extends StatelessWidget {
  const FeatureIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DefaultTabController(
        length: 3,
        child: TabBarView(
          children: [
            Center(
              child: Text('Feature 1'),
            ),
            Center(
              child: Text('Feature 2'),
            ),
            Center(
              child: Text('Feature 3'),
            ),
          ],
        ),
      ),
    );
  }
}
