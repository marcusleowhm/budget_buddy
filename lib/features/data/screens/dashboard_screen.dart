import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${titles[MainRoutes.dashboard]}')
      ),
    );
  }
}
