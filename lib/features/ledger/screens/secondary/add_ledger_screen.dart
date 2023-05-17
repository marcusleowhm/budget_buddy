import 'package:budget_buddy/features/ledger/components/add_row_button.dart';
import 'package:budget_buddy/features/ledger/components/type_picker.dart';
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
      _addRow();
    }
  }

  @override
  void dispose() {
    for (LedgerInput input in entries) {
      input
        ..accountOrAccountFromController.dispose()
        ..categoryOrAccountToController.dispose()
        ..amountController.dispose()
        ..noteController.dispose()
        ..additionalNoteController.dispose();
    }
    super.dispose();
  }

  void _addRow() {
    //Init controllers first
    TextEditingController accountOrAccountFromController =
        TextEditingController();
    TextEditingController categoryOrAccountToController =
        TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    TextEditingController additionalNoteController = TextEditingController();

    //Create a ledger and add controllers
    LedgerInput newLedger = LedgerInput(
      id: const Uuid().v4(),
      accountOrAccountFromController: accountOrAccountFromController,
      categoryOrAccountToController: categoryOrAccountToController,
      amountController: amountController,
      noteController: noteController,
      additionalNoteController: additionalNoteController,
    );

    //Add listeners to controllers
    accountOrAccountFromController.addListener(
      () => setState(() =>
          newLedger.accountOrAccountFrom = accountOrAccountFromController.text),
    );
    categoryOrAccountToController.addListener(
      () => setState(() =>
          newLedger.categoryOrAccountTo = categoryOrAccountToController.text),
    );
    amountController.addListener(
      () => setState(
        () {
          double number = double.tryParse(amountController.text) ?? 0.0;
          newLedger.amount = number;
        },
      ),
    );
    noteController.addListener(
      () => setState(() => newLedger.note = noteController.text),
    );
    additionalNoteController.addListener(
      () => setState(
          () => newLedger.additionalNote = additionalNoteController.text),
    );

    //Finally add new ledger into entries
    setState(() => entries.add(newLedger));
  }

  void _handleSubmit() {
    //TODO implement logic to handle form submission
    entries.forEach((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    //(WillPopScope) For handling when user clicks back on the app bar, remove the displayed snack bar
    return WillPopScope(
      //(GestureDetector) For making TextField lose focus when user taps elsewhere
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: Scaffold(
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

                  Key typeKey = const Key('type');
                  Key dateKey = const Key('date');
                  Key accountOrAccountFromKey =
                      const Key('accountOrAccountFrom');
                  Key categoryOrAccountToKey = const Key('categoryOrAccountTo');
                  Key amountKey = const Key('amount');
                  Key noteKey = const Key('note');
                  Key dividerKey = const Key('divider');
                  Key additionalNoteKey = const Key('additionalNote');

                  return Dismissible(
                    key: PageStorageKey<String>(input.id),
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
                      isExpanded: input.isExpanded,
                      onExpand: (value) =>
                          setState(() => input.isExpanded = value),
                      ledger: input,
                      children: [
                        TypePicker(
                          key: typeKey,
                          type: input.type,
                          setType: (Set<TransactionType> newSelection) =>
                              setState(() => entries.elementAt(index).type =
                                  newSelection.first),
                        ),
                        TextField(
                          key: dateKey, //TODO implement datetime input
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Date',
                          ),
                        ),
                        TextField(
                          key: accountOrAccountFromKey,
                          controller: input.accountOrAccountFromController,
                          decoration: InputDecoration(
                            labelText: input.type == TransactionType.transfer
                                ? 'Account From'
                                : 'Account',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        TextField(
                          key: categoryOrAccountToKey,
                          controller: input.categoryOrAccountToController,
                          decoration: InputDecoration(
                            labelText: input.type == TransactionType.transfer
                                ? 'Account To'
                                : 'Category',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        TextField(
                          key: amountKey,
                          controller: input.amountController,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          key: noteKey,
                          controller: input.noteController,
                          decoration: const InputDecoration(
                            labelText: 'Note',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        Divider(key: dividerKey),
                        TextField(
                          key: additionalNoteKey,
                          controller: input.additionalNoteController,
                          decoration: const InputDecoration(
                            hintText: 'Additional Notes',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                        ),
                      ],
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        entries.removeAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Record removed'),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () {
                                setState(
                                  () => entries.insert(index, input),
                                );
                              },
                            ),
                          ),
                        );
                      });
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
        ),
      ),
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return Future.value(true);
      },
    );
  }
}
