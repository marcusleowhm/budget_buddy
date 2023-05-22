import 'package:budget_buddy/features/ledger/components/account_picker.dart';
import 'package:budget_buddy/features/ledger/components/add_row_button.dart';
import 'package:budget_buddy/features/ledger/components/add_summary.dart';
import 'package:budget_buddy/features/ledger/components/amount_typer.dart';
import 'package:budget_buddy/features/ledger/components/category_picker.dart';
import 'package:budget_buddy/features/ledger/components/type_picker.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/widgets/expansion_group.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';

import '../../../../utilities/date_formatter.dart';

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

  // Key to get Scaffold and show bottom sheet.
  // Also a controller to close the bottom sheet when tapped outside
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PersistentBottomSheetController? _bottomSheetController;

  //Scroll controller for scrolling down
  final ScrollController _scrollController = ScrollController();
  //Variable to track whether to show the jump to bottom button
  bool isScrollToBottomVisible = false;

  //Keys for the TextFields
  Key typeKey = const Key('type');
  Key dateKey = const Key('date');
  Key accountOrAccountFromKey = const Key('accountOrAccountFrom');
  Key categoryOrAccountToKey = const Key('categoryOrAccountTo');
  Key amountKey = const Key('amount');
  Key noteKey = const Key('note');
  Key dividerKey = const Key('divider');
  Key additionalNoteKey = const Key('additionalNote');

  @override
  void initState() {
    super.initState();
    if (entries.isEmpty) {
      _addRow();
      _moveFocusTo(entries.first.accountOrAccountFromFocus);
      _selectAccount(entries.first);
    }
  }

  @override
  void dispose() {
    for (LedgerInput input in entries) {
      input
        ..dateTimeController.dispose()
        ..accountOrAccountFromController.dispose()
        ..categoryOrAccountToController.dispose()
        ..amountController.dispose()
        ..noteController.dispose()
        ..additionalNoteController.dispose()
        ..dateTimeFocus.dispose()
        ..accountOrAccountFromFocus.dispose()
        ..categoryOrAccountToFocus.dispose()
        ..amountFocus.dispose()
        ..noteFocus.dispose()
        ..additionalNoteFocus.dispose();
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

    //Add focus nodes
    FocusNode dateTimeFocus = FocusNode();
    FocusNode accountOrAccountFromFocus = FocusNode();
    FocusNode categoryOrAccountToFocus = FocusNode();
    FocusNode amountFocus = FocusNode();
    FocusNode noteFocus = FocusNode();
    FocusNode additionalNoteFocus = FocusNode();

    //Create a ledger and add controllers
    LedgerInput newLedger = LedgerInput(
        id: const Uuid().v4(),
        dateTimeController: dateTimeController,
        accountOrAccountFromController: accountOrAccountFromController,
        categoryOrAccountToController: categoryOrAccountToController,
        amountController: amountController,
        noteController: noteController,
        additionalNoteController: additionalNoteController,
        dateTimeFocus: dateTimeFocus,
        accountOrAccountFromFocus: accountOrAccountFromFocus,
        categoryOrAccountToFocus: categoryOrAccountToFocus,
        amountFocus: amountFocus,
        noteFocus: noteFocus,
        additionalNoteFocus: additionalNoteFocus);

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

  void _resetDateToToday(LedgerInput input, DateTime now) {
    setState(() => input.dateTime = now);
  }

  void _clearAccount(LedgerInput input) {
    setState(() => input.accountOrAccountFrom = '');
  }

  void _clearCategory(LedgerInput input) {
    setState(() => input.categoryOrAccountTo = '');
  }

  void _clearNote(LedgerInput input) {
    setState(() => input.note = '');
  }

  void _clearAdditionalNote(LedgerInput input) {
    setState(() => input.additionalNote = '');
  }

  //This function will be called
  //1. Each time the user clicks outside the textfield,
  //2. Each time the user clicks on textfields that require the keyboard
  //3. Each time the user clicks on the X button in the custom textfield
  void _closeBottomSheet() {
    if (_bottomSheetController != null) {
      _bottomSheetController?.close();
    }
    _bottomSheetController = null;
  }

  void _moveFocusTo(FocusNode focus) {
    focus.requestFocus();
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
          //Set state of the LedgerInput to the user selected date
          //Note: Whenever setting the date time state, use UTC
          input.dateTime = selectedDate.toUtc();

          //Note: Whenever setting the date time to display, use Local
          //Convert to string just for the display in the TextField
          //Underlying data type in the LedgerInput class is still a DateTime
          input.dateTimeController.text =
              dateLongFormatter.format(selectedDate.toLocal());
        },
      );

      //Move focus to account after selecting date
      _moveFocusTo(input.accountOrAccountFromFocus);
      _selectAccount(input);
    }
  }

  void _selectAccount(LedgerInput input) {
    //To allow initState to call this function and open the account selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bottomSheetController =
          _scaffoldKey.currentState?.showBottomSheet<void>((context) {
        return AccountPicker(
          onPressed: (selectedAccount) {
            if (selectedAccount != null) {
              //Set value and close the dialog
              setState(() => input.accountOrAccountFrom = selectedAccount);
              input.accountOrAccountFromController.text =
                  input.accountOrAccountFrom;

              //Move focus to categoryOrAccountTo after selection
              _moveFocusTo(input.categoryOrAccountToFocus);
              _selectCategory(input);
            } else {
              _closeBottomSheet();
            }
          },
        );
      });
    });
  }

  void _selectCategory(LedgerInput input) {
    _bottomSheetController =
        _scaffoldKey.currentState?.showBottomSheet<void>((context) {
      return CategoryPicker(
        onPressed: (selectedCategory) {
          if (selectedCategory != null) {
            //Set value and close the dialog
            setState(() => input.categoryOrAccountTo = selectedCategory);
            input.categoryOrAccountToController.text =
                input.categoryOrAccountTo;

            //Move focus to amount input,
            //Then show the keypad
            _moveFocusTo(input.amountFocus);
            _selectAmount(input);
          } else {
            _closeBottomSheet();
          }
        },
      );
    });
  }

  void _selectAmount(LedgerInput input) {
    _bottomSheetController =
        _scaffoldKey.currentState?.showBottomSheet<void>((context) {
      return AmountTyper(
        onCancelPressed: _closeBottomSheet,
        getInput: (dynamic keyPress) {
          _formatAndSetAmount(input, keyPress);
        },
        amount: input.amount,
      );
    });
  }

  void _formatAndSetAmount(LedgerInput input, dynamic keyPress) {
    bool isInteger(double amount) {
      return amount % 1 == 0;
    }

    if (keyPress is! String) {
      //Backspace action here
      String displayedText = input.amountController.text;
      if (displayedText.isEmpty) {
        return;
      }
      displayedText = displayedText.substring(0, displayedText.length - 1);
      input.amountController.text = displayedText;
      double? newValue = double.tryParse(displayedText);
      if (newValue != null) {
        setState(() => input.amount = newValue);
      } else {
        setState(() => input.amount = 0.0);
      }
      return;
    }

    //Do nothing When the user press on empty space in the keypad
    if (keyPress.isEmpty) {
      return;
    }

    if (keyPress == '.') {
      //Add a leading zero and dot if the value is still zero
      //Does not affect the ledger state, so no setState needed
      if (input.amount == 0.0) {
        input.amountController.text = '0.';
        return;
      }
      //Only add a dot if there is no dot yet
      if (!input.amountController.text.contains('.')) {
        input.amountController.text += '.';
        return;
      }
    }

    //TODO logic for adding 100 to the value
    if (keyPress == '00') {}

    int? numberInput = int.tryParse(keyPress);
    if (numberInput != null) {
      //Initially if stored value is 0.0 and there is no decimal
      //Set amount to a single integer
      if (input.amount == 0.0 && !input.amountController.text.contains('.')) {
        setState(() => input.amount = numberInput.toDouble());
        input.amountController.text = input.amount.toInt().toString();
        return;
      }
      //if stored value is 0.0 and there is a decimal (keep decimal places to 2, or maybe 4?) //TODO
      //Add the first decimal to the amount
      if (input.amount == 0.0 && input.amountController.text.contains('.')) {
        String displayText =
            input.amountController.text + numberInput.toString();
        double? newValue = double.tryParse(displayText);
        if (newValue != null) {
          setState(() => input.amount = newValue);
          input.amountController.text = input.amount.toStringAsFixed(1);
        }
        return;
      }
      //If it's not zero, still an integer, and user have not clicked on dot
      //Just add a digit at the back, end result is still an integer value
      if (isInteger(input.amount) &&
          !input.amountController.text.contains('.')) {
        setState(() => input.amount = input.amount * 10 + numberInput);
        input.amountController.text = input.amount.toInt().toString();
        return;
      }
      //if it's not zero, still an integer, and user have clicked on the dot
      //Add a digit after the decimal number, end result is double value
      if (isInteger(input.amount) &&
          input.amountController.text.contains('.')) {
        String displayText =
            input.amountController.text + numberInput.toString();
        double? newValue = double.tryParse(displayText);
        if (newValue != null) {
          setState(() => input.amount = newValue);
          input.amountController.text = input.amount.toStringAsFixed(1);
        }
        return;
      }
      //If it's a decimal value
      //By this point, the number of decimal places can only be 1 or 2
      //Add a digit at the back after the last decimal number
      if (!isInteger(input.amount)) {
        int decimalPlaces = input.amountController.text.split('.')[1].length;
        if (decimalPlaces == 1) {
          String displayText =
              input.amountController.text + numberInput.toString();
          double? newValue = double.tryParse(displayText);
          if (newValue != null) {
            setState(() => input.amount = newValue);
          }
        } else if (decimalPlaces == 2) {
          String extractedText = input.amountController.text
              .substring(0, input.amountController.text.length - 1);
          String displayText = extractedText + numberInput.toString();
          double? newValue = double.tryParse(displayText);
          if (newValue != null) {
            setState(() => input.amount = newValue);
          }
        }
        input.amountController.text = input.amount.toStringAsFixed(2);
        return;
      }
    }
  }

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

  Widget _buildDismissibleBackground(Alignment alignment) {
    return Container(
      color: Colors.red,
      alignment: alignment,
      child: const Icon(Icons.delete),
    );
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
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('${titles[SubRoutes.addledger]}'),
          ),
          backgroundColor: Colors.grey[200], //TODO change this color
          floatingActionButton: isScrollToBottomVisible
              ? FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent);
                    setState(() => isScrollToBottomVisible = false);
                  },
                  child: const Icon(Icons.arrow_downward),
                )
              : null,
          body: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is UserScrollNotification) {
                //If the user scrolls down, show the button
                if (notification.direction == ScrollDirection.reverse) {
                  setState(() => isScrollToBottomVisible = true);
                }
                //If the user scrolls up, hide the button
                if (notification.direction == ScrollDirection.forward) {
                  setState(() => isScrollToBottomVisible = false);
                }
              }
              //When scrolling has ended and has reached the bottom, hide the button
              if (notification is ScrollEndNotification) {
                if (notification.metrics.atEdge) {
                  bool isTop = notification.metrics.pixels == 0;
                  if (!isTop) {
                    setState(() => isScrollToBottomVisible = false);
                  }
                }
              }

              return false;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                padding: const EdgeInsets.only(top: 16.0, bottom: 64.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Build the dismissible expandable form
                    ...entries.asMap().entries.map((entry) {
                      int index = entry.key;
                      LedgerInput input = entry.value;

                      return Dismissible(
                        key: PageStorageKey<String>(input.id),
                        //Show red background when swiped left to right
                        background:
                            _buildDismissibleBackground(Alignment.centerLeft),
                        //Show red background when swiped right to left
                        secondaryBackground:
                            _buildDismissibleBackground(Alignment.centerRight),
                        child: ExpansionGroup(
                          isExpanded: input.isExpanded,
                          onExpand: (value) {
                            setState(() => input.isExpanded = value);
                            if (!value) {
                              _closeBottomSheet();
                            }
                          },
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
                                //Date
                                key: dateKey,
                                focusNode: input.dateTimeFocus,
                                controller: input.dateTimeController,
                                decoration: InputDecoration(
                                  labelText: 'Date',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: dateLongFormatter.format(
                                              input.dateTime.toLocal()) !=
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
                                showCursor: false,
                                onTap: () {
                                  _closeBottomSheet();
                                  _selectDate(context, input);
                                }),
                            TextField(
                              //Account From
                              key: accountOrAccountFromKey,
                              focusNode: input.accountOrAccountFromFocus,
                              controller: input.accountOrAccountFromController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText:
                                    input.type == TransactionType.transfer
                                        ? 'Account From'
                                        : 'Account',
                                suffixIcon: input.accountOrAccountFromController
                                        .text.isEmpty
                                    ? null
                                    : IconButton(
                                        onPressed: () {
                                          input.accountOrAccountFromController
                                              .clear();
                                          _clearAccount(input);
                                        },
                                        icon: const Icon(Icons.cancel_outlined),
                                      ),
                              ),
                              readOnly: true,
                              showCursor: false,
                              onTap: () {
                                _selectAccount(input);
                              },
                            ),
                            TextField(
                              key: categoryOrAccountToKey,
                              focusNode: input.categoryOrAccountToFocus,
                              controller: input.categoryOrAccountToController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText:
                                    input.type == TransactionType.transfer
                                        ? 'Account To'
                                        : 'Category',
                                suffixIcon: input.categoryOrAccountToController
                                        .text.isEmpty
                                    ? null
                                    : IconButton(
                                        onPressed: () {
                                          input.categoryOrAccountToController
                                              .clear();
                                          _clearCategory(input);
                                        },
                                        icon: const Icon(Icons.cancel_outlined),
                                      ),
                              ),
                              readOnly: true,
                              showCursor: false,
                              onTap: () => _selectCategory(input),
                            ),
                            TextField(
                              key: amountKey,
                              focusNode: input.amountFocus,
                              controller: input.amountController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Amount',
                              ),
                              readOnly: true,
                              showCursor: false,
                              onTap: () => _selectAmount(input),
                            ),
                            TextField(
                              key: noteKey,
                              focusNode: input.noteFocus,
                              controller: input.noteController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Note',
                                suffixIcon: input.noteController.text.isEmpty
                                    ? null
                                    : IconButton(
                                        onPressed: () {
                                          input.noteController.clear();
                                          _clearNote(input);
                                        },
                                        icon: const Icon(Icons.cancel_outlined),
                                      ),
                              ),
                              onTap: _closeBottomSheet,
                            ),
                            Divider(key: dividerKey),
                            TextField(
                              key: additionalNoteKey,
                              focusNode: input.additionalNoteFocus,
                              controller: input.additionalNoteController,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  suffixIcon: input
                                          .additionalNoteController.text.isEmpty
                                      ? null
                                      : IconButton(
                                          onPressed: () {
                                            input.additionalNoteController
                                                .clear();
                                            _clearAdditionalNote(input);
                                          },
                                          icon:
                                              const Icon(Icons.cancel_outlined),
                                        ),
                                  hintText: 'Additional Notes',
                                  helperText:
                                      'Write notes here for transactions that require more details'),
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              onTap: _closeBottomSheet,
                            ),
                          ],
                        ),
                        onDismissed: (direction) {
                          _removeRowAt(input, index);
                          _closeBottomSheet();
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
      ),
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return Future.value(true);
      },
    );
  }
}
