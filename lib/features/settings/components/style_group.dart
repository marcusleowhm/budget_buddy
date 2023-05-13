import 'package:budget_buddy/features/settings/widgets/menu_group.dart';
import 'package:budget_buddy/features/settings/widgets/menu_item.dart';
import 'package:flutter/material.dart';

class StyleGroup extends StatefulWidget {
  const StyleGroup({super.key});

  @override
  State<StyleGroup> createState() => _StyleGroupState();
}

class _StyleGroupState extends State<StyleGroup> {
  bool isDarkMode = false;
  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  final List<MenuItem> data = const <MenuItem>[
    MenuItem(entry: Entry('Dark Mode')),
    MenuItem(
      entry: Entry(
        'Color',
        [Entry('Test')],
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MenuGroup(
      title: 'Style',
      children: data,
    );
  }
}
