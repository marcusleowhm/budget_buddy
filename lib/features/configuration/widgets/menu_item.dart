import 'package:flutter/material.dart';

//Entity representing an object making up the MenuItem
class ListEntry {
  const ListEntry({
    this.title,
    this.initiallyExpanded = false,
    this.leading,
    this.trailing,
    this.onTap,
    this.children = const <ListEntry>[],
  });

  final Widget? title;
  final bool? initiallyExpanded;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final List<ListEntry> children;
}

class MenuItem extends StatelessWidget {
  const MenuItem({this.entry = const ListEntry(), super.key});

  final ListEntry entry;

  Widget _buildMenuTiles(ListEntry root) {
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
        key: PageStorageKey<ListEntry>(root),
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
