import 'package:budget_buddy/features/ledger/model/transaction_data.dart';

class LedgerDisplay {
  Map<String, double> sum = {'income': 0.0, 'expense': 0.0, 'transfer': 0.0};
  List<TransactionData> inputs = [];
}