import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${titles[MainRoutes.statistics]}')
      ),
    );
  }
}