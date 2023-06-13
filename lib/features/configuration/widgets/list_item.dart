import 'package:flutter/material.dart';

//Entity representing an object making up the MenuItem
class ListItem {
  const ListItem({
    this.title,
    this.initiallyExpanded = false,
    this.leading,
    this.trailing,
    this.onTap,
    this.children = const <ListItem>[],
  });

  final Widget? title;
  final bool? initiallyExpanded;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final List<ListItem> children;
}

class MenuItem extends StatelessWidget {
  const MenuItem({this.entry = const ListItem(), super.key});

  final ListItem entry;

  Widget _buildMenuTiles(ListItem root) {
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
        key: PageStorageKey<ListItem>(root),
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
