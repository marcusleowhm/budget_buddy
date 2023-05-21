import 'package:flutter/material.dart';

class KeypadItem extends StatelessWidget {
  const KeypadItem({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final dynamic label;
  final Function(dynamic) onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: label is Widget
            ? label
            : Text(
                label,
                textAlign: TextAlign.center,
              ),
        onTap: () => onPressed(label));
  }
}
