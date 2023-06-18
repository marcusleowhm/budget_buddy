import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/features/ledger/widgets/widget_shaker.dart';
import 'package:budget_buddy/utilities/currency_formatter.dart';
import 'package:budget_buddy/utilities/date_utilities.dart';
import 'package:flutter/material.dart';

class FormControlUtility {
  /// Creates form controllers, focus and keys.
  /// - Pass in data to create controller with existing data
  /// - noteController and additionalNoteController will need to have listeners added to them after calling create() as the UI needs to rebuild with each keystroke.
  /// - We will need to leverage on Flutter's Stateful widget's setState or BLoC's Cubits
  static LedgerInput create({
    TransactionData? data,
    VoidCallback? setNoteState,
    VoidCallback? setAddNoteState,
  }) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Controllers first
    TextEditingController dateTimeController = TextEditingController();
    TextEditingController accountController = TextEditingController();
    TextEditingController incomeCategoryController = TextEditingController();
    TextEditingController expenseCategoryController = TextEditingController();
    TextEditingController transferCategoryController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    TextEditingController additionalNoteController = TextEditingController();

    //Add GlobalKey for each LedgerInput's input widget
    GlobalKey<FormFieldState> dateTimeKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> accountKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> incomeCategoryKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> expenseCategoryKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> transferCategoryKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> amountKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> noteKey = GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> additionalNoteKey = GlobalKey<FormFieldState>();

    GlobalKey<ShakeErrorState> formShakerKey = GlobalKey<ShakeErrorState>();
    GlobalKey<ShakeErrorState> accountShakerKey = GlobalKey<ShakeErrorState>();
    GlobalKey<ShakeErrorState> categoryShakerKey = GlobalKey<ShakeErrorState>();

    //Add focus nodes
    FocusNode dateTimeFocus = FocusNode();
    FocusNode accountFocus = FocusNode();
    FocusNode categoryFocus = FocusNode();
    FocusNode amountFocus = FocusNode();
    FocusNode noteFocus = FocusNode();
    FocusNode additionalNoteFocus = FocusNode();

    LedgerInput input = LedgerInput(
      data: data ?? TransactionData(),
      formKey: formKey,
      dateTimeController: dateTimeController,
      accountController: accountController,
      incomeCategoryController: incomeCategoryController,
      expenseCategoryController: expenseCategoryController,
      transferCategoryController: transferCategoryController,
      amountController: amountController,
      noteController: noteController,
      additionalNoteController: additionalNoteController,
      dateTimeKey: dateTimeKey,
      accountKey: accountKey,
      incomeCategoryKey: incomeCategoryKey,
      expenseCategoryKey: expenseCategoryKey,
      transferCategoryKey: transferCategoryKey,
      amountKey: amountKey,
      noteKey: noteKey,
      additionalNoteKey: additionalNoteKey,
      formShakerKey: formShakerKey,
      accountShakerKey: accountShakerKey,
      categoryShakerKey: categoryShakerKey,
      dateTimeFocus: dateTimeFocus,
      accountFocus: accountFocus,
      categoryFocus: categoryFocus,
      amountFocus: amountFocus,
      noteFocus: noteFocus,
      additionalNoteFocus: additionalNoteFocus,
    );

    // Set initial display text for datetime controller
    dateTimeController.text =
        dateLongFormatter.format(input.data.utcDateTime.toLocal());

    // Set initial display value for other controllers if data is provided (Only if control is used to edit form)
    if (data != null) {
      dateTimeController.text =
          dateLongFormatter.format(data.utcDateTime.toLocal());
      accountController.text = data.subAccount;
      
      if (data.incomeSubCategory != null) {
        incomeCategoryController.text = '${data.incomeCategory} (${data.incomeSubCategory})';
      } else {
        incomeCategoryController.text = data.incomeCategory;
      }

      if (data.expenseSubCategory != null) {
        expenseCategoryController.text = '${data.expenseCategory} (${data.expenseSubCategory})';
      } 
      else {
        expenseCategoryController.text = data.expenseCategory;
      }

      if (data.transferSubCategory != null) {
        transferCategoryController.text = data.transferSubCategory!;
      }

      amountController.text =
          englishDisplayCurrencyFormatter.format(data.amount);
      noteController.text = data.note;
      additionalNoteController.text = data.additionalNote;
    }

    // Add listeners to trigger validation when losing focus on controllers
    accountFocus.addListener(
      () {
        if (!accountFocus.hasFocus) {
          accountKey.currentState?.validate();
        }
      },
    );
    categoryFocus.addListener(
      () {
        if (!categoryFocus.hasFocus) {
          switch (data?.type) {
            case TransactionType.income:
              incomeCategoryKey.currentState?.validate();
              break;
            case TransactionType.expense:
              expenseCategoryKey.currentState?.validate();
              break;
            case TransactionType.transfer:
              transferCategoryKey.currentState?.validate();
              break;
            case null:
              break;
          }
        }
      },
    );
    //Removed amount focus because clicking on the keypad is evaluted as amountController is losing focus
    return input;
  }

  static void dispose(LedgerInput input) {
    input.dateTimeController.dispose();
    input.accountController.dispose();
    input.incomeCategoryController.dispose();
    input.expenseCategoryController.dispose();
    input.transferCategoryController.dispose();
    input.amountController.dispose();
    input.noteController.dispose();
    input.additionalNoteController.dispose();

    input.dateTimeFocus.dispose();
    input.accountFocus.dispose();
    input.categoryFocus.dispose();
    input.amountFocus.dispose();
    input.noteFocus.dispose();
    input.additionalNoteFocus.dispose();
  }
}
