import 'package:budget_buddy/features/ledger/components/ledger_input.dart';
import 'package:flutter/material.dart';

class AddLedgerScreen extends StatelessWidget {
  const AddLedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Transaction'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: const [
              LedgerInput()
            ],
          ),
        ));
  }
}
