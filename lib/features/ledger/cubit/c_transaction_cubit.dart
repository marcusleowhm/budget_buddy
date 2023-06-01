import 'package:bloc/bloc.dart';

import '../components/inputs/type_picker.dart';
import '../model/ledger_input.dart';
import '../widgets/widget_shaker.dart';

part 'c_transaction_state.dart';

class CTransactionCubit extends Cubit<CTransactionState> {
  CTransactionCubit() : super(const CTransactionState(committedEntries: {}));

  //Add into committed transaction from uncommitted ones
  void addTransactions(List<LedgerInput> uncommittedEntries) {
    Map<String, LedgerInput> newEntries = {};

    //O(n) - n will not grow too big
    for (LedgerInput ledger in uncommittedEntries) {
      newEntries.addEntries({ledger.id: ledger}.entries);
    }
    newEntries.addAll(state.committedEntries);
    emit(
      CTransactionState(committedEntries: newEntries),
    );
  }

  void getTransactions() {
    //TODO implement API and local storage
  }

  void changeTypeWhereIdEquals(String id, TransactionType newSelection) {
    state.committedEntries[id]?.type = newSelection;
    emit(
      CTransactionState(committedEntries: state.committedEntries),
    );
  }

  void changeDateTimeWhereIdEquals(String id, DateTime newDateTime) {
    state.committedEntries[id]?.utcDateTime = newDateTime;
    emit(
      CTransactionState(committedEntries: state.committedEntries),
    );
  }

  void changeAccountFromWhereIdEquals(String id, String accountOrAccountFrom) {
    state.committedEntries[id]?.account = accountOrAccountFrom;
    emit(
      CTransactionState(committedEntries: state.committedEntries),
    );
  }

  void changeCategoryWhereIdEquals(String id, String categoryOrAccountTo) {
    state.committedEntries[id]?.category = categoryOrAccountTo;
    emit(
      CTransactionState(committedEntries: state.committedEntries),
    );
  }

  void changeCurrenyWhereIdEquals(String id, String currency) {
    state.committedEntries[id]?.currency = currency;
    emit(
      CTransactionState(committedEntries: state.committedEntries),
    );
  }

  void changeAmountWhereIdEquals(String id, double amount) {
    state.committedEntries[id]?.amount = amount;
    emit(
      CTransactionState(committedEntries: state.committedEntries),
    );
  }

  void changeNoteWhereIdEquals(String id, String note) {
    state.committedEntries[id]?.note = note;
    emit(
      CTransactionState(committedEntries: state.committedEntries),
    );
  }

  void changeAdditionalNoteWhereIdEquals(String id, String additionalNote) {
    state.committedEntries[id]?.additionalNote = additionalNote;
    emit(
      CTransactionState(committedEntries: state.committedEntries),
    );
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

  bool handleEditSubmit(LedgerInput input) {
    if (!_validateFormAndShake(input)) {
      return false;
    }

    return true;
  }
}
