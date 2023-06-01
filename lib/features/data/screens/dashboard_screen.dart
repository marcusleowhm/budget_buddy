import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/basic_chart.dart';
import 'package:budget_buddy/features/data/components/monthly_summary.dart';
import 'package:budget_buddy/features/data/components/recent_transactions_list.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${titles[MainRoutes.dashboard]}')),
        backgroundColor: Colors.grey[200], //TODO change this color
        body: SingleChildScrollView(
          child: BlocBuilder<CTransactionCubit, CTransactionState>(
              builder: (context, state) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: const Column(
                children: [
                  MonthlySummary(),
                  BasicChart(),
                  RecentTransactionsList(),
                ],
              ),
            );
          }),
        ));
  }
}
