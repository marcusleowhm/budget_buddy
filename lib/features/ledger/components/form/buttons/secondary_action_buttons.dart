import 'package:flutter/material.dart';

class SecondaryActionButton extends StatelessWidget {
  const SecondaryActionButton({
    super.key,
    required this.onDuplicatePressed,
    required this.onDeletePressed,
  });

  final VoidCallback onDuplicatePressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 5.0),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              icon: const Icon(Icons.copy),
              label: const Text('Duplicate'),
              onPressed: onDuplicatePressed,
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 5.0),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(10.0),
                //Button color
                foregroundColor: Colors.red,
                side: const BorderSide(color: Color(0xFFEF9A9A)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
              onPressed: onDeletePressed,
            ),
          ),
        ),
      ],
    );
  }
}
