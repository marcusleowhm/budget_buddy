import 'package:budget_buddy/features/ledger/components/c_transaction_list.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  DateTime now = DateTime.now();
  late DateTime currentDate;

  @override
  void initState() {
    setState(
        () => currentDate = DateTime(now.year, now.month, now.day).toLocal());
    super.initState();
  }

  void incrementMonth() {
    setState(() => currentDate =
        DateTime(currentDate.year, currentDate.month + 1, currentDate.day));
  }

  void decrementMonth() {
    setState(() => currentDate =
        DateTime(currentDate.year, currentDate.month - 1, currentDate.day));
  }

  void resetDate() {
    setState(() => currentDate = now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${titles[MainRoutes.ledger]}')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(
              '/${routes[MainRoutes.ledger]}/${routes[SubRoutes.addledger]}');
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.grey[200],
      body: CTransactionList(
        currentDate: currentDate,
        nowDate: now,
        incrementMonth: incrementMonth,
        decrementMonth: decrementMonth,
        resetDate: resetDate,
      ),
    );
  }
}
