import 'package:bloc/bloc.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';

import '../model/ledger_input.dart';
import '../widgets/widget_shaker.dart';

part 'c_transaction_state.dart';

class CTransactionCubit extends Cubit<CTransactionState> {
  CTransactionCubit() : super(const CTransactionState(committedEntries: []));

  /// WARNING: Use for development only
  void addDummyData() {

    List<TransactionData> mockData = <TransactionData>[
      
    ];

    emit(CTransactionState(committedEntries: mockData));

  }

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
      ..type = data.type
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
