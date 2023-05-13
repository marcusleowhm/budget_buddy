import 'package:flutter/material.dart';

//Entity representing an object making up the MenuItem
class Entry {
  const Entry({
    this.title,
    this.leading,
    this.trailing,
    this.onTap,
    this.children = const <Entry>[],
  });

  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final List<Entry> children;
}

class MenuItem extends StatelessWidget {
  const MenuItem({this.entry = const Entry(), super.key});

  final Entry entry;

  Widget _buildMenuTiles(Entry root) {
    if (root.children.isEmpty) {
      return ListTile(
        horizontalTitleGap: 0.0,
        title: Text(root.title!),
        leading: root.leading,
        trailing: root.trailing,
        onTap: root.onTap,
      );
    }
    return ListTileTheme(
      horizontalTitleGap: 0.0,
      child: ExpansionTile(
        key: PageStorageKey<Entry>(root),
        title: Text(root.title!),
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
