import 'package:bloc/bloc.dart';
import 'package:budget_buddy/features/ledger/widgets/widget_shaker.dart';
import 'package:budget_buddy/utilities/date_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../utilities/currency_formatter.dart';
import '../components/inputs/type_picker.dart';
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

    GlobalKey<ShakeErrorState> formShakerKey = GlobalKey<ShakeErrorState>();
    GlobalKey<ShakeErrorState> accountOrAccountFromShakerKey =
        GlobalKey<ShakeErrorState>();
    GlobalKey<ShakeErrorState> categoryOrAccountToShakerKey =
        GlobalKey<ShakeErrorState>();

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
      accountController: accountOrAccountFromController,
      categoryController: categoryOrAccountToController,
      amountController: amountController,
      noteController: noteController,
      additionalNoteController: additionalNoteController,
      dateTimeKey: dateTimeKey,
      accountKey: accountOrAccountFromKey,
      categoryKey: categoryOrAccountToKey,
      amountKey: amountKey,
      noteKey: noteKey,
      dividerKey: dividerKey,
      additionalNoteKey: additionalNoteKey,
      formShakerKey: formShakerKey,
      accountShakerKey: accountOrAccountFromShakerKey,
      categoryShakerKey: categoryOrAccountToShakerKey,
      dateTimeFocus: dateTimeFocus,
      accountFocus: accountOrAccountFromFocus,
      categoryFocus: categoryOrAccountToFocus,
      amountFocus: amountFocus,
      noteFocus: noteFocus,
      additionalNoteFocus: additionalNoteFocus,
    );

    //Set initial value for date
    dateTimeController.text =
        dateLongFormatter.format(newLedger.utcDateTime.toLocal());

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
        double enteredAmount = double.tryParse(newLedger.amountController.text
                .replaceAll('\$', '')
                .replaceAll(',', '')) ??
            0.0;
        newLedger.amountController.text =
            englishDisplayCurrencyFormatter.format(enteredAmount);
      }
    });

    emit(UTransactionState(
      entries: [...state.entries, newLedger],
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void removeRowAt(int index) {
    state.entries.removeAt(index);
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void insertEntryAt(int index, LedgerInput input) {
    state.entries.insert(index, input);
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setIsExpanded(int index, bool isExpanded) {
    state.entries.elementAt(index).isExpanded = isExpanded;
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setTypeAt(int index, TransactionType type) {
    state.entries.elementAt(index).type = type;
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setDateAt(int index, DateTime selectedDate) {
    //Set state of the LedgerInput to the user selected date
    //Note: Whenever setting the date time state, use UTC
    state.entries.elementAt(index).utcDateTime = selectedDate.toUtc();
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setAccountAt(int index, String accountOrAccountFrom) {
    LedgerInput input = state.entries.elementAt(index);
    input.account = accountOrAccountFrom;
    input.accountController.text = accountOrAccountFrom;
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setCategoryAt(int index, String categoryOrAccountTo) {
    LedgerInput input = state.entries.elementAt(index);
    input.category = categoryOrAccountTo;
    input.categoryController.text = categoryOrAccountTo;
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setCurrencyAt(int index, String? selectedCurrency) {
    if (selectedCurrency != null) {
      LedgerInput input = state.entries.elementAt(index);
      input.currency = selectedCurrency;
    }
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setAmountAt(int index, String amountString) {
    double number = double.tryParse(
            amountString.replaceAll(',', '').replaceAll('\$', '')) ??
        0.0;
    state.entries.elementAt(index).amount = number;
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setNoteAt(int index, String note) {
    state.entries.elementAt(index).note = note;
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setAdditionalNoteAt(int index, String additionalNote) {
    state.entries.elementAt(index).additionalNote = additionalNote;
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
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
      entries: state.entries,
      currenciesTotal: calculatedTotal,
    ));
  }

  void resetDateAtToToday(
    int index,
    DateTime localNow,
  ) {
    state.entries.elementAt(index).utcDateTime = localNow.toUtc();
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void clearAccountAt(int index) {
    LedgerInput input = state.entries.elementAt(index);
    input.accountController.clear();
    input.account = input.accountController.text;

    //Trigger the validation error
    input.accountKey.currentState?.validate();

    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void clearCategoryAt(int index) {
    LedgerInput input = state.entries.elementAt(index);
    input.categoryController.clear();
    input.category = input.categoryController.text;

    //Trigger validation
    input.categoryKey.currentState?.validate();

    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void clearAmountAt(int index) {
    state.entries.elementAt(index).amount = 0.0;
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void clearNoteAt(int index) {
    state.entries.elementAt(index).noteController.clear();
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void clearAdditionalNoteAt(int index) {
    state.entries.elementAt(index).additionalNoteController.clear();
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  bool validateForm() {
    List<TextEditingController> invalidInputs = [];
    for (LedgerInput input in state.entries) {
      if (input.accountKey.currentState != null) {
        if (!input.accountKey.currentState!.validate()) {
          invalidInputs.add(input.accountController);
        }
      }

      if (input.categoryKey.currentState != null) {
        if (!input.categoryKey.currentState!.validate()) {
          invalidInputs.add(input.categoryController);
        }
      }
    }

    if (invalidInputs.isEmpty) {
      return true;
    }

    return false;
  }

  bool _validateFormAndShake() {
    List<ShakeErrorState?> fieldStatesToShake = [];
    for (LedgerInput input in state.entries) {
      if (input.isExpanded) {
        if (!input.accountKey.currentState!.validate()) {
          fieldStatesToShake.add(input.accountShakerKey.currentState);
        }
        if (!input.categoryKey.currentState!.validate()) {
          fieldStatesToShake.add(input.categoryShakerKey.currentState);
        }
      } else {
        //If expanded and the whole form has error, collect the whole form state
        if (!input.formKey.currentState!.validate()) {
          fieldStatesToShake.add(input.formShakerKey.currentState);
        }
      }
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

  bool hasSubmitted() {
    //Validate form first and shake if needed
    if (!_validateFormAndShake()) {
      return false;
    }

    //Submit the form to API and state
    return true;
  }
}
