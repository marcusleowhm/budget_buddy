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
    return Material(
      child: label == ''
          ? Center(child: Text(label))
          : Ink(
              decoration: BoxDecoration(
                color: label.toString() == const Icon(Icons.done).toString()
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).canvasColor,
              ),
              child: InkWell(
                child: label is Icon
                    // If label is Icon, just let it be Icon
                    ? Center(child: label)
                    //Else will be just number button
                    : Center(
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                onTap: () => onPressed(
                  label.toString(),
                ),
              ),
            ),
    );
  }
}
