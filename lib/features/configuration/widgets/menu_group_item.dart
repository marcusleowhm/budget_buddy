import 'package:flutter/material.dart';

//Entity representing an object making up the MenuItem
class MenuGroupItem {
  const MenuGroupItem({
    this.title,
    this.initiallyExpanded = false,
    this.leading,
    this.trailing,
    this.onTap,
    this.children = const <MenuGroupItem>[],
  });

  final Widget? title;
  final bool? initiallyExpanded;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final List<MenuGroupItem> children;
}

class MenuItem extends StatelessWidget {
  const MenuItem({this.entry = const MenuGroupItem(), super.key});

  final MenuGroupItem entry;

  Widget _buildMenuTiles(MenuGroupItem root) {
    if (root.children.isEmpty) {
      return ListTile(
        horizontalTitleGap: 0.0,
        title: root.title != null ? root.title! : null,
        leading: root.leading,
        trailing: root.trailing,
        onTap: root.onTap,
      );
    }
    return ListTileTheme(
      horizontalTitleGap: 0.0,
      child: ExpansionTile(
        key: PageStorageKey<MenuGroupItem>(root),
        title: root.title != null ? root.title! : const Text(''),
        initiallyExpanded: root.initiallyExpanded!,
        leading: root.leading,
        trailing: root.trailing,
        children: root.children.map(_buildMenuTiles).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMenuTiles(entry);
  }
}
