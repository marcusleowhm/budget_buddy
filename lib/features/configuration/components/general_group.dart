import 'package:flutter/material.dart';
import 'package:budget_buddy/features/configuration/widgets/menu_group.dart';
import 'package:budget_buddy/features/configuration/widgets/menu_item.dart';

class GeneralGroup extends StatelessWidget {
  const GeneralGroup({super.key});

  final List<MenuItem> data = const <MenuItem>[
    MenuItem(
      entry: Entry(
        leading: Icon(Icons.settings_outlined),
        title: 'Settings',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MenuGroup(
      title: 'General',
      children: data,
    );
  }
}