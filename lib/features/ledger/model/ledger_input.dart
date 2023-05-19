import 'package:budget_buddy/features/ledger/components/type_picker.dart';
import 'package:flutter/material.dart';

class LedgerInput {
  LedgerInput({
    required this.id,
    this.type = TransactionType.expense,
    this.accountOrAccountFrom = '',
    this.categoryOrAccountTo = '',
    this.amount = 0.0,
    this.note = '',
    this.additionalNote = '',
    this.isExpanded = true,
    required this.dateTimeController,
    required this.accountOrAccountFromController,
    required this.categoryOrAccountToController,
    required this.amountController,
    required this.noteController,
    required this.additionalNoteController,
  });
  
  String id;
  TransactionType type;
  DateTime dateTime = DateTime.now().toUtc();
  String accountOrAccountFrom;
  String categoryOrAccountTo;
  double amount;
  String note;
  String additionalNote;
  bool isExpanded;

  //Not instantiated in this class
  //Will be instantiated in the add_ledeger_screen
  final TextEditingController dateTimeController;
  final TextEditingController accountOrAccountFromController;
  final TextEditingController categoryOrAccountToController;
  final TextEditingController amountController;
  final TextEditingController noteController;
  final TextEditingController additionalNoteController;

  @override
  String toString() {
    return 'LedgerInput{id=$id, dateTime=$dateTime, account=$accountOrAccountFrom, note=$note, additionalNote=$additionalNote}';
  }
}
