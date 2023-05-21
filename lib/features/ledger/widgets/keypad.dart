import 'package:budget_buddy/features/ledger/widgets/keypad_item.dart';
import 'package:flutter/material.dart';

import '../model/keyset.dart';

class Keypad extends StatelessWidget {
  const Keypad({
    super.key,
    required this.keyset,
    required this.amount,
    required this.onPressed,
  });

  final Keyset keyset;
  final double amount;
  final void Function(dynamic) onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keyset.keys
          .map((x) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: x.map((y) {
                  return Expanded(
                    child: Container(
                        color: Theme.of(context).canvasColor,
                        child: KeypadItem(
                          label: y,
                          onPressed: (y) => onPressed(y),
                        )),
                  );
                }).toList(),
              ))
          .toList(),
    );
  }
}
