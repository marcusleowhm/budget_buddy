import 'package:flutter/material.dart';

class AddRowButton extends StatelessWidget {
  const AddRowButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))),
        ),
        child: const Text('Add Another Transaction'),
      ),
    );
  }
}
