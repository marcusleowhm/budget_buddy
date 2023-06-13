import 'package:budget_buddy/features/configuration/widgets/menu_group.dart';
import 'package:budget_buddy/features/configuration/widgets/list_item.dart';
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
        entry: ListItem(
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
        entry: ListItem(
          leading: Icon(Icons.brush_outlined),
          title: Text('Color'),
          children: [
            ListItem(
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
