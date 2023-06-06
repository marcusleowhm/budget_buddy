import 'package:bloc/bloc.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/material.dart';
import '../model/ledger_input.dart';
import '../widgets/widget_shaker.dart';

part 'c_transaction_state.dart';

class CTransactionCubit extends Cubit<CTransactionState> {
  CTransactionCubit() : super(const CTransactionState(committedEntries: []));

  //Add into committed transaction from uncommitted ones
  void addTransactions(List<TransactionData> incomingTransactions) {
    List<TransactionData> transactions = List.from(state.committedEntries);

    //Give each uncommitted transaction a datetime before adding to list
    DateTime utcNow = DateTime.now().toUtc();
    for (TransactionData data in incomingTransactions) {
      data.createdUtcDateTime = utcNow;
    }
    transactions.addAll(incomingTransactions);
    emit(
      CTransactionState(committedEntries: transactions),
    );
  }

  LedgerInput createFormControl(TransactionData data) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    //Controller for the edit page form only
    TextEditingController dateTimeController = TextEditingController();
    TextEditingController accountController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    TextEditingController additionalNoteController = TextEditingController();

    //Add GlobalKey for each LedgerInput's input widget
    GlobalKey<FormFieldState> dateTimeKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> accountKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> categoryKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> amountKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> noteKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> additionalNoteKey = GlobalKey<FormFieldState>();

    GlobalKey<ShakeErrorState> formShakerKey = GlobalKey<ShakeErrorState>();
    GlobalKey<ShakeErrorState> accountShakerKey = GlobalKey<ShakeErrorState>();
    GlobalKey<ShakeErrorState> categoryShakerKey = GlobalKey<ShakeErrorState>();

    //Add focus nodes
    FocusNode dateTimeFocus = FocusNode();
    FocusNode accountFocus = FocusNode();
    FocusNode categoryFocus = FocusNode();
    FocusNode amountFocus = FocusNode();
    FocusNode noteFocus = FocusNode();
    FocusNode additionalNoteFocus = FocusNode();

    //Set listener for controllers
    noteController.addListener(() => data.note = noteController.text);
    additionalNoteController.addListener(() => data.additionalNote = additionalNoteController.text);

    //Set initial value for date
    dateTimeController.text =
        dateLongFormatter.format(data.utcDateTime.toLocal());

    //Add listeners for when losing focus
    accountFocus.addListener(() {
      if (!accountFocus.hasFocus) {
        accountKey.currentState?.validate();
      }
    });
    categoryFocus.addListener(() {
      if (!categoryFocus.hasFocus) {
        categoryKey.currentState?.validate();
      }
    });
    amountFocus.addListener(() {
      if (!amountFocus.hasFocus) {
        double enteredAmount = double.tryParse(amountController.text
                .replaceAll('\$', '')
                .replaceAll(',', '')) ??
            0.0;
        amountController.text =
            englishDisplayCurrencyFormatter.format(enteredAmount);
      }
    });

    return LedgerInput(
      data: data,
      formKey: formKey,
      dateTimeController: dateTimeController,
      accountController: accountController,
      categoryController: categoryController,
      amountController: amountController,
      noteController: noteController,
      additionalNoteController: additionalNoteController,
      dateTimeKey: dateTimeKey,
      accountKey: accountKey,
      categoryKey: categoryKey,
      amountKey: amountKey,
      noteKey: noteKey,
      additionalNoteKey: additionalNoteKey,
      formShakerKey: formShakerKey,
      accountShakerKey: accountShakerKey,
      categoryShakerKey: categoryShakerKey,
      dateTimeFocus: dateTimeFocus,
      accountFocus: accountFocus,
      categoryFocus: categoryFocus,
      amountFocus: amountFocus,
      noteFocus: noteFocus,
      additionalNoteFocus: additionalNoteFocus,
    );
  }

  void getTransactions() {
    //TODO implement API and local storage
  }

  bool _validateFormAndShake(LedgerInput input) {
    List<ShakeErrorState?> fieldStatesToShake = [];
    if (!input.accountKey.currentState!.validate()) {
      fieldStatesToShake.add(input.accountShakerKey.currentState);
    }
    if (!input.categoryKey.currentState!.validate()) {
      fieldStatesToShake.add(input.categoryShakerKey.currentState);
    }
    //if no error detected
    if (fieldStatesToShake.isEmpty) {
      return true;
    }

    for (var element in fieldStatesToShake) {
      element?.shake();
    }
    return false;
  }

  bool isFormValid(LedgerInput input) {
    if (!_validateFormAndShake(input)) {
      return false;
    }
    return true;
  }

  //Updates all field of the data with submitted information, changing the modified datetime
  void handleFormSubmit(String id, TransactionData data) {
    state.committedEntries.firstWhere((entry) => entry.id == id)
      ..utcDateTime = data.utcDateTime
      ..account = data.account
      ..category = data.category
      ..currency = data.currency
      ..amount = data.amount
      ..note = data.note
      ..additionalNote = data.additionalNote
      ..modifiedUtcDateTime = DateTime.now().toUtc();

    emit(CTransactionState(committedEntries: state.committedEntries));
  }
}
