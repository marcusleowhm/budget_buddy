import 'package:budget_buddy/features/ledger/components/account_from_field.dart';
import 'package:budget_buddy/features/ledger/components/account_picker.dart';
import 'package:budget_buddy/features/ledger/components/add_row_button.dart';
import 'package:budget_buddy/features/ledger/components/add_summary.dart';
import 'package:budget_buddy/features/ledger/components/additional_note_field.dart';
import 'package:budget_buddy/features/ledger/components/amount_field.dart';
import 'package:budget_buddy/features/ledger/components/amount_typer.dart';
import 'package:budget_buddy/features/ledger/components/category_account_to_field.dart';
import 'package:budget_buddy/features/ledger/components/category_picker.dart';
import 'package:budget_buddy/features/ledger/components/note_field.dart';
import 'package:budget_buddy/features/ledger/components/type_picker.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/widgets/expansion_group.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';

import '../../../../utilities/date_formatter.dart';
import '../../components/date_field.dart';

class AddLedgerScreen extends StatefulWidget {
  const AddLedgerScreen({super.key});

  @override
  State<AddLedgerScreen> createState() => _AddLedgerScreenState();
}

class _AddLedgerScreenState extends State<AddLedgerScreen> {
  //State managed by the screen
  List<LedgerInput> entries = <LedgerInput>[];

  //Data passed to the summary widget
  Map<String, Map<String, double>> currenciesTotal = {};

  DateTime now = DateTime.now();

  // Key to get Scaffold and show bottom sheet.
  // Also a controller to close the bottom sheet when tapped outside
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PersistentBottomSheetController? _bottomSheetController;

  //Scroll controller for scrolling down
  final ScrollController _scrollController = ScrollController();
  //Variable to track whether to show the jump to bottom button
  bool isScrollToBottomVisible = false;
  //Scroll alignment for keeping the widget visible on click
  static const double scrollAlignment = 0.55;
  static const Duration scrollDuration = Duration(milliseconds: 300);

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

    //Add GlobalKey for each LedgerInput's input widget
    GlobalKey dateTimeKey = GlobalKey();
    GlobalKey accountOrAccountFromKey = GlobalKey();
    GlobalKey categoryOrAccountToKey = GlobalKey();
    GlobalKey amountKey = GlobalKey();
    GlobalKey noteKey = GlobalKey();
    GlobalKey dividerKey = GlobalKey();
    GlobalKey additionalNoteKey = GlobalKey();

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
        dateTimeKey: dateTimeKey,
        accountOrAccountFromKey: accountOrAccountFromKey,
        categoryOrAccountToKey: categoryOrAccountToKey,
        amountKey: amountKey,
        noteKey: noteKey,
        dividerKey: dividerKey,
        additionalNoteKey: additionalNoteKey,
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
          double number = double.tryParse(amountController.text
                  .replaceAll(',', '')
                  .replaceAll('\$', '')) ??
              0.0;
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

  void _clearAmount(LedgerInput input) {
    setState(() => input.amount = 0.0);
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

  Future<void> _scrollToWidget(GlobalKey widgetKey, double alignment) async {
    await Future.delayed(const Duration(milliseconds: 400));
    Scrollable.ensureVisible(
      widgetKey.currentContext!,
      duration: scrollDuration,
      alignment: alignment,
      curve: Curves.easeInOut,
    );
    return;
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
              _scrollToWidget(input.categoryOrAccountToKey, scrollAlignment);
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
            _scrollToWidget(input.amountKey, scrollAlignment);
          } else {
            _closeBottomSheet();
          }
        },
      );
    });
  }

  void _setCurrency(LedgerInput input, String? selection) {
    if (selection != null) {
      setState(() => input.currency = selection);
    }
  }

  void _selectAmount(LedgerInput input) {
    _bottomSheetController =
        _scaffoldKey.currentState?.showBottomSheet<void>((context) {
      return AmountTyper(
        input: input,
        onCancelPressed: _closeBottomSheet,
        moveFocusTo: _moveFocusTo,
        scrollToWidget: _scrollToWidget,
        closeBottomSheet: _closeBottomSheet,
      );
    });
  }

  //To be called when
  //1. Editing the amount in each transaction,
  //2. Changing TransactionType,
  //3. Removing rows and
  //4. Undoing removal
  void _tallyAll() {
    const String incomeSum = 'incomeSum';
    const String expenseSum = 'expenseSum';
    const String transferSum = 'transferSum';

    //For each of the currencies present in the entries, init their sum value
    Set<String> currencies = entries.map((input) => input.currency).toSet();

    //Remove all currencies in the map first
    setState(() => currenciesTotal = {});
    for (String currency in currencies) {
      Map<String, double> totals = {
        incomeSum: 0.0,
        expenseSum: 0.0,
        transferSum: 0.0
      };
      //Reset all the currencies to be 0.0
      setState(() => currenciesTotal[currency] = totals);
    }

    //Loop through and tally up
    for (LedgerInput input in entries) {
      switch (input.type) {
        case TransactionType.income:
          double? income = currenciesTotal[input.currency]?[incomeSum];
          setState(() => currenciesTotal[input.currency]?[incomeSum] =
              income! + input.amount);
          break;
        case TransactionType.expense:
          double? expense = currenciesTotal[input.currency]?[expenseSum];
          setState(() => currenciesTotal[input.currency]?[expenseSum] =
              expense! + input.amount);
          break;
        case TransactionType.transfer:
          double? transfer = currenciesTotal[input.currency]?[transferSum];
          setState(() => currenciesTotal[input.currency]?[transferSum] =
              transfer! + input.amount);
          break;
      }
    }
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
                          onExpand: (isExpanded) {
                            setState(() => input.isExpanded = isExpanded);
                            if (!isExpanded) {
                              _closeBottomSheet(); //Close the bottom sheet (custom keyboards)
                              FocusManager.instance.primaryFocus
                                  ?.unfocus(); //Should close keyboard too
                            }
                          },
                          ledger: input,
                          children: [
                            TypePicker(
                              type: input.type,
                              setType: (Set<TransactionType> newSelection) =>
                                  setState(() {
                                entries.elementAt(index).type =
                                    newSelection.first;
                                _tallyAll();
                              }),
                            ),
                            DateField(
                              input: input,
                              now: now,
                              onTapTrailing: _resetDateToToday,
                              onTap: () {
                                _closeBottomSheet();
                                _selectDate(context, input);
                              },
                            ),
                            AccountFromField(
                              input: input,
                              onTapTrailing: () {
                                _clearAccount(input);
                              },
                              onTap: () {
                                _scrollToWidget(
                                  input.accountOrAccountFromKey,
                                  scrollAlignment,
                                );
                                _selectAccount(input);
                              },
                            ),
                            CategoryAccountToField(
                              input: input,
                              onTapTrailing: () {
                                _clearCategory(input);
                              },
                              onTap: () {
                                _scrollToWidget(
                                  input.categoryOrAccountToKey,
                                  scrollAlignment,
                                );
                                _selectCategory(input);
                              },
                            ),
                            AmountField(
                              input: input,
                              onCurrencyChange: (String? selection) {
                                _setCurrency(input, selection);
                                _tallyAll();
                              },
                              onTapTrailing: () {
                                _clearAmount(input);
                              },
                              onTap: () {
                                _scrollToWidget(
                                  input.amountKey,
                                  scrollAlignment,
                                );
                                _selectAmount(input);
                              },
                            ),
                            NoteField(
                              input: input,
                              onTapTrailing: () {
                                _clearNote(input);
                              },
                              onTap: () {
                                _closeBottomSheet();
                                _scrollToWidget(
                                  input.noteKey,
                                  1,
                                );
                              },
                              onEditingComplete: () {
                                _moveFocusTo(input.additionalNoteFocus);
                                _scrollToWidget(
                                  input.additionalNoteKey,
                                  1,
                                );
                              },
                            ),
                            Divider(key: input.dividerKey),
                            AdditionalNoteField(
                              input: input,
                              onTapTrailing: () {
                                _clearAdditionalNote(input);
                              },
                              onTap: () {
                                _closeBottomSheet();
                                _scrollToWidget(
                                  input.additionalNoteKey,
                                  1,
                                );
                              },
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
                      currenciesTotal: currenciesTotal,
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
