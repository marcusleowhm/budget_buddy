import 'package:budget_buddy/features/constants/enum.dart';
import 'package:uuid/uuid.dart';

class TransactionData {
  TransactionData({
    this.type = TransactionType.expense,
    this.account = '',
    this.incomeCategory = '',
    this.expenseCategory = '',
    this.transferCategory = '',
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
      incomeCategory: previousData.incomeCategory,
      expenseCategory: previousData.expenseCategory,
      transferCategory: previousData.transferCategory,
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
  String incomeCategory;
  String expenseCategory;
  String transferCategory;
  String currency;
  double amount;
  String note;
  String additionalNote;

  //Null until added as committed transactions
  DateTime? createdUtcDateTime;
  DateTime? modifiedUtcDateTime;

  @override
  String toString() {
    return '\nTransactionData{\nid = $id,\ntype = $type,\nutcDateTime = $utcDateTime,\naccount = $account,\nincomeCategory=$incomeCategory,\nexpenseCategory = $expenseCategory,\ntransferCategory=$transferCategory,\ncurrency=$currency,\namount=$amount,\nnote=$note,\nadditionalNote=$additionalNote}';
  }
}
