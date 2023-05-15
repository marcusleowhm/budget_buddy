import 'package:flutter/material.dart';

class FormEntry {
  const FormEntry({
    this.expansionTileController,
    this.title = const Text(''),
    this.subtitle,
    this.leading,
    this.trailing,
    this.children = const <FormEntry>[],
  });

  final ExpansionTileController? expansionTileController;
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final List<FormEntry> children;

  @override
  int get hashCode => Object.hash(title, subtitle, children);
  
  @override
  bool operator ==(Object other) => other is FormEntry && title == other.title && subtitle == other.subtitle && children == other.children;

}

class ExpansionFormItem extends StatelessWidget {
  const ExpansionFormItem({super.key, required this.formEntry});

  final FormEntry formEntry;

  ListTile _buildListTile(FormEntry formEntry) {
    return ListTile(
        key: PageStorageKey<int>(formEntry.hashCode),
        horizontalTitleGap: 16.0,
        title: formEntry.title,
        subtitle: formEntry.subtitle,
        leading: formEntry.leading,
        trailing: formEntry.trailing);
  }

  ListTileTheme _buildExpansionTile(FormEntry formEntry) {
    return ListTileTheme(
      horizontalTitleGap: 16.0,
      child: ExpansionTile(
        key: PageStorageKey<int>(formEntry.hashCode),
        controller: formEntry.expansionTileController,
        title: formEntry.title,
        subtitle: formEntry.subtitle,
        leading: formEntry.leading,
        trailing: formEntry.trailing,
        initiallyExpanded: true,
        children: formEntry.children.map(_buildFormTiles).toList(),
      ),
    );
  }

  Widget _buildFormTiles(FormEntry formEntry) {
    if (formEntry.children.isEmpty) {
      return _buildListTile(formEntry);
    }
    return _buildExpansionTile(formEntry);
  }

  @override
  Widget build(BuildContext context) {
    return _buildFormTiles(formEntry);
  }
}
