import 'package:flutter/material.dart';

//Entity representing an object making up the MenuItem
class Entry {
  const Entry({this.title= '', this.children = const <Entry>[]});

  final String? title;
  final List<Entry> children;
}

class MenuItem extends StatelessWidget {
  const MenuItem({this.entry = const Entry(title: ''), super.key});

  final Entry entry;

  Widget _buildMenuTiles(Entry root) {
    if (root.children.isEmpty) {
      return ListTile(
        title: Text(root.title!)
      );
    }
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title!),
      children: root.children.map(_buildMenuTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMenuTiles(entry);
  }
}
