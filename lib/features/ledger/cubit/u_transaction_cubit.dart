import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../../../utilities/currency_formatter.dart';
import '../../../utilities/date_formatter.dart';
import '../components/type_picker.dart';
import '../model/ledger_input.dart';

part 'u_transaction_state.dart';

class UTransactionCubit extends Cubit<UTransactionState> {
  UTransactionCubit()
      : super(const UTransactionState(entries: [], currenciesTotal: {}));

  void addInputRow() {
    //Init controllers first
    TextEditingController dateTimeController = TextEditingController();
    TextEditingController accountOrAccountFromController =
        TextEditingController();
    TextEditingController categoryOrAccountToController =
        TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    TextEditingController additionalNoteController = TextEditingController();

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    //Add GlobalKey for each LedgerInput's input widget
    GlobalKey<FormFieldState> dateTimeKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> accountOrAccountFromKey =
        GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> categoryOrAccountToKey =
        GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> amountKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> noteKey = GlobalKey<FormFieldState>();
    GlobalKey dividerKey = GlobalKey();
    GlobalKey<FormFieldState> additionalNoteKey = GlobalKey<FormFieldState>();

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
      formKey: formKey,
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
      additionalNoteFocus: additionalNoteFocus,
    );

    //Init the date time to be displayed at the start
    newLedger.dateTimeController.text =
        dateLongFormatter.format(newLedger.dateTime);

    //Add listeners to controllers
    amountController
        .addListener(() => setAmountOf(newLedger, amountController.text));
    noteController.addListener(() => setNoteOf(newLedger, noteController.text));
    additionalNoteController.addListener(
        () => setAdditionalNoteOf(newLedger, additionalNoteController.text));
    //Add listeners for when losing focus
    accountOrAccountFromFocus.addListener(() {
      if (!accountOrAccountFromFocus.hasFocus) {
        accountOrAccountFromKey.currentState?.validate();
      }
    });
    categoryOrAccountToFocus.addListener(() {
      if (!categoryOrAccountToFocus.hasFocus) {
        categoryOrAccountToKey.currentState?.validate();
      }
    });
    amountFocus.addListener(() {
      if (!amountFocus.hasFocus) {
        amountController.text = englishDisplayCurrencyFormatter.format(newLedger.amount);
      }
    });

    emit(UTransactionState(
        entries: [...state.entries, newLedger],
        currenciesTotal: state.currenciesTotal));
  }

  void removeRowAt(int index) {
    state.entries.removeAt(index);
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  void insertEntryAt(int index, LedgerInput input) {
    state.entries.insert(index, input);
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  void setIsExpanded(int index, bool isExpanded) {
    state.entries.elementAt(index).isExpanded = isExpanded;
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  void setDateAt(int index, DateTime selectedDate) {
    //Set state of the LedgerInput to the user selected date
    //Note: Whenever setting the date time state, use UTC
    state.entries.elementAt(index).dateTime = selectedDate.toUtc();

    //Note: Whenever setting the date time to display, use Local
    //Convert to string just for the display in the TextField
    //Underlying data type in the LedgerInput class is still a DateTime
    state.entries.elementAt(index).dateTimeController.text =
        dateLongFormatter.format(selectedDate.toLocal());
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  void setTypeAt(int index, TransactionType type) {
    LedgerInput input = state.entries.elementAt(index);
    input.type = type;
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  void setAccountAt(int index, String accountOrAccountFrom) {
    LedgerInput input = state.entries.elementAt(index);
    input.accountOrAccountFrom = accountOrAccountFrom;
    input.accountOrAccountFromController.text = accountOrAccountFrom;
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  void setCategoryAt(int index, String categoryOrAccountTo) {
    LedgerInput input = state.entries.elementAt(index);
    input.categoryOrAccountTo = categoryOrAccountTo;
    input.categoryOrAccountToController.text = categoryOrAccountTo;
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  void setCurrencyAt(int index, String? selectedCurrency) {
    if (selectedCurrency != null) {
      LedgerInput input = state.entries.elementAt(index);
      input.currency = selectedCurrency;
    }
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  void setAmountOf(LedgerInput input, String amountString) {
    double number = double.tryParse(
            amountString.replaceAll(',', '').replaceAll('\$', '')) ??
        0.0;
    input.amount = number;
    tallyAllCurrencies();
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  void setNoteOf(LedgerInput input, String note) {
    input.note = note;
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  void setAdditionalNoteOf(LedgerInput input, String additionalNote) {
    input.additionalNote = additionalNote;
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  //To be called when
  //1. Editing the amount in each transaction,
  //2. Changing TransactionType,
  //3. Removing rows and
  //4. Undoing removal
  void tallyAllCurrencies() {
    const String incomeSum = 'incomeSum';
    const String expenseSum = 'expenseSum';
    const String transferSum = 'transferSum';

    //For each of the currencies present in the entries, init their sum value
    Set<String> currencies =
        state.entries.map((input) => input.currency).toSet();

    //Remove all currencies in the map first
    Map<String, Map<String, double>> calculatedTotal = {};
    for (String currency in currencies) {
      Map<String, double> totals = {
        incomeSum: 0.0,
        expenseSum: 0.0,
        transferSum: 0.0
      };
      //Reset all the currencies to be 0.0
      calculatedTotal[currency] = totals;
    }

    //Loop through and tally up
    for (LedgerInput input in state.entries) {
      switch (input.type) {
        case TransactionType.income:
          double income = calculatedTotal[input.currency]?[incomeSum] ?? 0.0;
          calculatedTotal[input.currency]?[incomeSum] = income + input.amount;
          break;
        case TransactionType.expense:
          double expense = calculatedTotal[input.currency]?[expenseSum] ?? 0.0;
          calculatedTotal[input.currency]?[expenseSum] = expense + input.amount;
          break;
        case TransactionType.transfer:
          double transfer =
              calculatedTotal[input.currency]?[transferSum] ?? 0.0;
          calculatedTotal[input.currency]?[transferSum] =
              transfer + input.amount;
          break;
      }
    }
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: calculatedTotal));
  }

  void resetDateAtToToday(int index, DateTime now) {
    LedgerInput input = state.entries.elementAt(index);
    input.dateTime = now;
    input.dateTimeController.text =
        dateLongFormatter.format(input.dateTime.toLocal());
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  void clearAccountAt(int index) {
    LedgerInput input = state.entries.elementAt(index);
    input.accountOrAccountFromController.clear();
    input.accountOrAccountFrom = input.accountOrAccountFromController.text;

    //Trigger the validation error
    input.accountOrAccountFromKey.currentState?.validate();

    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  void clearCategoryAt(int index) {
    LedgerInput input = state.entries.elementAt(index);
    input.categoryOrAccountToController.clear();
    input.categoryOrAccountTo = input.categoryOrAccountToController.text;

    //Trigger validation
    input.categoryOrAccountToKey.currentState?.validate();

    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  void clearAmountAt(int index) {
    state.entries.elementAt(index).amount = 0.0;
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  void clearNoteAt(int index) {
    state.entries.elementAt(index).noteController.clear();
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  void clearAdditionalNoteAt(int index) {
    state.entries.elementAt(index).additionalNoteController.clear();
    emit(UTransactionState(
        entries: state.entries, currenciesTotal: state.currenciesTotal));
  }

  bool _validateFormAt(int index) {
    if (!state.entries.elementAt(index).formKey.currentState!.validate()) {
      return false;
    }
    //if no error detected
    return true;
  }

  void handleSubmit() {
    //Validate and return if there is even 1 form that's invalid
    for (int i = 0; i < state.entries.length; i++) {
      if (!_validateFormAt(i)) {
        return;
      }
    }

    //Submit the form to API and state
    
  }
}