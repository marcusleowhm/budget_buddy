import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/widgets/widget_shaker.dart';
import 'package:flutter/material.dart';

class LedgerInput {
  LedgerInput({
    required this.id,
    this.isExpanded = true,
    required this.formKey,
    required this.dateTimeController,
    required this.accountController,
    required this.categoryController,
    required this.amountController,
    required this.noteController,
    required this.additionalNoteController,
    required this.dateTimeKey,
    required this.accountKey,
    required this.categoryKey,
    required this.amountKey,
    required this.noteKey,
    required this.dividerKey,
    required this.additionalNoteKey,
    required this.formShakerKey,
    required this.accountShakerKey,
    required this.categoryShakerKey,
    required this.dateTimeFocus,
    required this.accountFocus,
    required this.categoryFocus,
    required this.amountFocus,
    required this.noteFocus,
    required this.additionalNoteFocus,
  });

  //Data
  String id;
  TransactionType type = TransactionType.expense;
  DateTime utcDateTime = DateTime.now().toUtc();
  String account = '';
  String category = '';
  String currency = 'USD'; //TODO change
  double amount = 0.0;
  String note = '';
  String additionalNote = '';

  //Metadata
  DateTime? createdUtcDateTime;
  DateTime? modifiedUtcDateTime;

  //Boolean to help with displaying data depending on state of the ExpansionTile
  bool isExpanded;

  //Form key to help with tracking the form within the ledger entity
  GlobalKey<FormState> formKey;

  //Not instantiated in this class
  //Will be instantiated in the add_ledger_screen
  final TextEditingController dateTimeController;
  final TextEditingController accountController;
  final TextEditingController categoryController;
  final TextEditingController amountController;
  final TextEditingController noteController;
  final TextEditingController additionalNoteController;

  //Not instantiated here
  //GlobalKey for moving the focus
  final GlobalKey<FormFieldState> dateTimeKey;
  final GlobalKey<FormFieldState> accountKey;
  final GlobalKey<FormFieldState> categoryKey;
  final GlobalKey<FormFieldState> amountKey;
  final GlobalKey<FormFieldState> noteKey;
  final GlobalKey dividerKey;
  final GlobalKey<FormFieldState> additionalNoteKey;

  //GlobalKey for shaker animation
  final GlobalKey<ShakeErrorState> formShakerKey;
  final GlobalKey<ShakeErrorState> accountShakerKey;
  final GlobalKey<ShakeErrorState> categoryShakerKey;

  //Not instantited here
  //Focus variable to help with moving the focus
  final FocusNode dateTimeFocus;
  final FocusNode accountFocus;
  final FocusNode categoryFocus;
  final FocusNode amountFocus;
  final FocusNode noteFocus;
  final FocusNode additionalNoteFocus;

  @override
  String toString() {
    return '\nLedgerInput{\nid = $id,\ntype = $type,\ndateTime = $utcDateTime,\naccount = $account,\ncategory = $category,\ncurrency=$currency,\namount=$amount,\nnote=$note,\nadditionalNote=$additionalNote}';
  }
}
