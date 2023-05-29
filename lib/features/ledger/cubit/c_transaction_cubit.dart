import 'package:bloc/bloc.dart';

import '../components/inputs/type_picker.dart';
import '../model/ledger_input.dart';

part 'c_transaction_state.dart';

class CTransactionCubit extends Cubit<CTransactionState> {
  CTransactionCubit() : super(const CTransactionState(committedEntries: []));

  //Add into committed transaction from uncommitted ones
  void addTransactions(List<LedgerInput> uncommittedEntries) {
    emit(CTransactionState(committedEntries: state.committedEntries + uncommittedEntries));
  }

  void getTransactions() {
    //TODO implement API and local storage
  }

  void changeTypeWhereIdEquals(String id, TransactionType newSelection) {
    LedgerInput? ledger;
    for (int i = 0; i < state.committedEntries.length; i++) {
      if (state.committedEntries.elementAt(i).id == id) {
        ledger = state.committedEntries.elementAt(i);
      }
    }

    if (ledger != null) {
      ledger.type = newSelection;
    }

    emit(CTransactionState(committedEntries: state.committedEntries));
  }

}
