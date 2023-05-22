import 'package:flutter/material.dart';

class KeypadItem extends StatelessWidget {
  const KeypadItem({
    super.key,
    required this.label,
    required this.value,
    required this.onPressed,
  });

  final dynamic label;
  final dynamic value;
  final Function(dynamic) onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: label is Widget
            ? AspectRatio(
                aspectRatio: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                  ),
                  child: Center(child: label),
                ),
              )
            : AspectRatio(
                aspectRatio: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                  ),
                  child: Center(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
        onTap: () => onPressed(label));
  }
}
