import 'package:budget_buddy/features/constants/enum.dart';
import 'package:uuid/uuid.dart';

class TransactionData {
  TransactionData({
    this.type = TransactionType.expense,
    this.account = '',
    this.category = '',
    this.currency = 'USD', //TODO paramterize it in the settings
    this.amount = 0.0,
    this.note = '',
    this.additionalNote = '',
  });

  //Constructor for cloning (only used with editing)
  TransactionData cloneFrom({required TransactionData previousData}) {
    return TransactionData(
      type: previousData.type,
      account: previousData.account,
      category: previousData.category,
      currency: previousData.currency,
      amount: previousData.amount,
      note: previousData.note,
      additionalNote: previousData.additionalNote,
    );
  }

  //For setting date when editing existing data
  void setDateTime(DateTime utcDateTime) {
    this.utcDateTime = utcDateTime;
  }

  //Data
  String id = const Uuid().v4();
  TransactionType type = TransactionType.expense;
  DateTime utcDateTime = DateTime.now().toUtc();
  String account;
  String category;
  String currency;
  double amount;
  String note;
  String additionalNote;

  //Null until added as committed transactions
  DateTime? createdUtcDateTime;
  DateTime? modifiedUtcDateTime;

  @override
  String toString() {
    return '\nTransactionData{\nid = $id,\ntype = $type,\nutcDateTime = $utcDateTime,\naccount = $account,\ncategory = $category,\ncurrency=$currency,\namount=$amount,\nnote=$note,\nadditionalNote=$additionalNote}';
  }
}
