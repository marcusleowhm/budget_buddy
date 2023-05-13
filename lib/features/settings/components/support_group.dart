import 'package:budget_buddy/features/settings/widgets/menu_item.dart';
import 'package:budget_buddy/features/settings/widgets/menu_group.dart';
import 'package:flutter/material.dart';

class SupportGroup extends StatelessWidget {
  const SupportGroup({super.key});

  final List<MenuItem> data = const <MenuItem>[
    MenuItem(
      entry: Entry(
        leading: Icon(Icons.bug_report_outlined),
        title: 'Report Bug',
      ),
    ),
    MenuItem(
      entry: Entry(
        leading: Icon(Icons.feedback_outlined),
        title: 'Feedback/Suggestion',
      ),
    ),
    MenuItem(
      entry: Entry(
        leading: Icon(Icons.help_outline),
        title: 'Help',
      ),
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
