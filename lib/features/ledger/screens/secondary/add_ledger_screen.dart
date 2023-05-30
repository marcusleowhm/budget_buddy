import 'package:budget_buddy/features/ledger/components/inputs/account/account_picker.dart';
import 'package:budget_buddy/features/ledger/components/inputs/amount_typer.dart';
import 'package:budget_buddy/features/ledger/components/inputs/category/category_picker.dart';
import 'package:budget_buddy/features/ledger/components/inputs/form_fields/account_from_field.dart';
import 'package:budget_buddy/features/ledger/components/inputs/form_fields/add_row_button.dart';
import 'package:budget_buddy/features/ledger/components/inputs/form_fields/add_summary.dart';
import 'package:budget_buddy/features/ledger/components/inputs/form_fields/additional_note_field.dart';
import 'package:budget_buddy/features/ledger/components/inputs/form_fields/amount_field.dart';
import 'package:budget_buddy/features/ledger/components/inputs/form_fields/category_account_to_field.dart';
import 'package:budget_buddy/features/ledger/components/inputs/form_fields/date_field.dart';
import 'package:budget_buddy/features/ledger/components/inputs/form_fields/note_field.dart';
import 'package:budget_buddy/features/ledger/components/inputs/type_picker.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/cubit/u_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/widgets/expansion_group.dart';
import 'package:budget_buddy/features/ledger/widgets/widget_shaker.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLedgerScreen extends StatefulWidget {
  const AddLedgerScreen({super.key});

  @override
  State<AddLedgerScreen> createState() => _AddLedgerScreenState();
}

class _AddLedgerScreenState extends State<AddLedgerScreen> {
  //Date for the datepicker
  DateTime localNow = DateTime.now();

  //Keep track of whether the form is valid
  bool isValid = false;

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
    UTransactionState state = context.read<UTransactionCubit>().state;
    LedgerInput firstInput = state.entries.first;

    //init the note and additional note controller with listeners
    firstInput.noteController.addListener(() {
      BlocProvider.of<UTransactionCubit>(context).setNoteAt(0, firstInput.noteController.text);
    });
    firstInput.additionalNoteController.addListener(() {
      BlocProvider.of<UTransactionCubit>(context).setAdditionalNoteAt(0, firstInput.additionalNoteController.text);
    });

    //The first entry is already added before the widget is built
    _moveFocusTo(firstInput.accountOrAccountFromFocus);
    _selectAccount(firstInput, firstInput.amountController, 0);
    super.initState();
  }

  void _removeRowAt(BuildContext context, LedgerInput input, int index) {
    BlocProvider.of<UTransactionCubit>(context).removeRowAt(index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Record removed'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            BlocProvider.of<UTransactionCubit>(context)
                .insertEntryAt(index, input);
            BlocProvider.of<UTransactionCubit>(context).tallyAllCurrencies();
          },
        ),
      ),
    );
    BlocProvider.of<UTransactionCubit>(context).tallyAllCurrencies();
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

  Future<DateTime?> _selectDate(BuildContext context, LedgerInput input) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: input.utcDateTime.toLocal(),
      firstDate: DateTime(1970),
      lastDate: localNow.add(
        const Duration(days: 365 * 10),
      ),
    );
    return selectedDate;
  }

  void _setDate(
    BuildContext context,
    int index,
    TextEditingController dateController,
    TextEditingController amountController,
    LedgerInput input,
  ) {
    _selectDate(context, input).then((selectedDate) {
      if (selectedDate != null) {
        //Set value and close the dialog
        BlocProvider.of<UTransactionCubit>(context)
            .setDateAt(index, selectedDate);
        dateController.text = dateLongFormatter.format(selectedDate);

        //Move focus to account after selecting date
        _moveFocusTo(input.accountOrAccountFromFocus);
        _selectAccount(input, amountController, index);
      }
    });
  }

  void _selectAccount(LedgerInput input, TextEditingController amountController, int index) {
    _scrollToWidget(
      input.accountKey,
      scrollAlignment,
    );
    //To allow initState to call this function and open the account selection
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _bottomSheetController =
            _scaffoldKey.currentState?.showBottomSheet<void>(
          (context) {
            return AccountPicker(
              onPressed: (selectedAccount) async {
                if (selectedAccount != null) {
                  //Set val ue and close the dialog
                  BlocProvider.of<UTransactionCubit>(context)
                      .setAccountAt(index, selectedAccount);

                  setState(() => isValid =
                      BlocProvider.of<UTransactionCubit>(context)
                          .validateForm());

                  //Move focus to category after selection
                  _moveFocusTo(input.categoryOrAccountToFocus);
                  _selectCategory(input, amountController, index);
                } else {
                  _closeBottomSheet();
                }
              },
            );
          },
        );
      },
    );
  }

  void _selectCategory(LedgerInput input, TextEditingController amountController, int index) {
    _scrollToWidget(
      input.categoryOrAccountToKey,
      scrollAlignment,
    );
    _bottomSheetController =
        _scaffoldKey.currentState?.showBottomSheet<void>((context) {
      return CategoryPicker(
        isTransfer: (input.type == TransactionType.transfer),
        onPressed: (selectedCategory) {
          if (selectedCategory != null) {
            //Set value and close the dialog
            BlocProvider.of<UTransactionCubit>(context)
                .setCategoryAt(index, selectedCategory);
            setState(() => isValid =
                BlocProvider.of<UTransactionCubit>(context).validateForm());
            //Move focus to amount input,
            //Then show the keypad
            _moveFocusTo(input.amountFocus);
            _selectAmount(input, amountController, index);
          } else {
            _closeBottomSheet();
          }
        },
      );
    });
  }

  void _selectAmount(LedgerInput input, TextEditingController amountController, int index) {
    _scrollToWidget(
      input.amountKey,
      scrollAlignment,
    );
    _bottomSheetController =
        _scaffoldKey.currentState?.showBottomSheet<void>((context) {
      return AmountTyper(
        currentAmount: context.read<UTransactionCubit>().state.entries.elementAt(index).amount,
        controller: amountController,
        onCancelPressed: _closeBottomSheet,
        onKeystroke: (amountString) {
          BlocProvider.of<UTransactionCubit>(context)
              .setAmountAt(index, amountString);
          BlocProvider.of<UTransactionCubit>(context).tallyAllCurrencies();
        },
        onDonePressed: (amountString) {
          BlocProvider.of<UTransactionCubit>(context)
              .setAmountAt(index, amountString);
          BlocProvider.of<UTransactionCubit>(context).tallyAllCurrencies();
          
          _moveFocusTo(input.noteFocus);
          _scrollToWidget(input.noteKey, 1);
        },
        closeBottomSheet: _closeBottomSheet,
      );
    });
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
                child: BlocBuilder<UTransactionCubit, UTransactionState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //Build the dismissible expandable form
                        ...state.entries.asMap().entries.map((entry) {
                          int index = entry.key;
                          LedgerInput input = entry.value;

                          return ShakeError(
                            key: input.formShakerKey,
                            duration: const Duration(milliseconds: 600),
                            shakeCount: 4,
                            shakeOffset: 10,
                            child: Dismissible(
                              key: PageStorageKey<String>(input.id),
                              //Show red background when swiped left to right
                              background: _buildDismissibleBackground(
                                  Alignment.centerLeft),
                              //Show red background when swiped right to left
                              secondaryBackground: _buildDismissibleBackground(
                                  Alignment.centerRight),
                              onDismissed: (direction) {
                                //Remove the previous snackbar first if it's still present. Otherwise it will cause issues with inserting at index
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                _removeRowAt(context, input, index);
                                _closeBottomSheet();
                              },
                              child: ExpansionGroup(
                                isExpanded: input.isExpanded == true,
                                onExpand: (isExpanded) {
                                  BlocProvider.of<UTransactionCubit>(context)
                                      .setIsExpanded(index, isExpanded);
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
                                    setType: (TransactionType newSelection) {
                                      if (_bottomSheetController != null) {
                                        _bottomSheetController?.setState!(
                                          () {
                                            input.type = newSelection;
                                            BlocProvider.of<UTransactionCubit>(
                                                    context)
                                                .tallyAllCurrencies();
                                          },
                                        );
                                      } else {
                                        BlocProvider.of<UTransactionCubit>(
                                                context)
                                            .setTypeAt(index, newSelection);
                                        BlocProvider.of<UTransactionCubit>(
                                                context)
                                            .tallyAllCurrencies();
                                      }
                                    },
                                  ),
                                  DateField(
                                    input: input,
                                    controller: input.dateTimeController,
                                    now: localNow,
                                    onTapTrailing: () {
                                      BlocProvider.of<UTransactionCubit>(
                                              context)
                                          .resetDateAtToToday(index, localNow);
                                      input.dateTimeController.text =
                                          dateLongFormatter.format(localNow);
                                    },
                                    onTap: () {
                                      _closeBottomSheet();
                                      _setDate(
                                        context,
                                        index,
                                        input.dateTimeController,
                                        input.amountController,
                                        input,
                                      );
                                    },
                                  ),
                                  AccountFromField(
                                    input: input,
                                    controller:
                                        input.accountOrAccountFromController,
                                    onTapTrailing: () {
                                      BlocProvider.of<UTransactionCubit>(
                                              context)
                                          .clearAccountAt(index);
                                      setState(() => isValid =
                                          BlocProvider.of<UTransactionCubit>(
                                                  context)
                                              .validateForm());
                                    },
                                    onTap: () {
                                      _selectAccount(input, input.amountController, index);
                                    },
                                  ),
                                  CategoryAccountToField(
                                    input: input,
                                    controller:
                                        input.categoryOrAccountToController,
                                    onTapTrailing: () {
                                      BlocProvider.of<UTransactionCubit>(
                                              context)
                                          .clearCategoryAt(index);
                                      setState(() => isValid =
                                          BlocProvider.of<UTransactionCubit>(
                                                  context)
                                              .validateForm());
                                    },
                                    onTap: () {
                                      _selectCategory(input, input.amountController, index);
                                    },
                                  ),
                                  AmountField(
                                    input: input,
                                    controller: input.amountController,
                                    onCurrencyChange: (String? selection) {
                                      BlocProvider.of<UTransactionCubit>(
                                              context)
                                          .setCurrencyAt(index, selection);
                                      BlocProvider.of<UTransactionCubit>(
                                              context)
                                          .tallyAllCurrencies();
                                    },
                                    onTapTrailing: () {
                                      BlocProvider.of<UTransactionCubit>(
                                              context)
                                          .clearAmountAt(index);
                                    },
                                    onTap: () {
                                      _selectAmount(input, input.amountController, index);
                                    },
                                  ),
                                  NoteField(
                                    input: input,
                                    controller: input.noteController,
                                    onTapTrailing: () {
                                      BlocProvider.of<UTransactionCubit>(
                                              context)
                                          .clearNoteAt(index);
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
                                    controller: input.additionalNoteController,
                                    onTapTrailing: () {
                                      BlocProvider.of<UTransactionCubit>(
                                              context)
                                          .clearAdditionalNoteAt(index);
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
                            ),
                          );
                        }).toList(),
                        AddRowButton(
                          onPressed: () {
                            BlocProvider.of<UTransactionCubit>(context)
                                .addInputRow();
                          },
                        ),
                        AddSummary(
                          onSubmitPressed: () {
                            //If no entries have been inputted, don't allow submission
                            if (state.entries.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No transaction added'),
                                ),
                              );
                              return;
                            }
                            //Submission
                            if (BlocProvider.of<UTransactionCubit>(context)
                                .handleSubmit()) {
                              BlocProvider.of<CTransactionCubit>(context)
                                  .addTransactions(state.entries);

                              //Close the bottom sheet if open (Usually the sheet will block the submit button)
                              if (_bottomSheetController != null) {
                                _bottomSheetController?.close();
                              }

                              //Close the snackbar because we are navigating back
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Navigator.of(context).pop();
                            }
                          },
                          isValid: isValid,
                          totalTransactions: state.entries.length,
                          currenciesTotal: state.currenciesTotal,
                        ),
                      ],
                    );
                  },
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
