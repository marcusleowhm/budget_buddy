import 'package:budget_buddy/features/ledger/components/type_picker.dart';

class LedgerInput {
  LedgerInput({
    required this.id,
    this.type = TransactionType.expense,
    this.account = '',
    this.categoryOrTo = '',
    this.amount = 0.0,
    this.note = '',
    this.additionalNotes = '',
    this.isExpanded = true
  });
  
  String id;
  TransactionType type;
  DateTime dateTime = DateTime.now();
  String account;
  String categoryOrTo;
  double amount;
  String note;
  String additionalNotes;
  bool isExpanded;

  @override
  String toString() {
    return 'LedgerInput{id=$id, dateTime=$dateTime, account=$account}';
  }
}
