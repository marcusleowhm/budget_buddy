import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${titles[MainRoutes.balance]}')
      ),
    );
  }
}