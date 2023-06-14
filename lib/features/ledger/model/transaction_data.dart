import 'package:budget_buddy/features/constants/enum.dart';
import 'package:uuid/uuid.dart';

class TransactionData {
  TransactionData({
    this.type = TransactionType.expense,
    this.account = '',
    this.subAccount = '',
    this.incomeCategory = '',
    this.incomeSubCategory = '',
    this.expenseCategory = '',
    this.expenseSubCategory = '',
    this.transferCategory = '',
    this.transferSubCategory = '',
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
      subAccount: previousData.subAccount,
      incomeCategory: previousData.incomeCategory,
      incomeSubCategory: previousData.incomeSubCategory,
      expenseCategory: previousData.expenseCategory,
      expenseSubCategory: previousData.expenseSubCategory,
      transferCategory: previousData.transferCategory,
      transferSubCategory: previousData.transferSubCategory,
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
  String subAccount;
  String incomeCategory;
  String? incomeSubCategory;
  String expenseCategory;
  String? expenseSubCategory;
  String transferCategory;
  String? transferSubCategory;
  String currency;
  double amount;
  String note;
  String additionalNote;

  //Null until added as committed transactions
  DateTime? createdUtcDateTime;
  DateTime? modifiedUtcDateTime;

  @override
  String toString() {
    return '\nTransactionData{\n'
        'id = $id,\n'
        'type = $type,\n'
        'utcDateTime = $utcDateTime,\n'
        'account = $account,\n'
        'incomeCategory = $incomeCategory,\n'
        'expenseCategory = $expenseCategory,\n'
        'transferCategory=$transferCategory,\n'
        'currency=$currency,\n'
        'amount=$amount,\n'
        'note=$note,\n'
        'additionalNote=$additionalNote\n'
        '}\n';
  }
}
