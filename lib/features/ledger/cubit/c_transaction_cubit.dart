import 'package:bloc/bloc.dart';
import '../model/ledger_input.dart';
import '../widgets/widget_shaker.dart';

part 'c_transaction_state.dart';

class CTransactionCubit extends Cubit<CTransactionState> {
  CTransactionCubit() : super(const CTransactionState(committedEntries: []));

  //Add into committed transaction from uncommitted ones
  void addTransactions(List<LedgerInput> uncommittedEntries) {
    List<LedgerInput> transactions = List.from(state.committedEntries);

    //Give each uncommitted transaction a datetime before adding to list
    DateTime utcNow = DateTime.now().toUtc();
    for (LedgerInput item in uncommittedEntries) {
      item.createdUtcDateTime = utcNow;
    }
    transactions.addAll(uncommittedEntries);

    emit(
      CTransactionState(committedEntries: transactions),
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

  void handleFormSubmit(LedgerInput input, Map<String, dynamic> payload) {
    state.committedEntries.firstWhere((item) => item.id == input.id)
      ..type = payload['type']
      ..utcDateTime = payload['dateTime']
      ..account = payload['account']
      ..category = payload['category']
      ..currency = payload['currency']
      ..amount = payload['amount']
      ..note = payload['note']
      ..additionalNote = payload['additionalNote']
      ..modifiedUtcDateTime = DateTime.now().toUtc();
    emit(CTransactionState(committedEntries: state.committedEntries));
  }
}
