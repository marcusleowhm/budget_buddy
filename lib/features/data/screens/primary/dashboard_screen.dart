import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/dashboard/dashboard.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${titles[MainRoutes.dashboard]}')),
      backgroundColor: Colors.grey[200], //TODO change this color
      body: const Center(
        child: SingleChildScrollView(child: Dashboard()),
      ),
    );
  }
}
