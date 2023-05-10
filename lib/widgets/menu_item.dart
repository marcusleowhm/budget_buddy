import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({super.key, required this.title, this.action});

  final String title;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: action,
    );
  }
}
