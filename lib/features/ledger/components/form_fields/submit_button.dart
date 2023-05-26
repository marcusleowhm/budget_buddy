import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, this.action});

  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: ElevatedButton(
        onPressed: action,
        child: const Text('Submit'),
      ),
    );
  }
}
