import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/transaction/c_transaction_list.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  DateTime utcNow = DateTime.now();
  late DateTime currentLocalDate;

  @override
  void initState() {
    setState(() => currentLocalDate =
        DateTime(utcNow.year, utcNow.month, utcNow.day).toLocal());
    super.initState();
  }

  void incrementMonth() {
    setState(() => currentLocalDate = DateTime(currentLocalDate.year,
        currentLocalDate.month + 1, currentLocalDate.day));
  }

  void decrementMonth() {
    setState(() => currentLocalDate = DateTime(currentLocalDate.year,
        currentLocalDate.month - 1, currentLocalDate.day));
  }

  void resetDate() {
    setState(() => currentLocalDate = utcNow);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${titles[MainRoutes.ledger]}')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(
            '/${routes[MainRoutes.ledger]}/${routes[SubRoutes.addledger]}',
            extra: null,
          );
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.grey[200],
      body: CTransactionList(
        currentLocalDate: currentLocalDate,
        nowDate: utcNow,
        incrementMonth: incrementMonth,
        decrementMonth: decrementMonth,
        resetDate: resetDate,
      ),
    );
  }
}
