import 'package:budget_buddy/features/configuration/screens/secondary/report_bug_screen.dart';
import 'package:budget_buddy/features/configuration/widgets/menu_item.dart';
import 'package:budget_buddy/features/configuration/widgets/menu_group.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SupportGroup extends StatelessWidget {
  const SupportGroup({super.key});

  List<MenuItem> _buildData(BuildContext context) {
    return <MenuItem>[
      MenuItem(
        entry: Entry(
          leading: const Icon(Icons.bug_report_outlined),
          title: 'Report Bug',
          onTap: () => context.go('/more/reportbug'),
        ),
      ),
      const MenuItem(
        entry: Entry(
          leading: Icon(Icons.feedback_outlined),
          title: 'Feedback/Suggestion',
        ),
      ),
      const MenuItem(
        entry: Entry(
          leading: Icon(Icons.help_outline),
          title: 'Help',
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MenuGroup(
      title: 'Support',
      children: _buildData(context),
    );
  }
}
