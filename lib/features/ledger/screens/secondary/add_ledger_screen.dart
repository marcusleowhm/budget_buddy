import 'package:budget_buddy/features/ledger/components/quantity_picker.dart';
import 'package:flutter/material.dart';

class AddLedgerScreen extends StatelessWidget {
  const AddLedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: ListView(
        children: const [
          QuantityPicker()
        ],
      )
    );
  }
}
