import 'package:budget_buddy/features/settings/widgets/menu_item.dart';
import 'package:budget_buddy/features/settings/widgets/menu_group.dart';
import 'package:flutter/material.dart';

class SupportGroup extends StatelessWidget {
  const SupportGroup({super.key});

  final List<MenuItem> data = const <MenuItem>[
    MenuItem(
      entry: Entry('Report Bug'),
    ),
    MenuItem(
      entry: Entry('Feedback/Suggestion'),
    ),
    MenuItem(
      entry: Entry('Help'),
    ),
    MenuItem(
      entry: Entry('About'),
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
