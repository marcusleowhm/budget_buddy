import 'package:budget_buddy/features/configuration/widgets/menu_group.dart';
import 'package:budget_buddy/features/configuration/widgets/menu_group_item.dart';
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

  List<MenuItem> _buildData() {
    return <MenuItem>[
      MenuItem(
        entry: MenuGroupItem(
          leading: const Icon(Icons.dark_mode_outlined),
          trailing: Switch(
            value: isDarkMode,
            onChanged: (value) => toggleDarkMode(),
          ),
          onTap: () => toggleDarkMode(),
          title: const Text('Dark Mode'),
        ),
      ),
      const MenuItem(
        entry: MenuGroupItem(
          leading: Icon(Icons.brush_outlined),
          title: Text('Color'),
          children: [
            MenuGroupItem(
              title: Text('Test'),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MenuGroup(
      title: 'Style',
      children: _buildData(),
    );
  }
}
