import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/components/form/account/account_picker.dart';
import 'package:budget_buddy/features/ledger/components/form/amount/amount_typer.dart';
import 'package:budget_buddy/features/ledger/components/form/buttons/secondary_action_buttons.dart';
import 'package:budget_buddy/features/ledger/components/form/category/category_picker.dart';
import 'package:budget_buddy/features/ledger/components/form/account/account_field.dart';
import 'package:budget_buddy/features/ledger/components/form/buttons/add_row_button.dart';
import 'package:budget_buddy/features/ledger/components/form/summary/add_summary.dart';
import 'package:budget_buddy/features/ledger/components/form/form_fields/additional_note_field.dart';
import 'package:budget_buddy/features/ledger/components/form/amount/amount_field.dart';
import 'package:budget_buddy/features/ledger/components/form/form_fields/category_field.dart';
import 'package:budget_buddy/features/ledger/components/form/datetime/date_field.dart';
import 'package:budget_buddy/features/ledger/components/form/note/note_field.dart';
import 'package:budget_buddy/features/ledger/components/form/type/type_picker.dart';
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
import 'package:flutter_slidable/flutter_slidable.dart';

class AddLedgerScreen extends StatefulWidget {
  const AddLedgerScreen({super.key, this.inputToClone});

  final LedgerInput? inputToClone;

  @override
  State<AddLedgerScreen> createState() => _AddLedgerScreenState();
}

class _AddLedgerScreenState extends State<AddLedgerScreen> {
  //Date for the datepicker
  DateTime localNow = DateTime.now();

  //Keep track of whether the form is valid
  bool isValid = false;

  //Error message Shaker key
  GlobalKey<ShakeErrorState> messageKey = GlobalKey<ShakeErrorState>();

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

    //If dataToClone is passed in, we are cloning existing transaction, but set date to today
    if (widget.inputToClone != null) {
      BlocProvider.of<UTransactionCubit>(context)
          .cloneFromInput(widget.inputToClone!);
      BlocProvider.of<UTransactionCubit>(context)
          .setDateOf(firstInput, localNow);
      firstInput.dateTimeController.text = dateLongFormatter.format(localNow);
    }

    //Initialize the bottom sheet to null
    _bottomSheetController = null;

    //The first entry is already added before the widget is built
    firstInput.moveFocusToNext(
      _selectAccount,
      _selectCategory,
      _selectAmount,
    );

    super.initState();
  }

  void _removeRowAt(BuildContext context, LedgerInput input, int index) {
    BlocProvider.of<UTransactionCubit>(context).removeRowAt(index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text('Transaction removed'),
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
    setState(() => isValid = input.isFormValid());
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
      initialDate: input.data.utcDateTime.toLocal(),
      firstDate: DateTime(1970),
      lastDate: localNow.add(
        const Duration(days: 365 * 10),
      ),
    );
    return selectedDate;
  }

  void _setDate(BuildContext context, LedgerInput input) {
    _selectDate(context, input).then((selectedDate) {
      if (selectedDate != null) {
        //Set value and close the dialog
        BlocProvider.of<UTransactionCubit>(context)
            .setDateOf(input, selectedDate);
        input.dateTimeController.text = dateLongFormatter.format(selectedDate);

        //Move focus to account after selecting date
        input.moveFocusToNext(
          _selectAccount,
          _selectCategory,
          _selectAmount,
        );
        setState(() => isValid = input.isFormValid());
      }
    });
  }

  void _selectAccount(LedgerInput input) {
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
              onPressed: (selectedAccount, selectedSubAccount) async {
                if (selectedAccount != null) {
                  //Set value and validate account
                  BlocProvider.of<UTransactionCubit>(context)
                      .setAccountOf(input, selectedAccount, selectedSubAccount);
                  input.accountKey.currentState?.validate();

                  _closeBottomSheet();
                  setState(() => isValid = input.isFormValid());
                  //Move focus to category after selection
                  input.moveFocusToNext(
                    _selectAccount,
                    _selectCategory,
                    _selectAmount,
                  );
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

  void _selectCategory(LedgerInput input) {
    _scrollToWidget(
      input.data.type == TransactionType.income
          ? input.incomeCategoryKey
          : input.data.type == TransactionType.expense
              ? input.expenseCategoryKey
              : input.transferCategoryKey,
      scrollAlignment,
    );
    _bottomSheetController =
        _scaffoldKey.currentState?.showBottomSheet<void>((context) {
      return CategoryPicker(
        type: input.data.type,
        onPressed: (selectedCategory, selectedSubCategory) {
          if (selectedCategory != null) {
            //Set value depending on type and validate category
            switch (input.data.type) {
              case TransactionType.income:
                BlocProvider.of<UTransactionCubit>(context).setIncomeCategoryOf(
                    input, selectedCategory, selectedSubCategory);
                input.incomeCategoryKey.currentState?.validate();
                break;
              case TransactionType.expense:
                BlocProvider.of<UTransactionCubit>(context)
                    .setExpenseCategoryOf(
                        input, selectedCategory, selectedSubCategory);
                input.expenseCategoryKey.currentState?.validate();
                break;
              case TransactionType.transfer:
                BlocProvider.of<UTransactionCubit>(context)
                    .setTransferCategoryOf(
                        input, selectedCategory, selectedSubCategory);
                print(selectedCategory);
                print(selectedSubCategory);
                input.transferCategoryKey.currentState?.validate();
                break;
            }

            _closeBottomSheet();
            setState(() => isValid = input.isFormValid());
            //Move focus to amount input,
            //Then show the keypad
            input.moveFocusToNext(
              _selectAccount,
              _selectCategory,
              _selectAmount,
            );
          } else {
            _closeBottomSheet();
          }
        },
      );
    });
  }

  void _selectAmount(LedgerInput input) {
    _scrollToWidget(
      input.amountKey,
      scrollAlignment,
    );

    _bottomSheetController =
        _scaffoldKey.currentState?.showBottomSheet<void>((context) {
      return AmountTyper(
        currentAmount: input.data.amount,
        controller: input.amountController,
        onCancelPressed: _closeBottomSheet,
        onKeystroke: (double amount) {
          BlocProvider.of<UTransactionCubit>(context)
              .setAmountOf(input, amount);
          setState(() => isValid = input.isFormValid());
          BlocProvider.of<UTransactionCubit>(context).tallyAllCurrencies();
        },
        onDonePressed: (double amount) {
          BlocProvider.of<UTransactionCubit>(context)
              .setAmountOf(input, amount);
          setState(() => isValid = input.isFormValid());
          BlocProvider.of<UTransactionCubit>(context).tallyAllCurrencies();

          _closeBottomSheet();
          input.moveFocusToNext(
            _selectAccount,
            _selectCategory,
            _selectAmount,
          );
          _scrollToWidget(input.noteKey, 1);
        },
      );
    });
  }

  Widget _buildSlidable(int index, LedgerInput input) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Slidable(
        key: PageStorageKey<String>(input.data.id),
        enabled: !input.isExpanded,
        closeOnScroll: true,
        endActionPane: ActionPane(
          extentRatio: 0.5,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icons.content_copy,
              label: 'Duplicate',
              onPressed: (_) {
                //Add new row
                BlocProvider.of<UTransactionCubit>(context).addInputRow();

                //Copy input data into the last item in entries
                BlocProvider.of<UTransactionCubit>(context)
                    .cloneFromInput(input);
              },
            ),
            SlidableAction(
              backgroundColor: Colors.red,
              icon: Icons.delete_outlined,
              label: 'Delete',
              onPressed: (_) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                _removeRowAt(context, input, index);
                _closeBottomSheet();
              },
            ),
          ],
        ),
        child: ExpansionGroup(
          isExpanded: input.isExpanded,
          onExpand: (isExpanded) {
            BlocProvider.of<UTransactionCubit>(context)
                .setIsExpandedOf(input, isExpanded);
            if (!isExpanded) {
              _closeBottomSheet(); //Close the bottom sheet (custom keyboards)
              FocusManager.instance.primaryFocus
                  ?.unfocus(); //Should close keyboard too
            }
          },
          input: input,
          children: [
            TypePicker(
              type: input.data.type,
              setType: (TransactionType newSelection) {
                if (_bottomSheetController != null) {
                  _bottomSheetController?.setState!(
                    () {
                      input.data.type = newSelection;
                      BlocProvider.of<UTransactionCubit>(context)
                          .tallyAllCurrencies();
                    },
                  );
                } else {
                  BlocProvider.of<UTransactionCubit>(context)
                      .setTypeOf(input, newSelection);
                  BlocProvider.of<UTransactionCubit>(context)
                      .tallyAllCurrencies();
                }
              },
            ),
            DateField(
              input: input,
              controller: input.dateTimeController,
              showIcon: DateTime(
                    input.data.utcDateTime.toLocal().year,
                    input.data.utcDateTime.toLocal().month,
                    input.data.utcDateTime.toLocal().day,
                  ) !=
                  DateTime(
                    localNow.year,
                    localNow.month,
                    localNow.day,
                  ),
              onTapTrailing: () {
                BlocProvider.of<UTransactionCubit>(context)
                    .resetDateOfToToday(input, localNow);
                input.dateTimeController.text =
                    dateLongFormatter.format(localNow);
              },
              onTap: () {
                _closeBottomSheet();
                setState(() => isValid = input.isFormValid());
                _setDate(context, input);
              },
            ),
            AccountField(
              input: input,
              controller: input.accountController,
              onTapTrailing: () {
                BlocProvider.of<UTransactionCubit>(context)
                    .clearAccountOf(input);
                input.accountKey.currentState?.validate();

                setState(() => isValid = input.isFormValid());
                //Focus and select after clearing
                input.moveFocusToNext(
                  _selectAccount,
                  _selectCategory,
                  _selectAmount,
                );
              },
              showIcon: input.data.account.isNotEmpty,
              trailingIcon: const Icon(Icons.cancel_outlined),
              onTap: () {
                _selectAccount(input);
              },
            ),
            CategoryField(
              input: input,
              type: input.data.type,
              controller: input.data.type == TransactionType.income
                  ? input.incomeCategoryController
                  : input.data.type == TransactionType.expense
                      ? input.expenseCategoryController
                      : input.transferCategoryController,
              onTapTrailing: () {
                switch (input.data.type) {
                  case TransactionType.income:
                    BlocProvider.of<UTransactionCubit>(context)
                        .clearIncomeCategoryOf(input);
                    input.incomeCategoryKey.currentState?.validate();
                    break;
                  case TransactionType.expense:
                    BlocProvider.of<UTransactionCubit>(context)
                        .clearExpenseCategoryOf(input);
                    input.expenseCategoryKey.currentState?.validate();
                    break;
                  case TransactionType.transfer:
                    BlocProvider.of<UTransactionCubit>(context)
                        .clearTransferCategoryOf(input);
                    input.transferCategoryKey.currentState?.validate();
                    break;
                }

                setState(() => isValid = input.isFormValid());
                //Focus and select after clearing
                input.moveFocusToNext(
                  _selectAccount,
                  _selectCategory,
                  _selectAmount,
                );
              },
              showIcon: input.data.type == TransactionType.income
                  ? input.data.incomeCategory.isNotEmpty
                  : input.data.type == TransactionType.expense
                      ? input.data.expenseCategory.isNotEmpty
                      : input.data.transferCategory.isNotEmpty,
              trailingIcon: const Icon(Icons.cancel_outlined),
              onTap: () {
                _selectCategory(input);
              },
            ),
            AmountField(
              input: input,
              controller: input.amountController,
              onCurrencyChange: (String? selection) {
                BlocProvider.of<UTransactionCubit>(context)
                    .setCurrencyOf(input, selection);
                BlocProvider.of<UTransactionCubit>(context)
                    .tallyAllCurrencies();
                setState(() => isValid = input.isFormValid());
              },
              onTapTrailing: () {
                BlocProvider.of<UTransactionCubit>(context)
                    .clearAmountOf(input);
                BlocProvider.of<UTransactionCubit>(context)
                    .tallyAllCurrencies();
                setState(() => isValid = input.isFormValid());

                //Focus and select when clearing
                input.moveFocusToNext(
                  _selectAccount,
                  _selectCategory,
                  _selectAmount,
                );
              },
              showIcon: input.amountController.text.isNotEmpty,
              trailingIcon: const Icon(Icons.cancel_outlined),
              onTap: () {
                _selectAmount(input);
              },
            ),
            NoteField(
              input: input,
              controller: input.noteController,
              onTapTrailing: () {
                BlocProvider.of<UTransactionCubit>(context).clearNoteOf(input);
                setState(() => isValid = input.isFormValid());
                //Focus after clearing
                input.moveFocusToNext(
                  _selectAccount,
                  _selectCategory,
                  _selectAmount,
                );
              },
              showIcon: input.data.note.isNotEmpty,
              trailingIcon: const Icon(Icons.cancel_outlined),
              onTap: () {
                setState(() => isValid = input.isFormValid());
                _closeBottomSheet();
                _scrollToWidget(
                  input.noteKey,
                  1,
                );
              },
              onEditingComplete: () {
                setState(() => isValid = input.isFormValid());
                _closeBottomSheet();
                input.moveFocusToNext(
                  _selectAccount,
                  _selectCategory,
                  _selectAmount,
                );
                _scrollToWidget(
                  input.additionalNoteKey,
                  1,
                );
              },
            ),
            const Divider(),
            AdditionalNoteField(
              input: input,
              controller: input.additionalNoteController,
              onTapTrailing: () {
                BlocProvider.of<UTransactionCubit>(context)
                    .clearAdditionalNoteAt(input);
                setState(() => isValid = input.isFormValid());
                //Focus on it after clearing
                input.moveFocusToNext(
                  _selectAccount,
                  _selectCategory,
                  _selectAmount,
                );
              },
              showIcon: input.data.additionalNote.isNotEmpty,
              trailingIcon: const Icon(Icons.cancel_outlined),
              onTap: () {
                setState(() => isValid = input.isFormValid());
                _closeBottomSheet();
                _scrollToWidget(
                  input.additionalNoteKey,
                  1,
                );
              },
            ),
            const Divider(),
            SecondaryActionButton(
              onDuplicatePressed: () {
                //Add new row
                BlocProvider.of<UTransactionCubit>(context).addInputRow();

                //Copy input data into the last item in entries
                BlocProvider.of<UTransactionCubit>(context)
                    .cloneFromInput(input);
              },
              onDeletePressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                _removeRowAt(context, input, index);
                _closeBottomSheet();
              },
            )
          ],
        ),
      ),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //Build the dismissible expandable form
                        ...state.entries
                            .asMap()
                            .entries
                            .map(
                              (entry) => ShakeError(
                                key: entry.value.formShakerKey,
                                duration: const Duration(milliseconds: 600),
                                shakeCount: 4,
                                shakeOffset: 10,
                                child: _buildSlidable(entry.key, entry.value),
                              ),
                            )
                            .toList(),
                        AddRowButton(
                          onPressed: () {
                            BlocProvider.of<UTransactionCubit>(context)
                                .addInputRow();
                          },
                        ),
                        AddSummary(
                          messageKey: messageKey,
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
                                .hasSubmitted()) {
                              BlocProvider.of<CTransactionCubit>(context)
                                  .addTransactions(state.entries
                                      .map((input) => input.data)
                                      .toList());

                              //Close the bottom sheet if open (Usually the sheet will block the submit button)
                              if (_bottomSheetController != null) {
                                _bottomSheetController?.close();
                              }

                              //Close the snackbar because we are navigating back
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Navigator.of(context).pop();
                            } else {
                              messageKey.currentState?.shake();
                              setState(() => isValid = false);
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
