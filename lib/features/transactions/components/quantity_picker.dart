import 'package:flutter/material.dart';

class QuantityPicker extends StatelessWidget {
  const QuantityPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        alignment: AlignmentDirectional.center,
        color: Colors.amber,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {},
              child: const Text('Single'),
            ),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Multiple'),
            ),
          ],
        ),
      ),
    );
  }
}
