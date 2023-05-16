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
  List<LedgerInput> entries = [];

  @override
  void initState() {
    super.initState();
    entries.add(const LedgerInput());
  }

  void _addRow() {
    //Add new ledger to the array
    setState(() {
      entries = [...entries, const LedgerInput()];
    });
  }

  void _removeRowAt(int index) {
    
  }

  void _handleSubmit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${titles[SubRoutes.addledger]}'),
      ),
      backgroundColor: Colors.grey[200], //TODO change this color
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: Column(
            children: [
              ...entries,
              AddRowButton(onPressed: _addRow),
              SubmitButton(
                action: _handleSubmit,
              ),
              const SizedBox(
                height: 96.0,
                width: double.infinity,
              )
            ],
          ),
        ),
      ),
    );
  }
}
