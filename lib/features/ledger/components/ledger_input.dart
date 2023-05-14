import 'package:budget_buddy/features/configuration/widgets/menu_group.dart';
import 'package:flutter/material.dart';

import '../../configuration/widgets/menu_item.dart';

class LedgerInput extends StatefulWidget {
  const LedgerInput({super.key});

  @override
  State<LedgerInput> createState() => _LedgerInputState();
}

class _LedgerInputState extends State<LedgerInput> {
  List<MenuItem> data = <MenuItem>[
    MenuItem(
      entry: Entry(
        leading: Column(
          children: const [
            Text('14'),
            Text('May'),
            Text('2023'),
          ],
        ),
        title: const Text('228-19482-4'),
        initiallyExpanded: true,
        children: const [
          Entry(title: Text('Date')),
          Entry(title: Text('Account')),
          Entry(title: Text('Category')),
          Entry(title: Text('Amount')),
          Entry(title: Text('Additional Note')),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MenuGroup(children: data);
  }
}
