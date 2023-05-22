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
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 50,
        crossAxisCount: 3,
      ),
      itemCount: keyset.keys.length,
      itemBuilder: (context, index) {
        return KeypadItem(
          label: keyset.keys[index],
          value: keyset.keys[index],
          onPressed: onPressed,
        );
      },
    );
  }
}
