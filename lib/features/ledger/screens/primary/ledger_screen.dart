import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/components/transaction/committed_transaction_list.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  DateTime localNow = DateTime.now();
  late DateTime dateTimeValue;

  @override
  void initState() {
    setState(
      () =>
          dateTimeValue = DateTime(localNow.year, localNow.month, localNow.day),
    );
    super.initState();
  }

  void incrementMonth() {
    setState(() => dateTimeValue = DateTime(
        dateTimeValue.year, dateTimeValue.month + 1, dateTimeValue.day));
  }

  void decrementMonth() {
    setState(() => dateTimeValue = DateTime(
        dateTimeValue.year, dateTimeValue.month - 1, dateTimeValue.day));
  }

  void resetDate() {
    setState(() => dateTimeValue = DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${titles[MainRoutes.ledger]}')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(
            '/${routes[MainRoutes.ledger]}/${routes[SubRoutes.addledger]}',
            extra: {
              'data': null,
              'defaultDateIsToday': true,
            },
          );
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.grey[200],
      body: CommittedTransactionList(
        dateTimeValue: dateTimeValue,
        localNow: localNow,
        incrementMonth: incrementMonth,
        decrementMonth: decrementMonth,
        resetDate: resetDate,
      ),
    );
  }
}
