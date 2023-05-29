import 'package:bloc/bloc.dart';

import '../model/ledger_input.dart';

part 'c_transaction_state.dart';

class CTransactionCubit extends Cubit<CTransactionState> {
  CTransactionCubit() : super(const CTransactionState(committedEntries: []));

  void addTransactions(List<LedgerInput> uncommittedEntries) {
    emit(CTransactionState(committedEntries: state.committedEntries + uncommittedEntries));
  }

  void getTransactions() {
    //TODO implement API and local storage
  }
}
