import 'package:budget_buddy/features/ledger/model/keyset.dart';
import 'package:budget_buddy/features/ledger/widgets/keypad.dart';
import 'package:flutter/material.dart';

import '../../../utilities/currency_formatter.dart';
import '../model/ledger_input.dart';

class AmountTyper extends StatelessWidget {
  const AmountTyper({
    super.key,
    required this.input,
    required this.onCancelPressed,
    required this.moveFocusTo,
    required this.scrollToWidget,
    required this.closeBottomSheet,
  });

  final LedgerInput input;
  final VoidCallback onCancelPressed;
  final void Function(FocusNode focus) moveFocusTo;
  final Future<void> Function(GlobalKey widgetKey, double alignment) scrollToWidget;
  final VoidCallback closeBottomSheet;

  void _formatAndSetAmount(LedgerInput input, dynamic keyPress) {
    //Backspace action here
    if (keyPress == const Icon(Icons.backspace).toString()) {
      _handleBackspaceKey(input);
      return;
    }

    //Done button action here
    if (keyPress == const Icon(Icons.done).toString()) {
      _handleDoneKey(input);
      return;
    }

    switch (keyPress) {
      //Handle the sign toggle keypress
      case '-/+':
        _handleSignToggleKey(input);
        return;
      //Do nothing when empty key is pressed
      case '':
        return;
      //Handle when user press decimal key
      case '.':
        _handleDecimalKey(input);
        return;
      case '00':
        _handleDoubleZeroKey(input);
        return;
      case '000':
        //TODO
        return;
      default:
        _handleNumberKey(input, keyPress);
        return;
    }
  }

  void _handleBackspaceKey(LedgerInput input) {
    String displayedText = input.amountController.text;
    if (displayedText.isEmpty) {
      //If the TextField is already empty, escape from function
      return;
    }
    //Cut the string character one at a time
    //Set the newly cut string back into the textfield
    String newText = displayedText.substring(0, displayedText.length - 1);

    //If the remaining text is empty or has a dot at the end, display as it is
    if (newText.isEmpty || newText[newText.length - 1] == '.') {
      input.amountController.text = newText;
      return;
    }

    //if the remaining text is just the currency symbol and/or negative sign, just empty it
    if (newText == '\$ -' || newText == '\$' || newText == '-') {
      input.amountController.clear();
      return;
    }

    //If the remaining text contains a dot and there is a decimal place left, display as it is
    if (newText.contains('.')) {
      int decimalPlaces = newText.split('.')[1].length;
      if (decimalPlaces == 1) {
        input.amountController.text = newText;
        return;
      }
    }

    double newValue =
        double.tryParse(newText.replaceAll(',', '').replaceAll('\$', '')) ??
            0.0;
    input.amountController.text =
        englishTypingCurrencyFormatter.format(newValue);
    return;
  }

  void _handleSignToggleKey(LedgerInput input) {
    //When the key is pressed without anything inside
    if (input.amountController.text.isEmpty) {
      input.amountController.text = '-';
      return;
    }
    //When the input is just a positive number
    if (!input.amountController.text.contains('-')) {
      input.amountController.text = '-${input.amountController.text}';
      return;
    }

    //When the input is just a negative number
    if (input.amountController.text.contains('-')) {
      input.amountController.text = input.amountController.text
          .substring(1, input.amountController.text.length);
      return;
    }
  }

  void _handleDoneKey(LedgerInput input) {
    //When the user has not entered anything
    //When the user has entered a number, doesn't matter whether a dot was pressed
    input.amountController.text =
        englishDisplayCurrencyFormatter.format(input.amount);
    moveFocusTo(input.noteFocus);
    scrollToWidget(input.noteKey, 0.0);
    closeBottomSheet();
    return;
  }

  void _handleDecimalKey(LedgerInput input) {
    //Add a leading zero and dot if the text is just a negative sign
    if (input.amountController.text == '-') {
      input.amountController.text = '-0.';
      return;
    }

    //Add a leading zero and dot if the TextField is still empty
    //Does not affect the ledger state, so no setState needed
    if (input.amountController.text.isEmpty) {
      input.amountController.text = '0.';
      return;
    }

    //Only add a dot if there is no dot yet
    if (!input.amountController.text.contains('.')) {
      input.amountController.text += '.';
      return;
    }
  }

  void _handleDoubleZeroKey(LedgerInput input) {
    bool isInteger(double amount) {
      return amount % 1 == 0;
    }

    if (input.amountController.text.isEmpty) {
      input.amountController.text = '0';
    }

    double? maybeValue = double.tryParse(
        input.amountController.text.replaceAll(',', '').replaceAll('\$', ''));
    if (maybeValue != null) {
      //If it's not zero, still an integer, and user have clicked on the dot
      //Value remains the same, but the text will have to display two more trailing zeros
      if (isInteger(maybeValue) && input.amountController.text.contains('.')) {
        input.amountController.text =
            englishDisplayCurrencyFormatter.format(maybeValue);
        return;
      }

      //If it's not zero, still an integer, and user have not clicked on dot
      //Just add two zeros at the back by multiplying by 100
      //End result is still an integer value
      if (isInteger(maybeValue) && !input.amountController.text.contains('.')) {
        input.amountController.text = englishTypingCurrencyFormatter.format(100 * maybeValue);
        return;
      }

      //If the value is a double, we need to find number of decimal places
      if (!isInteger(maybeValue)) {
        int decimals = input.amountController.text.split('.')[1].length;

        switch (decimals) {
          //If there is only 1 decimal place, add a zero at the hundredth place
          case 1:
            input.amountController.text += '0';
            return;
          //if there are 2 decimal places, replace the one at the hundredth place
          case 2:
            input.amountController.text =
                '${input.amountController.text.substring(0, input.amountController.text.length - 1)}0';
            return;
        }
      }
    }
  }

  void _handleNumberKey(LedgerInput input, dynamic keyPress) {
    int? numberInput = int.tryParse(keyPress);
    if (numberInput != null) {
      //When there is nothing in the field OR a negative sign
      if (input.amountController.text.isEmpty ||
          input.amountController.text == '-') {
        input.amountController.text += numberInput.toString();
        return;
      }

      //if there is a decimal in place
      if (input.amountController.text.contains('.')) {
        //Check decimal places first
        int decimals = input.amountController.text.split('.')[1].length;
        switch (decimals) {
          case 0:
          case 1:
            input.amountController.text += numberInput.toString();
            return;
          case 2:
            //replace the digit in the hundredths digit
            input.amountController.text = input.amountController.text
                    .substring(0, input.amountController.text.length - 1) +
                numberInput.toString();
            return;
        }
      }

      //If there is no decimal places
      if (!input.amountController.text.contains('.')) {
        String displayedText = input.amountController.text;
        double currentValue = double.parse(
            displayedText.replaceAll(',', '').replaceAll('\$', '') +
                numberInput.toString());
        input.amountController.text =
            englishTypingCurrencyFormatter.format(currentValue);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    Keyset keySet = currencyKeys[input.currency];

    return FractionallySizedBox(
      heightFactor: 0.4,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(
            width: 0.5,
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => onCancelPressed(),
                    icon: const Icon(Icons.cancel_rounded),
                    color: Theme.of(context).canvasColor,
                  ),
                ],
              ),
            ),
            Flexible(
              //This expanded will ensure the keypad take up the remaining space
              child: Keypad(
                amount: input.amount,
                keyset: keySet,
                onPressed: (dynamic keyPress) {
                  _formatAndSetAmount(input, keyPress);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
