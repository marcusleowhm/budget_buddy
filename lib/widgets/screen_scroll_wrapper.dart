import 'package:flutter/material.dart';

class ScreenScrollWrapper extends StatelessWidget {
  const ScreenScrollWrapper({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: children,
    );
  }
}
