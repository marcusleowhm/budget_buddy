import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/components/form/account/account_picker.dart';
import 'package:budget_buddy/features/ledger/components/form/amount/amount_typer.dart';
import 'package:budget_buddy/features/ledger/components/form/category/category_picker.dart';
import 'package:budget_buddy/features/ledger/components/form/account/account_field.dart';
import 'package:budget_buddy/features/ledger/components/form/form_fields/additional_note_field.dart';
import 'package:budget_buddy/features/ledger/components/form/amount/amount_field.dart';
import 'package:budget_buddy/features/ledger/components/form/form_fields/category_field.dart';
import 'package:budget_buddy/features/ledger/components/form/datetime/date_field.dart';
import 'package:budget_buddy/features/ledger/components/form/note/note_field.dart';
import 'package:budget_buddy/features/ledger/components/form/buttons/submit_button.dart';
import 'package:budget_buddy/features/ledger/components/form/type/type_picker.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/components/form/ledger_form.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditLedgerScreen extends StatefulWidget {
  const EditLedgerScreen({
    super.key,
    required this.input,
  });

  final LedgerInput input;

  @override
  State<EditLedgerScreen> createState() => _EditLedgerScreenState();
}

class _EditLedgerScreenState extends State<EditLedgerScreen> {
  //Date for the datepicker
  DateTime localNow = DateTime.now();

  //Keep track of whether the form is valid
  bool isValid = false;

  // Key to get Scaffold and show bottom sheet.
  // Also a controller to close the bottom sheet when tapped outside
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? _bottomSheetController;

  //Scroll controller for scrolling down
  final ScrollController _scrollController = ScrollController();

  //Scroll alignment for keeping the widget visible on click
  static const double scrollAlignment = 0.55;
  static const Duration scrollDuration = Duration(milliseconds: 300);

  //Controller for the edit page form only
  TextEditingController dateTimeController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController additionalNoteController = TextEditingController();

  //Create temporary state to change it all one shot when user submits
  late TransactionType type;
  late DateTime localDateTime;
  late String account;
  late String category;
  late String currency;
  late double amount;
  late String note;
  late String additionalNote;

  @override
  void initState() {
    setState(() => type = widget.input.type);

    //Date
    setState(() => localDateTime = widget.input.utcDateTime.toLocal());
    dateTimeController.text = dateLongFormatter.format(localDateTime);

    //Account
    setState(() => account = widget.input.account);
    accountController.text = account;

    //Category
    setState(() => category = widget.input.category);
    categoryController.text = category;

    //Currency
    setState(() => currency = widget.input.currency);

    //Amount
    setState(() => amount = widget.input.amount);
    amountController.text =
        englishDisplayCurrencyFormatter.format(widget.input.amount);

    //Note
    setState(() => note = widget.input.note);
    noteController.text = note;
    noteController.addListener(() {
      setState(() => note = noteController.text);
    });

    //Additional note
    setState(() => additionalNote = widget.input.additionalNote);
    additionalNoteController.text = additionalNote;
    additionalNoteController.addListener(() {
      setState(() => additionalNote = additionalNoteController.text);
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    dateTimeController.dispose();
    accountController.dispose();
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

  void _closeBottomSheet() {
    if (_bottomSheetController != null) {
      _bottomSheetController?.close();
    }
    _bottomSheetController = null;
  }

  Future<DateTime?> _selectDate(
      BuildContext context, LedgerInput ledger) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: ledger.utcDateTime.toLocal(),
      firstDate: DateTime(1970),
      lastDate: localNow.add(
        const Duration(days: 365 * 10),
      ),
    );
    return selectedDate;
  }

  void _setDate(BuildContext context) {
    _selectDate(context, widget.input).then((selectedDate) {
      if (selectedDate != null) {
        //Set value and close the dialog
        setState(
          () {
            localDateTime = selectedDate;
            dateTimeController.text = dateLongFormatter.format(localDateTime);
          },
        );
        //Move focus to account after selecting date
        _moveFocusTo(widget.input.accountFocus);
        _selectAccount();
      }
    });
  }

  void _resetDate() {
    setState(() {
      localDateTime = widget.input.utcDateTime.toLocal();
      dateTimeController.text = dateLongFormatter.format(localDateTime);
    });
  }

  void _selectAccount() {
    //To allow initState to call this function and open the account selection
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _bottomSheetController =
            _scaffoldKey.currentState?.showBottomSheet<void>(
          (context) {
            return AccountPicker(
              onPressed: (selectedAccount) {
                if (selectedAccount != null) {
                  //Set value and close the dialog
                  setState(() {
                    account = selectedAccount;
                    accountController.text = account;
                  });
                  _moveFocusTo(widget.input.categoryFocus);
                  _selectCategory();
                  _scrollToWidget(widget.input.categoryKey, scrollAlignment);
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

  void _resetAccount() {
    setState(() {
      account = widget.input.account;
      accountController.text = account;
    });
  }

  void _selectCategory() {
    _bottomSheetController =
        _scaffoldKey.currentState?.showBottomSheet<void>((context) {
      return CategoryPicker(
        type: type,
        onPressed: (selectedCategory) {
          if (selectedCategory != null) {
            //Set value and close the dialog
            setState(() {
              category = selectedCategory;
              categoryController.text = category;
            });
            //Move focus to amount input,
            //Then show the keypad
            _moveFocusTo(widget.input.amountFocus);
            _selectAmount();
            _scrollToWidget(widget.input.amountKey, scrollAlignment);
          } else {
            _closeBottomSheet();
          }
        },
      );
    });
  }

  void _resetCategory() {
    setState(() {
      category = widget.input.category;
      categoryController.text = category;
    });
  }

  void _setCurrency(String? selection) {
    if (selection != null) {
      setState(() => currency = selection);
    }
  }

  void _resetAmount() {
    setState(() {
      amount = widget.input.amount;
      amountController.text = englishDisplayCurrencyFormatter.format(amount);
    });
  }

  void _selectAmount() {
    _bottomSheetController =
        _scaffoldKey.currentState?.showBottomSheet<void>((context) {
      return AmountTyper(
        currentAmount: amount,
        controller: amountController,
        onCancelPressed: _closeBottomSheet,
        onKeystroke: (double newValue) {
          setState(() => amount = newValue);
        },
        onDonePressed: (double newValue) {
          setState(() => amount = newValue);

          _moveFocusTo(widget.input.noteFocus);
          _scrollToWidget(widget.input.noteKey, 1.0);
        },
        closeBottomSheet: _closeBottomSheet,
      );
    });
  }

  void _resetNote() {
    setState(() {
      note = widget.input.note;
      noteController.text = note;
      noteController.selection =
          TextSelection.collapsed(offset: noteController.text.length);
    });
  }

  void _resetAdditionalNote() {
    setState(() {
      additionalNote = widget.input.additionalNote;
      additionalNoteController.text = additionalNote;
      additionalNoteController.selection =
          TextSelection.collapsed(offset: additionalNoteController.text.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
            title: Text('${titles[SubRoutes.editLedger]}'),
          ),
          backgroundColor: Colors.grey[200], //TODO change color
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
                padding: const EdgeInsets.only(top: 16.0, bottom: 64.0),
                child: BlocBuilder<CTransactionCubit, CTransactionState>(
                    builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: const BorderRadius.all(
                            //Edit this to change the border radius for the ExpansionTile
                            Radius.circular(0),
                          ),
                        ),
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: Form(
                            child: Column(
                          children: [
                            LedgerForm(ledger: widget.input, children: [
                              TypePicker(
                                type: type,
                                setType: (TransactionType newSelection) {
                                  if (_bottomSheetController != null) {
                                    _bottomSheetController?.setState!(
                                      () {
                                        setState(() => type = newSelection);
                                      },
                                    );
                                  } else {
                                    setState(() => type = newSelection);
                                  }
                                },
                              ),
                              DateField(
                                input: widget.input,
                                controller: dateTimeController,
                                now: localDateTime,
                                onTapTrailing: _resetDate,
                                onTap: () {
                                  _setDate(context);
                                },
                              ),
                              AccountField(
                                input: widget.input,
                                controller: accountController,
                                onTapTrailing: _resetAccount,
                                showIcon: account != widget.input.account,
                                trailingIcon: const Icon(Icons.refresh),
                                onTap: _selectAccount,
                              ),
                              CategoryField(
                                input: widget.input,
                                type: type,
                                controller: categoryController,
                                onTapTrailing: _resetCategory,
                                showIcon: category != widget.input.category,
                                trailingIcon: const Icon(Icons.refresh),
                                onTap: _selectCategory,
                              ),
                              AmountField(
                                input: widget.input,
                                controller: amountController,
                                onCurrencyChange: (String? newCurrency) {
                                  _setCurrency(newCurrency);
                                },
                                onTapTrailing: _resetAmount,
                                showIcon: amount != widget.input.amount,
                                trailingIcon: const Icon(Icons.refresh),
                                onTap: () {
                                  _selectAmount();
                                },
                              ),
                              NoteField(
                                input: widget.input,
                                controller: noteController,
                                onTapTrailing: _resetNote,
                                showIcon: note != widget.input.note,
                                trailingIcon: const Icon(Icons.refresh),
                                onTap: _closeBottomSheet,
                                onEditingComplete: () {
                                  _moveFocusTo(
                                      widget.input.additionalNoteFocus);
                                  _scrollToWidget(
                                      widget.input.additionalNoteKey, 1.0);
                                },
                              ),
                              const Divider(),
                              AdditionalNoteField(
                                input: widget.input,
                                controller: additionalNoteController,
                                onTapTrailing: _resetAdditionalNote,
                                showIcon: additionalNote !=
                                    widget.input.additionalNote,
                                trailingIcon:
                                    const Icon(Icons.refresh_outlined),
                                onTap: _closeBottomSheet,
                              ),
                              SubmitButton(
                                action: () {
                                  if (BlocProvider.of<CTransactionCubit>(
                                          context)
                                      .isFormValid(widget.input)) {
                                    Map<String, dynamic> payload = {
                                      'type': type,
                                      'dateTime': localDateTime.toUtc(),
                                      'account': account,
                                      'category': category,
                                      'currency': currency,
                                      'amount': amount,
                                      'note': note,
                                      'additionalNote': additionalNote
                                    };
                                    BlocProvider.of<CTransactionCubit>(context)
                                        .handleFormSubmit(
                                            widget.input, payload);

                                    //Close the bottom sheet if open
                                    _closeBottomSheet();

                                    //Close the snackbar because we are navigating back
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    //Go to previous page
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ])
                          ],
                        )),
                      ),
                    ],
                  );
                })),
          ),
        ),
      ),
      onWillPop: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return Future.value(true);
      },
    );
  }
}
