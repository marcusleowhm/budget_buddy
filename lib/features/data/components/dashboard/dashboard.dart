import 'package:budget_buddy/features/data/components/dashboard/recent/recent_transactions_list.dart';
import 'package:budget_buddy/features/data/components/dashboard/summary/monthly_summary.dart';
import 'package:budget_buddy/features/data/components/dashboard/trend/trend.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        MonthlySummary(),
        Trend(),
        RecentTransactionsList(),
      ],
    );
  }
}
