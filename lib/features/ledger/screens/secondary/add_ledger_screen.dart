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
    if (entries.isEmpty) {
      entries.add(const LedgerInput());
    }
  }

  void _addRow() {
    //Add new ledger to the array
    setState(() => entries = [...entries, const LedgerInput()]);
  }

  void _handleSubmit() {
    //TODO implement logic to handle form submission
    print(entries.length);
  }

  Widget _buildDismissableExpandableTile(int index) {

    LedgerInput input = entries.elementAt(index);
    return Dismissible(
      key: PageStorageKey<int>(index),
      //Show a red background when the tile is swiped from left to right
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: const Icon(Icons.delete),
      ),
      //Show a red background when the tile is swiped from right to left
      secondaryBackground: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete)),
      onDismissed: (DismissDirection direction) {
        setState(() => entries.removeAt(index));
        
      },
      child: input,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${titles[SubRoutes.addledger]}'),
      ),
      backgroundColor: Colors.grey[200], //TODO change this color
      body: ListView.builder(
        itemCount: entries.length + 2,
        itemBuilder: (context, index) {
          //The second last item in the list
          if (index == entries.length) {
            return AddRowButton(onPressed: _addRow);
          }
          //The last item in the list
          if (index > entries.length) {
            return SubmitButton(
              action: _handleSubmit,
            );
          }
          //The rest of the dismissable expandable tile
          return _buildDismissableExpandableTile(index);
        },
      ),
    );
  }
}
