import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../components/inputs/type_picker.dart';
import '../model/ledger_input.dart';
import '../widgets/widget_shaker.dart';

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

  bool _validateFormAndShake(
    GlobalKey<FormFieldState> accountKey,
    GlobalKey<FormFieldState> categoryKey,
    GlobalKey<ShakeErrorState> accountShakerKey,
    GlobalKey<ShakeErrorState> categoryShakerKey,
  ) {
    List<ShakeErrorState?> fieldStatesToShake = [];
    if (!accountKey.currentState!.validate()) {
      fieldStatesToShake.add(accountShakerKey.currentState);
    }
    if (!categoryKey.currentState!.validate()) {
      fieldStatesToShake.add(categoryShakerKey.currentState);
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

  bool handleEditSubmit(
    GlobalKey<FormFieldState> accountKey,
    GlobalKey<FormFieldState> categoryKey,
    GlobalKey<ShakeErrorState> accountShakerKey,
    GlobalKey<ShakeErrorState> categoryShakerKey,
  ) {
    if (!_validateFormAndShake(
        accountKey, categoryKey, accountShakerKey, categoryShakerKey)) {
      return false;
    }

    return true;
  }
}
