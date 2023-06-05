import 'package:budget_buddy/features/constants/enum.dart';
import 'package:uuid/uuid.dart';

class TransactionData {
  TransactionData({
    this.account = '',
    this.category = '',
    this.currency = 'USD', //TODO paramterize it in the settings
    this.amount = 0.0,
    this.note = '',
    this.additionalNote = '',
  });

  //Constructor for cloning
  TransactionData cloneFrom({required TransactionData oldLedger}) {
    return TransactionData(
      account: oldLedger.account,
      category: oldLedger.category,
      currency: oldLedger.currency,
      amount: oldLedger.amount,
      note: oldLedger.note,
      additionalNote: oldLedger.additionalNote
    );
  }

  void setDateTime(DateTime dateTime) {
    utcDateTime = dateTime;
  }

  //Data
  final String id = const Uuid().v4();
  TransactionType type = TransactionType.expense;
  DateTime utcDateTime = DateTime.now().toUtc();
  String account;
  String category;
  String currency; 
  double amount;
  String note;
  String additionalNote;

  //Metadata TODO delete these two properties because uncommitted transaction wont need
  DateTime? createdUtcDateTime;
  DateTime? modifiedUtcDateTime;

  @override
  String toString() {
    return '\nLedgerInput{\nid = $id,\ntype = $type,\ndateTime = $utcDateTime,\naccount = $account,\ncategory = $category,\ncurrency=$currency,\namount=$amount,\nnote=$note,\nadditionalNote=$additionalNote}';
  }
}
