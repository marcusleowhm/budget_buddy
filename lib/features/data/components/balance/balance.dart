import 'package:budget_buddy/features/data/components/balance/account_list.dart';
import 'package:flutter/material.dart';

class Balance extends StatelessWidget {
  const Balance({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AccountList(),
      ],
    );
  }
}
