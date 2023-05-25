part of 'u_transaction_cubit.dart';

class UTransactionState {

  const UTransactionState({required this.entries, required this.currenciesTotal});

  final List<LedgerInput> entries;
  //Data passed to the summary widget
  final Map<String, Map<String, double>> currenciesTotal;
  
}
