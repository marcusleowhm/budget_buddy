import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/features/ledger/widgets/widget_shaker.dart';
import 'package:flutter/material.dart';

class LedgerInput {
  LedgerInput({
    this.isExpanded = true,
    required this.data,
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
  final TransactionData data;

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

  void moveFocusToNext(
    void Function(LedgerInput) selectAccount,
    void Function(LedgerInput) selectCategory,
    void Function(LedgerInput) selectAmount,
  ) {
    Map<TextEditingController, FocusNode> controllerFocusMap = {
      dateTimeController: dateTimeFocus,
      accountController: accountFocus,
      categoryController: categoryFocus,
      amountController: amountFocus,
      noteController: noteFocus,
      additionalNoteController: additionalNoteFocus
    };

    for (MapEntry entry in controllerFocusMap.entries) {
      TextEditingController controller = entry.key;
      FocusNode focus = entry.value;
      if (controller.text.isEmpty) {
        focus.requestFocus();

        if (focus == accountFocus) {
          selectAccount(this);
        }

        if (focus == categoryFocus) {
          selectCategory(this);
        }

        if (focus == amountFocus) {
          selectAmount(this);
        }
        return;
      }
    }
  }
}
