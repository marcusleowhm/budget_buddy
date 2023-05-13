import 'package:budget_buddy/features/settings/widgets/menu_item.dart';
import 'package:budget_buddy/features/settings/widgets/menu_group.dart';
import 'package:flutter/material.dart';

class SupportGroup extends StatelessWidget {
  const SupportGroup({super.key});

  final List<MenuItem> data = const <MenuItem>[
    MenuItem(
      entry: Entry(title: 'Report Bug'),
    ),
    MenuItem(
      entry: Entry(title: 'Feedback/Suggestion'),
    ),
    MenuItem(
      entry: Entry(title: 'Help'),
    ),
    MenuItem(
      entry: Entry(title: 'About'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MenuGroup(
      title: 'Support',
      children: data,
    );
  }
}
