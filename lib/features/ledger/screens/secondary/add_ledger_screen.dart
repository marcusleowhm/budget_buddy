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
  final bottomSpacerKey = GlobalKey();

  LedgerInput newLedger() {
    ExpansionTileController expansionTileController = ExpansionTileController();
    return LedgerInput(expansionTileController: expansionTileController);
  }

  @override
  void initState() {
    super.initState();
    entries.add(newLedger());
  }

  void _addRow() {
    //Close the latest input before adding a new one
    if (entries.last.expansionTileController.isExpanded) {
      entries.last.expansionTileController.collapse();
    }

    //Add new ledger to the array
    LedgerInput nextLedger = newLedger();
    setState(() {
      entries = [...entries, nextLedger];
    });

    //Scroll to the bottom after adding new ledger
    Scrollable.ensureVisible(bottomSpacerKey.currentContext!);
  }

  void _handleSubmit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${titles[SubRoutes.addledger]}'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: Column(
            children: [
              ...entries,
              AddRowButton(
                action: _addRow,
              ),
              SubmitButton(
                action: _handleSubmit,
              ),
              SizedBox(
                key: bottomSpacerKey,
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
