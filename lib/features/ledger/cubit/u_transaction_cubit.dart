import 'package:bloc/bloc.dart';
import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/widgets/widget_shaker.dart';
import 'package:budget_buddy/utilities/form_control_utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/ledger_input.dart';

part 'u_transaction_state.dart';

class UTransactionCubit extends Cubit<UTransactionState> {
  UTransactionCubit()
      : super(const UTransactionState(entries: [], currenciesTotal: {}));

  void addInputRow() {
    LedgerInput input = FormControlUtility.create();

    //Add listeners for note and additional note here
    input.noteController.addListener(() {
      setNoteOf(input, input.noteController.text);
    });
    input.additionalNoteController.addListener(() {
      setAdditionalNoteAt(input, input.additionalNoteController.text);
    });

    emit(UTransactionState(
      entries: [...state.entries, input],
      currenciesTotal: state.currenciesTotal,
    ));
  }

  /// addInputRow() needs to be called first to take advantage of the emit function of the cubit before we can access the new entry
  void cloneFromInputToNewEntry(LedgerInput previousInput) {
    //Newly added input
    LedgerInput newInput = state.entries.last;

    //Copy the data
    setTypeOf(newInput, previousInput.data.type);
    setDateOf(newInput, previousInput.data.utcDateTime);
    setAccountOf(
        newInput, previousInput.data.account, previousInput.data.subAccount);
    setIncomeCategoryOf(newInput, previousInput.data.incomeCategory,
        previousInput.data.incomeSubCategory);
    setExpenseCategoryOf(newInput, previousInput.data.expenseCategory,
        previousInput.data.expenseSubCategory);
    setTransferCategoryOf(newInput, previousInput.data.transferCategory,
        previousInput.data.transferSubCategory);
    setCurrencyOf(newInput, previousInput.data.currency);
    setAmountOf(newInput, previousInput.data.amount);
    setNoteOf(newInput, previousInput.data.note);
    setAdditionalNoteAt(newInput, previousInput.data.additionalNote);

    newInput.cloneControllerTextFrom(previousInput: previousInput);

    emit(UTransactionState(
      entries: [...state.entries],
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

  void setIsExpandedOf(LedgerInput input, bool isExpanded) {
    state.entries
        .firstWhere((entry) => entry.data.id == input.data.id)
        .isExpanded = isExpanded;
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setTypeOf(LedgerInput input, TransactionType type) {
    state.entries
        .firstWhere((entry) => entry.data.id == input.data.id)
        .data
        .type = type;
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setDateOf(LedgerInput input, DateTime selectedDate) {
    //Set state of the LedgerInput to the user selected date
    //Note: Whenever setting the date time state, use UTC
    state.entries
        .firstWhere((entry) => entry.data.id == input.data.id)
        .data
        .utcDateTime = selectedDate.toUtc();
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setAccountOf(LedgerInput input, String account, String? subAccount) {
    LedgerInput firstMatchedInput =
        state.entries.firstWhere((entry) => entry.data.id == input.data.id);
    firstMatchedInput.data.account = account;
    firstMatchedInput.data.subAccount = '$subAccount';
    firstMatchedInput.accountController.text = '$subAccount';
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setIncomeCategoryOf(
      LedgerInput input, String incomeCategory, String? subIncomeCategory) {
    LedgerInput firstMatchedInput =
        state.entries.firstWhere((entry) => entry.data.id == input.data.id);
    firstMatchedInput.data.incomeCategory = incomeCategory;
    firstMatchedInput.data.incomeSubCategory = subIncomeCategory;

    if (subIncomeCategory != null) {
      firstMatchedInput.incomeCategoryController.text =
          '$incomeCategory ($subIncomeCategory)';
    } else {
      firstMatchedInput.incomeCategoryController.text = incomeCategory;
    }

    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setExpenseCategoryOf(
      LedgerInput input, String expenseCategory, String? expenseSubCategory) {
    LedgerInput firstMatchedInput =
        state.entries.firstWhere((entry) => entry.data.id == input.data.id);
    firstMatchedInput.data.expenseCategory = expenseCategory;
    firstMatchedInput.data.expenseSubCategory = expenseSubCategory;
    if (expenseSubCategory != null) {
      firstMatchedInput.expenseCategoryController.text =
          '$expenseCategory ($expenseSubCategory)';
    } else {
      firstMatchedInput.expenseCategoryController.text = expenseCategory;
    }
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setTransferCategoryOf(
      LedgerInput input, String transferCategory, String? transferSubCategory) {
    LedgerInput firstMatchedInput =
        state.entries.firstWhere((entry) => entry.data.id == input.data.id);
    firstMatchedInput.data.transferCategory = transferCategory;
    firstMatchedInput.data.transferSubCategory = transferSubCategory;
    firstMatchedInput.transferCategoryController.text = transferSubCategory ?? '';
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setCurrencyOf(LedgerInput input, String? selectedCurrency) {
    if (selectedCurrency != null) {
      state.entries
          .firstWhere((entry) => entry.data.id == input.data.id)
          .data
          .currency = selectedCurrency;
    }
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setAmountOf(LedgerInput input, double amount) {
    state.entries
        .firstWhere((entry) => entry.data.id == input.data.id)
        .data
        .amount = amount;
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setNoteOf(LedgerInput input, String note) {
    state.entries
        .firstWhere((entry) => entry.data.id == input.data.id)
        .data
        .note = note;
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void setAdditionalNoteAt(LedgerInput input, String additionalNote) {
    state.entries
        .firstWhere((entry) => entry.data.id == input.data.id)
        .data
        .additionalNote = additionalNote;
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
        state.entries.map((input) => input.data.currency).toSet();

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
      switch (input.data.type) {
        case TransactionType.income:
          double income =
              calculatedTotal[input.data.currency]?[incomeSum] ?? 0.0;
          calculatedTotal[input.data.currency]?[incomeSum] =
              income + input.data.amount;
          break;
        case TransactionType.expense:
          double expense =
              calculatedTotal[input.data.currency]?[expenseSum] ?? 0.0;
          calculatedTotal[input.data.currency]?[expenseSum] =
              expense + input.data.amount;
          break;
        case TransactionType.transfer:
          double transfer =
              calculatedTotal[input.data.currency]?[transferSum] ?? 0.0;
          calculatedTotal[input.data.currency]?[transferSum] =
              transfer + input.data.amount;
          break;
      }
    }
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: calculatedTotal,
    ));
  }

  void resetDateOfToToday(
    LedgerInput input,
    DateTime localNow,
  ) {
    state.entries
        .firstWhere((entry) => entry.data.id == input.data.id)
        .data
        .utcDateTime = localNow.toUtc();
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void clearAccountOf(LedgerInput input) {
    LedgerInput firstMatchedInput =
        state.entries.firstWhere((entry) => entry.data.id == input.data.id);
    firstMatchedInput.accountController.clear();
    firstMatchedInput.data.account = input.accountController.text;
    firstMatchedInput.data.subAccount = input.accountController.text;

    //Trigger the validation error
    input.accountKey.currentState?.validate();

    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void clearIncomeCategoryOf(LedgerInput input) {
    LedgerInput firstMatchedInput =
        state.entries.firstWhere((entry) => entry.data.id == input.data.id);
    firstMatchedInput.incomeCategoryController.clear();
    firstMatchedInput.data.incomeCategory = input.incomeCategoryController.text;
    firstMatchedInput.data.incomeSubCategory = null;

    //Trigger validation
    input.incomeCategoryKey.currentState?.validate();

    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void clearExpenseCategoryOf(LedgerInput input) {
    LedgerInput firstMatchedInput =
        state.entries.firstWhere((entry) => entry.data.id == input.data.id);
    firstMatchedInput.expenseCategoryController.clear();
    firstMatchedInput.data.expenseCategory =
        input.expenseCategoryController.text;
    firstMatchedInput.data.expenseSubCategory = null;

    //Trigger validation
    input.expenseCategoryKey.currentState?.validate();

    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void clearTransferCategoryOf(LedgerInput input) {
    LedgerInput firstMatchedInput =
        state.entries.firstWhere((entry) => entry.data.id == input.data.id);
    firstMatchedInput.transferCategoryController.clear();
    firstMatchedInput.data.transferCategory =
        input.transferCategoryController.text;
    firstMatchedInput.data.transferSubCategory = null;

    //Trigger validation
    input.transferCategoryKey.currentState?.validate();

    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void clearAmountOf(LedgerInput input) {
    state.entries
        .firstWhere((entry) => entry.data.id == input.data.id)
        .data
        .amount = 0.0;
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void clearNoteOf(LedgerInput input) {
    state.entries
        .firstWhere((entry) => entry.data.id == input.data.id)
        .noteController
        .clear();
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  void clearAdditionalNoteAt(LedgerInput input) {
    state.entries
        .firstWhere((entry) => entry.data.id == input.data.id)
        .additionalNoteController
        .clear();
    emit(UTransactionState(
      entries: state.entries,
      currenciesTotal: state.currenciesTotal,
    ));
  }

  bool _validateFormAndShake() {
    List<ShakeErrorState?> fieldStatesToShake = [];
    for (LedgerInput input in state.entries) {
      if (input.isExpanded) {
        if (!input.accountKey.currentState!.validate()) {
          fieldStatesToShake.add(input.accountShakerKey.currentState);
        }
        switch (input.data.type) {
          case TransactionType.income:
            if (!input.incomeCategoryKey.currentState!.validate()) {
              fieldStatesToShake.add(input.categoryShakerKey.currentState);
            }
            break;
          case TransactionType.expense:
            if (!input.expenseCategoryKey.currentState!.validate()) {
              fieldStatesToShake.add(input.categoryShakerKey.currentState);
            }
            break;
          case TransactionType.transfer:
            if (!input.transferCategoryKey.currentState!.validate()) {
              fieldStatesToShake.add(input.categoryShakerKey.currentState);
            }
            break;
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
