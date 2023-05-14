import 'package:flutter/material.dart';

class LedgerInput extends StatefulWidget {
  const LedgerInput({super.key});

  @override
  State<LedgerInput> createState() => _LedgerInputState();
}

class _LedgerInputState extends State<LedgerInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TextField(
          decoration: InputDecoration(labelText: 'Date'),
        ),
      ],
    );
  }
}
