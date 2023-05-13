import 'package:budget_buddy/features/transactions/components/quantity_picker.dart';
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

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
