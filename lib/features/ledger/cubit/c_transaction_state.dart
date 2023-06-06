part of 'c_transaction_cubit.dart';

class CTransactionState {
  const CTransactionState({
    required this.committedEntries,
  });

  final List<TransactionData> committedEntries;
}
