import 'package:budget_buddy/features/ledger/components/add_row_button.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/components/submit_button.dart';
import 'package:budget_buddy/features/ledger/widgets/expansion_group.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddLedgerScreen extends StatefulWidget {
  const AddLedgerScreen({super.key});

  @override
  State<AddLedgerScreen> createState() => _AddLedgerScreenState();
}

class _AddLedgerScreenState extends State<AddLedgerScreen> {
  List<LedgerInput> entries = <LedgerInput>[];

  @override
  void initState() {
    super.initState();
    if (entries.isEmpty) {
      entries.add(
        LedgerInput(
          id: const Uuid().v4(),
        ),
      );
    }
  }

  void _addRow() {
    //Add new ledger to the array
    setState(
      () => entries.add(
        LedgerInput(
          id: const Uuid().v4(),
        ),
      ),
    );
  }

  void _handleSubmit() {
    //TODO implement logic to handle form submission
    print(entries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${titles[SubRoutes.addledger]}'),
      ),
      backgroundColor: Colors.grey[200], //TODO change this color
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            //Build the dismissible expandable form
            ...entries.asMap().entries.map((entry) {
              int index = entry.key;
              LedgerInput input = entry.value;

              return Dismissible(
                key: Key(input.id),
                //Show red background when swiped left to right
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  child: const Icon(Icons.delete),
                ),
                //Show red background when swiped right to left
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete),
                ),
                child: ExpansionGroup(
                  ledger: input,
                  children: [
                    const TextField(
                      decoration: InputDecoration(labelText: 'Date'),
                    ),
                    TextField(
                      onChanged: (value) => setState(
                          () => entries.elementAt(index).account = value),
                      decoration: const InputDecoration(labelText: 'Account'),
                    ),
                    TextField(
                      onChanged: (value) => setState(
                          () => entries.elementAt(index).category = value),
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                  ],
                ),
                onDismissed: (direction) {
                  setState(() => entries.removeAt(index));
                },
              );
            }).toList(),
            AddRowButton(
              onPressed: _addRow,
            ),
            SubmitButton(
              action: _handleSubmit,
            )
          ]),
        ),
      ),
    );
  }
}
