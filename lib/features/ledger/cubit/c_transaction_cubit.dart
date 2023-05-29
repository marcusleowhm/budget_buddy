import 'package:bloc/bloc.dart';

import '../components/inputs/type_picker.dart';
import '../model/ledger_input.dart';

part 'c_transaction_state.dart';

class CTransactionCubit extends Cubit<CTransactionState> {
  CTransactionCubit() : super(const CTransactionState(committedEntries: {}));

  //Add into committed transaction from uncommitted ones
  void addTransactions(List<LedgerInput> uncommittedEntries) {
    Map<String, LedgerInput> newEntries = {};
    for (LedgerInput ledger in uncommittedEntries) {
      newEntries.addEntries({ledger.id: ledger}.entries);
    }
    newEntries.addAll(state.committedEntries);
    emit(
      CTransactionState(
        committedEntries: newEntries,
      ),
    );
  }

  void getTransactions() {
    //TODO implement API and local storage
  }

  void changeTypeWhereIdEquals(String id, TransactionType newSelection) {
    state.committedEntries[id]?.type = newSelection;
    emit(
      CTransactionState(
        committedEntries: state.committedEntries,
      ),
    );
  }
}
