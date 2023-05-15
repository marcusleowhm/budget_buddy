import 'package:budget_buddy/features/configuration/widgets/menu_group.dart';
import 'package:budget_buddy/features/configuration/widgets/menu_item.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SupportGroup extends StatelessWidget {
  const SupportGroup({super.key});

  List<MenuItem> _buildData(BuildContext context) {
    return <MenuItem>[
      MenuItem(
        entry: Entry(
          leading: const Icon(Icons.bug_report_outlined),
          title: const Text('Report Bug'),
          onTap: () => context.go('/${routes[MainRoutes.more]}/${routes[SubRoutes.reportbug]}'),
        ),
      ),
      const MenuItem(
        entry: Entry(
          leading: Icon(Icons.feedback_outlined),
          title: Text('Feedback/Suggestion'),
        ),
      ),
      const MenuItem(
        entry: Entry(
          leading: Icon(Icons.help_outline),
          title: Text('Help'),
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
