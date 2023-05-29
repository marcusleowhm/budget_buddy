import 'package:budget_buddy/features/ledger/components/inputs/type_picker.dart';
import 'package:budget_buddy/features/ledger/widgets/widget_shaker.dart';
import 'package:flutter/material.dart';

class LedgerInput {
  LedgerInput(
      {required this.id,
      this.type = TransactionType.expense,
      this.accountOrAccountFrom = '',
      this.categoryOrAccountTo = '',
      this.currency = 'USD',
      this.amount = 0.0,
      this.note = '',
      this.additionalNote = '',
      this.isExpanded = true,
      required this.formKey,
      required this.dateTimeController,
      required this.accountOrAccountFromController,
      required this.categoryOrAccountToController,
      required this.amountController,
      required this.noteController,
      required this.additionalNoteController,
      required this.dateTimeKey,
      required this.accountOrAccountFromKey,
      required this.categoryOrAccountToKey,
      required this.amountKey,
      required this.noteKey,
      required this.dividerKey,
      required this.additionalNoteKey,
      required this.formShakerKey,
      required this.accountOrAccountFromShakerKey,
      required this.categoryOrAccountToShakerKey,
      required this.dateTimeFocus,
      required this.accountOrAccountFromFocus,
      required this.categoryOrAccountToFocus,
      required this.amountFocus,
      required this.noteFocus,
      required this.additionalNoteFocus});

  //Data
  String id;
  TransactionType type;
  DateTime utcDateTime = DateTime.now().toUtc();
  String accountOrAccountFrom;
  String categoryOrAccountTo;
  String currency;
  double amount;
  String note;
  String additionalNote;

  //Boolean to help with displaying data depending on state of the ExpansionTile
  bool isExpanded;

  //Form key to help with tracking the form within the ledger entity
  GlobalKey<FormState> formKey;

  //Not instantiated in this class
  //Will be instantiated in the add_ledeger_screen
  final TextEditingController dateTimeController;
  final TextEditingController accountOrAccountFromController;
  final TextEditingController categoryOrAccountToController;
  final TextEditingController amountController;
  final TextEditingController noteController;
  final TextEditingController additionalNoteController;

  //Not instantiated here
  //GlobalKey for moving the focus
  final GlobalKey<FormFieldState> dateTimeKey;
  final GlobalKey<FormFieldState> accountOrAccountFromKey;
  final GlobalKey<FormFieldState> categoryOrAccountToKey;
  final GlobalKey<FormFieldState> amountKey;
  final GlobalKey<FormFieldState> noteKey;
  final GlobalKey dividerKey;
  final GlobalKey<FormFieldState> additionalNoteKey;

  //GlobalKey for shaker animation
  final GlobalKey<ShakeErrorState> formShakerKey;
  final GlobalKey<ShakeErrorState> accountOrAccountFromShakerKey;
  final GlobalKey<ShakeErrorState> categoryOrAccountToShakerKey;

  //Not instantited here
  //Focus variable to help with moving the focus
  final FocusNode dateTimeFocus;
  final FocusNode accountOrAccountFromFocus;
  final FocusNode categoryOrAccountToFocus;
  final FocusNode amountFocus;
  final FocusNode noteFocus;
  final FocusNode additionalNoteFocus;

  @override
  String toString() {
    return '\nLedgerInput{\nid = $id,\ntype = $type,\ndateTime = $utcDateTime,\naccount = $accountOrAccountFrom,\ncategory = $categoryOrAccountTo,\ncurrency=$currency,\namount=$amount,\nnote=$note,\nadditionalNote=$additionalNote}';
  }
}
