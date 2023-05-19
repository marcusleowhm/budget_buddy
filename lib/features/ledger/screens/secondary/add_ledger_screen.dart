import 'package:budget_buddy/features/ledger/components/add_row_button.dart';
import 'package:budget_buddy/features/ledger/components/add_summary.dart';
import 'package:budget_buddy/features/ledger/components/type_picker.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/widgets/expansion_group.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../utilities/date_formatter.dart';
import '../../components/account_picker.dart';

class AddLedgerScreen extends StatefulWidget {
  const AddLedgerScreen({super.key});

  @override
  State<AddLedgerScreen> createState() => _AddLedgerScreenState();
}

class _AddLedgerScreenState extends State<AddLedgerScreen> {
  //State managed by the screen
  List<LedgerInput> entries = <LedgerInput>[];
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double totalTransfer = 0.0;

  DateTime now = DateTime.now();

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
    TextEditingController dateTimeController = TextEditingController();
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
      dateTimeController: dateTimeController,
      accountOrAccountFromController: accountOrAccountFromController,
      categoryOrAccountToController: categoryOrAccountToController,
      amountController: amountController,
      noteController: noteController,
      additionalNoteController: additionalNoteController,
    );

    //Init the date time to be displayed at the start
    newLedger.dateTimeController.text =
        dateLongFormatter.format(newLedger.dateTime);

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
          _tallyAll();
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

  void _removeRowAt(LedgerInput input, int index) {
    setState(
      () {
        entries.removeAt(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Record removed'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                setState(() => entries.insert(index, input));
                _tallyAll();
              },
            ),
          ),
        );
      },
    );
    _tallyAll();
  }

  void _selectDate(BuildContext context, LedgerInput input) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: input.dateTime.toLocal(),
      firstDate: DateTime(1970),
      lastDate: now.add(
        const Duration(days: 365 * 10),
      ),
    );

    if (selectedDate != null) {
      setState(
        () {
          //Set state of the LedgerInput
          //Note: Whenever setting the date time state, use UTC
          input.dateTime = selectedDate.toUtc();

          //Note: Whenever setting the date time to display, use Local
          //Convert to string just for the display in the TextField
          //Underlying data type in the LedgerInput class is still a DateTime
          input.dateTimeController.text =
              dateLongFormatter.format(selectedDate.toLocal());
        },
      );
    }
  }

  void _resetDateToToday(LedgerInput input, DateTime now) {
    setState(() => input.dateTime = now);
  }

  void _selectAccount(BuildContext context, LedgerInput input) {
    showDialog<String>(
      context: context,
      builder: (context) => AccountPicker(
        context: context,
        onPressed: (String? value) {
          if (value != null) {
            //Set value and close the dialog
            setState(() => input.accountOrAccountFrom = value);
            Navigator.pop(context);
            input.accountOrAccountFromController.text =
                input.accountOrAccountFrom;
            return;
          }
          //Close the dialog without selecting any account
          Navigator.pop(context);
        },
      ),
    );
  }

  void _selectCategory() {}

  //To be called when
  //1. Editing the amount in each transaction,
  //2. Changing TransactionType,
  //3. Removing rows and
  //4. Undoing removal
  void _tallyAll() {
    double incomeSum = 0.0;
    double expenseSum = 0.0;
    double transferSum = 0.0;

    for (LedgerInput element in entries) {
      switch (element.type) {
        case TransactionType.income:
          incomeSum += element.amount;
          break;
        case TransactionType.expense:
          expenseSum += element.amount;
          break;
        case TransactionType.transfer:
          transferSum += element.amount;
          break;
      }
    }
    totalIncome = incomeSum;
    totalExpense = expenseSum;
    totalTransfer = transferSum;
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
              padding: const EdgeInsets.only(top: 16.0, bottom: 64.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Build the dismissible expandable form
                  ...entries.asMap().entries.map((entry) {
                    int index = entry.key;
                    LedgerInput input = entry.value;

                    Key typeKey = const Key('type');
                    Key dateKey = const Key('date');
                    Key accountOrAccountFromKey =
                        const Key('accountOrAccountFrom');
                    Key categoryOrAccountToKey =
                        const Key('categoryOrAccountTo');
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
                                setState(() {
                              entries.elementAt(index).type =
                                  newSelection.first;
                              _tallyAll();
                            }),
                          ),
                          TextField(
                            key: dateKey,
                            controller: input.dateTimeController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Date',
                              suffixIcon: dateLongFormatter
                                          .format(input.dateTime.toLocal()) !=
                                      dateLongFormatter.format(now)
                                  ? IconButton(
                                      onPressed: () {
                                        input.dateTimeController.text =
                                            dateLongFormatter.format(now);
                                        _resetDateToToday(input, now);
                                      },
                                      icon: const Icon(Icons.refresh),
                                    )
                                  : null,
                            ),
                            readOnly: true,
                            showCursor: true,
                            cursorHeight: 0.0,
                            cursorWidth: 0.0,
                            onTap: () => _selectDate(context, input),
                          ),
                          TextField(
                              key: accountOrAccountFromKey,
                              autofocus: true,
                              controller: input.accountOrAccountFromController,
                              decoration: InputDecoration(
                                labelText:
                                    input.type == TransactionType.transfer
                                        ? 'Account From'
                                        : 'Account',
                                border: const OutlineInputBorder(),
                              ),
                              readOnly: true,
                              showCursor: true,
                              cursorHeight: 0.0,
                              cursorWidth: 0.0,
                              onTap: () => _selectAccount(context, input)),
                          TextField(
                            key: categoryOrAccountToKey,
                            controller: input.categoryOrAccountToController,
                            decoration: InputDecoration(
                              labelText: input.type == TransactionType.transfer
                                  ? 'Account To'
                                  : 'Category',
                              border: const OutlineInputBorder(),
                            ),
                            readOnly: true,
                            showCursor: true,
                            cursorHeight: 0.0,
                            cursorWidth: 0.0,
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
                          ),
                          Divider(key: dividerKey),
                          TextField(
                            key: additionalNoteKey,
                            controller: input.additionalNoteController,
                            decoration: const InputDecoration(
                              hintText: 'Additional Notes',
                              helperText:
                                  ' Write notes here for transactions that require more details',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                          ),
                        ],
                      ),
                      onDismissed: (direction) {
                        _removeRowAt(input, index);
                      },
                    );
                  }).toList(),
                  AddRowButton(
                    onPressed: _addRow,
                  ),
                  AddSummary(
                    onSubmitPressed: _handleSubmit,
                    totalTransactions: entries.length,
                    totalIncome: totalIncome,
                    totalExpense: totalExpense,
                    totalTransfer: totalTransfer,
                  ),
                ],
              ),
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
