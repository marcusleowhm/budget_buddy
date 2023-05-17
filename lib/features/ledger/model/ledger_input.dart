import 'package:budget_buddy/features/ledger/components/type_picker.dart';

class LedgerInput {
  LedgerInput({
    required this.id,
    this.type = TransactionType.expense,
    this.account = '',
    this.category = '',
    this.amount = 0.0,
    this.additionalNotes = '',
  });
  
  String id;
  TransactionType type;
  DateTime dateTime = DateTime.now();
  String account;
  String category;
  double amount;
  String additionalNotes;

  @override
  String toString() {
    return 'LedgerInput{id=$id, dateTime=$dateTime, account=$account}';
  }
}
