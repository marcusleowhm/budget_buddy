import 'package:flutter/material.dart';

class MenuGroup extends StatelessWidget {
  const MenuGroup({
    super.key,
    this.groupLabel,
    required this.children,
  });

  final String? groupLabel;
  final List<Widget> children;

  List<Widget> _buildChildren(
      List<Widget> childrenInput, BuildContext context) {
    List<Widget> childrenOutput = [];

    if (groupLabel != null) {
      childrenOutput.add(ListTile(
        subtitle: Text(groupLabel!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        textColor: Theme.of(context).primaryColor,
      ));
    }

    for (int i = 0; i < childrenInput.length; i++) {
      childrenOutput.add(childrenInput.elementAt(i));
    }
    return childrenOutput;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: _buildChildren(children, context));
  }
}
