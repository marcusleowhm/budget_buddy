import 'package:flutter/material.dart';

class AddRowButton extends StatelessWidget {
  const AddRowButton({super.key, this.action});

  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: OutlinedButton(
        onPressed: action,
        child: const Text('Add'),
      ),
    );
  }
}
