import 'package:budget_buddy/features/ledger/model/keyset.dart';
import 'package:budget_buddy/features/ledger/widgets/keypad.dart';
import 'package:flutter/material.dart';

class AmountTyper extends StatelessWidget {
  const AmountTyper({
    super.key,
    required this.amount,
    required this.getInput,
    required this.onCancelPressed,
  });

  final double amount;
  final void Function(dynamic) getInput;
  final VoidCallback onCancelPressed;

  //https://www.youtube.com/watch?v=dfaFK561PAo&t=726s
  @override
  Widget build(BuildContext context) {
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => onCancelPressed(),
                        icon: const Icon(Icons.cancel_rounded),
                        color: Theme.of(context).canvasColor,
                      ),
                    ],
                  ),
                ),
                Expanded( //This expanded will ensure the keypad take up the remaining space
                  child: Keypad(
                    amount: amount,
                    keyset: USDKeySet(),
                    onPressed: getInput,
                  ),
                ),
              ],
            )));
  }
}
