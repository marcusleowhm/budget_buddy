import 'package:bloc/bloc.dart';
import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';

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
      //check the type and clear the other type of data first
      switch (data.type) {
        case TransactionType.income:
          data.expenseCategory = '';
          data.expenseSubCategory = null;
          data.transferCategory = '';
          data.transferSubCategory = null;
          break;
        case TransactionType.expense:
          data.incomeCategory = '';
          data.incomeSubCategory = null;
          data.transferCategory = '';
          data.transferSubCategory = null;
          break;
        case TransactionType.transfer:
          data.incomeCategory = '';
          data.incomeSubCategory = null;
          data.expenseCategory = '';
          data.expenseSubCategory = null;
          break;
      }
    }
    transactions.addAll(incomingTransactions);
    emit(
      CTransactionState(committedEntries: transactions),
    );
  }

  void deleteTransactionOf(TransactionData data) {
    state.committedEntries.removeWhere((entry) => entry.id == data.id);
    emit(
      CTransactionState(committedEntries: state.committedEntries),
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
    TransactionData foundData =
        state.committedEntries.firstWhere((entry) => entry.id == id);
    //Clear the other category according to the type
    switch (data.type) {
      case TransactionType.income:
        data.expenseCategory = '';
        data.expenseSubCategory = null;
        data.transferCategory = '';
        data.transferSubCategory = null;
        break;
      case TransactionType.expense:
        data.incomeCategory = '';
        data.incomeSubCategory = null;
        data.transferCategory = '';
        data.transferSubCategory = null;
        break;
      case TransactionType.transfer:
        data.incomeCategory = '';
        data.incomeSubCategory = null;
        data.expenseCategory = '';
        data.expenseSubCategory = null;
        break;
    }

    foundData
      ..type = data.type
      ..utcDateTime = data.utcDateTime
      ..account = data.account
      ..incomeCategory = data.incomeCategory
      ..incomeSubCategory = data.incomeSubCategory
      ..expenseCategory = data.expenseCategory
      ..expenseSubCategory = data.expenseSubCategory
      ..transferCategory = data.transferCategory
      ..transferSubCategory = data.transferSubCategory
      ..currency = data.currency
      ..amount = data.amount
      ..note = data.note
      ..additionalNote = data.additionalNote
      ..modifiedUtcDateTime = DateTime.now().toUtc();

    emit(CTransactionState(committedEntries: state.committedEntries));
  }
}
