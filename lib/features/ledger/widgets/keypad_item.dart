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
        child: label is Icon
            ? label.toString() == const Icon(Icons.done).toString()
                ? Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Center(child: label),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                    ),
                    child: Center(child: label),
                  )
            : Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                ),
                child: Center(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
        onTap: () => onPressed(label.toString()));
  }
}
