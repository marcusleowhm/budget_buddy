import 'package:budget_buddy/features/configuration/widgets/menu_group.dart';
import 'package:budget_buddy/features/configuration/widgets/menu_group_item.dart';
import 'package:flutter/material.dart';

class SecurityGroup extends StatelessWidget {
  const SecurityGroup({super.key});

  final List<MenuItem> data = const <MenuItem>[
    MenuItem(
      entry: MenuGroupItem(
        leading: Icon(Icons.email_outlined),
        title: Text('Change Email'),
      ),
    ),
    MenuItem(
      entry: MenuGroupItem(
        leading: Icon(Icons.lock_outline),
        title: Text('Change Password'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MenuGroup(
      title: 'Security',
      children: data,
    );
  }
}
