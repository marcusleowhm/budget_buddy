import 'package:budget_buddy/features/ledger/components/add_row_button.dart';
import 'package:budget_buddy/features/ledger/components/ledger_input.dart';
import 'package:budget_buddy/features/ledger/components/submit_button.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';

class AddLedgerScreen extends StatefulWidget {
  const AddLedgerScreen({super.key});

  @override
  State<AddLedgerScreen> createState() => _AddLedgerScreenState();
}

class _AddLedgerScreenState extends State<AddLedgerScreen> {
  List<LedgerInput> entries = [const LedgerInput()];

  void addRow() {
    setState(() {
      LedgerInput newInput = const LedgerInput();
      entries.add(newInput);
    });
  }

  void _handleSubmit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${titles[SubRoutes.addledger]}'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        children: [
          ...entries,
          AddRowButton(
            action: addRow,
          ),
          SubmitButton(
            action: _handleSubmit,
          )
        ],
      ),
    );
  }
}
