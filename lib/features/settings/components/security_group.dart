import 'package:budget_buddy/features/settings/widgets/menu_group.dart';
import 'package:budget_buddy/features/settings/widgets/menu_item.dart';
import 'package:flutter/material.dart';

class SecurityGroup extends StatelessWidget {
  const SecurityGroup({super.key});

  final List<MenuItem> data = const <MenuItem>[
    MenuItem(
      entry: Entry(title: 'Change Email'),
    ),
    MenuItem(
      entry: Entry(title: 'Change Password'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MenuGroup(
      title: 'Security',
      children: data,
    );
  }
}
