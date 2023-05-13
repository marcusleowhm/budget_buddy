import 'package:flutter/material.dart';
import 'package:budget_buddy/features/configuration/widgets/menu_item.dart';

//Menu Group will include a title, and a group of ListTile widgets
//ListTile children comprises of icon, their own title and some contain trailing icon button
class MenuGroup extends StatelessWidget {
  const MenuGroup({super.key, this.title, required this.children});

  final String? title;
  final List<MenuItem> children;

  List<Widget> _buildGroup(BuildContext context) {
    
    List<Widget> finalChildren = [];
    if (title != null) {
      finalChildren.add(ListTile(
        enabled: false,
        title: Text(
          title!,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ));
    }
    finalChildren.add(
      Container(
        color: Theme.of(context).canvasColor,
        child: Column(children: children),
      ),
    );

    return finalChildren;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: _buildGroup(context),
      ),
    );
  }
}
