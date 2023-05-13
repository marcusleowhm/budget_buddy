import 'package:budget_buddy/features/settings/widgets/menu_item.dart';
import 'package:budget_buddy/features/settings/widgets/menu_group.dart';
import 'package:flutter/material.dart';

class SupportGroup extends StatelessWidget {
  const SupportGroup({super.key});

  final List<MenuItem> data = const <MenuItem>[
    MenuItem(
      Entry('Report Bug'),
    ),
    MenuItem(
      Entry('Feedback/Suggestion'),
    ),
    MenuItem(
      Entry('Help'),
    ),
    MenuItem(
      Entry('About'),
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
