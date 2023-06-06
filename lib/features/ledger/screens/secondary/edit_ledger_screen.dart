import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/components/form/account/account_field.dart';
import 'package:budget_buddy/features/ledger/components/form/account/account_picker.dart';
import 'package:budget_buddy/features/ledger/components/form/amount/amount_field.dart';
import 'package:budget_buddy/features/ledger/components/form/amount/amount_typer.dart';
import 'package:budget_buddy/features/ledger/components/form/buttons/submit_button.dart';
import 'package:budget_buddy/features/ledger/components/form/category/category_picker.dart';
import 'package:budget_buddy/features/ledger/components/form/datetime/date_field.dart';
import 'package:budget_buddy/features/ledger/components/form/form_fields/additional_note_field.dart';
import 'package:budget_buddy/features/ledger/components/form/form_fields/category_field.dart';
import 'package:budget_buddy/features/ledger/components/form/ledger_form.dart';
import 'package:budget_buddy/features/ledger/components/form/note/note_field.dart';
import 'package:budget_buddy/features/ledger/components/form/type/type_picker.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:budget_buddy/utilities/form_control_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditLedgerScreen extends StatefulWidget {
  const EditLedgerScreen({
    super.key,
    required this.data,
  });

  final TransactionData data;

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

  //Form control
  late LedgerInput formControl;

  //Create temporary state to change it all one shot when user submits
  late TransactionData newData;

  @override
  void initState() {
    newData = TransactionData().cloneFrom(previousData: widget.data);
    formControl = FormControlUtility.create(data: newData);
    formControl.noteController.addListener(() {
      setState(() => newData.note = formControl.noteController.text);
    });
    formControl.additionalNoteController.addListener(() {
      setState(() => newData.additionalNote = formControl.additionalNoteController.text);
    });

    super.initState();
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

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: widget.data.utcDateTime.toLocal(),
      firstDate: DateTime(1970),
      lastDate: localNow.add(
        const Duration(days: 365 * 10),
      ),
    );
    return selectedDate;
  }

  void _setDate(BuildContext context) {
    _selectDate(context).then((selectedDate) {
      if (selectedDate != null) {
        //Set value and close the dialog
        setState(
          () {
            newData.utcDateTime = selectedDate.toUtc();
            formControl.dateTimeController.text =
                dateLongFormatter.format(selectedDate.toLocal());
          },
        );
        //Move focus to account after selecting date
        _moveFocusTo(formControl.accountFocus);
        _selectAccount();
      }
    });
  }

  void _resetDate() {
    setState(() {
      newData.utcDateTime = widget.data.utcDateTime;
      formControl.dateTimeController.text =
          dateLongFormatter.format(newData.utcDateTime.toLocal());
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
                    newData.account = selectedAccount;
                    formControl.accountController.text = newData.account;
                  });
                  _moveFocusTo(formControl.categoryFocus);
                  _selectCategory();
                  _scrollToWidget(formControl.categoryKey, scrollAlignment);
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
      newData.account = widget.data.account;
      formControl.accountController.text = newData.account;
    });
  }

  void _selectCategory() {
    _bottomSheetController =
        _scaffoldKey.currentState?.showBottomSheet<void>((context) {
      return CategoryPicker(
        type: newData.type,
        onPressed: (selectedCategory) {
          if (selectedCategory != null) {
            //Set value and close the dialog
            setState(() {
              newData.category = selectedCategory;
              formControl.categoryController.text = newData.category;
            });
            //Move focus to amount input,
            //Then show the keypad
            _moveFocusTo(formControl.amountFocus);
            _selectAmount();
            _scrollToWidget(formControl.amountKey, scrollAlignment);
          } else {
            _closeBottomSheet();
          }
        },
      );
    });
  }

  void _resetCategory() {
    setState(() {
      newData.category = widget.data.category;
      formControl.categoryController.text = newData.category;
    });
  }

  void _setCurrency(String? selection) {
    if (selection != null) {
      setState(() => newData.currency = selection);
    }
  }

  void _resetAmount() {
    setState(() {
      newData.amount = widget.data.amount;
      formControl.amountController.text =
          englishDisplayCurrencyFormatter.format(newData.amount);
    });
  }

  void _selectAmount() {
    _bottomSheetController =
        _scaffoldKey.currentState?.showBottomSheet<void>((context) {
      return AmountTyper(
        currentAmount: newData.amount,
        controller: formControl.amountController,
        onCancelPressed: _closeBottomSheet,
        onKeystroke: (double newValue) {
          setState(() => newData.amount = newValue);
        },
        onDonePressed: (double newValue) {
          setState(() => newData.amount = newValue);

          _moveFocusTo(formControl.noteFocus);
          _scrollToWidget(formControl.noteKey, 1.0);
        },
        closeBottomSheet: _closeBottomSheet,
      );
    });
  }

  void _resetNote() {
    setState(() {
      newData.note = widget.data.note;
      formControl.noteController.text = newData.note;
      formControl.noteController.selection = TextSelection.collapsed(
        offset: formControl.noteController.text.length,
      );
    });
  }

  void _resetAdditionalNote() {
    setState(() {
      newData.additionalNote = widget.data.additionalNote;
      formControl.additionalNoteController.text = newData.additionalNote;
      formControl.additionalNoteController.selection = TextSelection.collapsed(
        offset: formControl.additionalNoteController.text.length,
      );
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
                            LedgerForm(
                                inputType: InputType.edit,
                                input: formControl,
                                children: [
                                  TypePicker(
                                    type: newData.type,
                                    setType: (TransactionType newSelection) {
                                      if (_bottomSheetController != null) {
                                        _bottomSheetController?.setState!(
                                          () {
                                            setState(() =>
                                                newData.type = newSelection);
                                          },
                                        );
                                      } else {
                                        setState(
                                            () => newData.type = newSelection);
                                      }
                                    },
                                  ),
                                  DateField(
                                    input: formControl,
                                    controller: formControl.dateTimeController,
                                    now: newData.utcDateTime.toLocal(),
                                    onTapTrailing: _resetDate,
                                    onTap: () {
                                      _setDate(context);
                                    },
                                  ),
                                  AccountField(
                                    input: formControl,
                                    controller: formControl.accountController,
                                    onTapTrailing: _resetAccount,
                                    showIcon:
                                        newData.account != widget.data.account,
                                    trailingIcon: const Icon(Icons.refresh),
                                    onTap: _selectAccount,
                                  ),
                                  CategoryField(
                                    input: formControl,
                                    type: newData.type,
                                    controller: formControl.categoryController,
                                    onTapTrailing: _resetCategory,
                                    showIcon: newData.category !=
                                        widget.data.category,
                                    trailingIcon: const Icon(Icons.refresh),
                                    onTap: _selectCategory,
                                  ),
                                  AmountField(
                                    input: formControl,
                                    controller: formControl.amountController,
                                    onCurrencyChange: (String? newCurrency) {
                                      _setCurrency(newCurrency);
                                    },
                                    onTapTrailing: _resetAmount,
                                    showIcon:
                                        newData.amount != widget.data.amount,
                                    trailingIcon: const Icon(Icons.refresh),
                                    onTap: () {
                                      _selectAmount();
                                    },
                                  ),
                                  NoteField(
                                    input: formControl,
                                    controller: formControl.noteController,
                                    onTapTrailing: _resetNote,
                                    showIcon: newData.note != widget.data.note,
                                    trailingIcon: const Icon(Icons.refresh),
                                    onTap: _closeBottomSheet,
                                    onEditingComplete: () {
                                      _moveFocusTo(
                                          formControl.additionalNoteFocus);
                                      _scrollToWidget(
                                          formControl.additionalNoteKey, 1.0);
                                    },
                                  ),
                                  const Divider(),
                                  AdditionalNoteField(
                                    input: formControl,
                                    controller:
                                        formControl.additionalNoteController,
                                    onTapTrailing: _resetAdditionalNote,
                                    showIcon: newData.additionalNote !=
                                        widget.data.additionalNote,
                                    trailingIcon:
                                        const Icon(Icons.refresh_outlined),
                                    onTap: _closeBottomSheet,
                                  ),
                                  SubmitButton(
                                    action: () {
                                      if (BlocProvider.of<CTransactionCubit>(
                                              context)
                                          .isFormValid(formControl)) {
                                        BlocProvider.of<CTransactionCubit>(
                                                context)
                                            .handleFormSubmit(
                                                widget.data.id, newData);

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
