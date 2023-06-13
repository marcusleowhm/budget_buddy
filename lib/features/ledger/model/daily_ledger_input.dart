import 'package:budget_buddy/features/ledger/model/transaction_data.dart';

class DailyLedgerInput {
  Map<String, double> sum = {'income': 0.0, 'expense': 0.0, 'transfer': 0.0};
  List<TransactionData> inputs = [];
}