import 'package:flutter/material.dart';

//Menu Group will include a title, and a group of ListTile widgets
//ListTile children comprises of icon, their own title and some contain trailing icon button
class MenuGroup extends StatelessWidget {
  const MenuGroup({super.key, this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: title != null
              ? Text(
                  title!,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              : null,
        ),
        Container(
          color: Theme.of(context).canvasColor,
          child: Column(
            children: children,
          ),
        )
      ],
    );
  }
}
