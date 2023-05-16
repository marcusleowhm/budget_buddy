import 'package:flutter/material.dart';

class LedgerInput {
  LedgerInput({
    required this.id,
    this.dateTime = '',
    this.account = '',
    this.category = '',
    this.amount = 0.0,
    this.additionalNotes = '',
  });

  String id;
  String dateTime;
  String account;
  String category;
  double amount;
  String additionalNotes;

  @override
  String toString() {
    return 'LedgerInput{id=$id, dateTime=$dateTime, account=$account}';
  }
}
