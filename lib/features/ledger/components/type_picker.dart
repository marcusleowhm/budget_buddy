import 'package:flutter/material.dart';

enum TransactionType { income, expense, transfer }

class TypePicker extends StatelessWidget {
  const TypePicker({super.key, required this.type, required this.setType});

  final TransactionType type;
  final void Function(Set<TransactionType> newSelection) setType;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TransactionType>(
      segments: const <ButtonSegment<TransactionType>>[
        ButtonSegment<TransactionType>(
          value: TransactionType.income,
          label: Text('Income'),
        ),
        ButtonSegment<TransactionType>(
          value: TransactionType.expense,
          label: Text('Expense'),
        ),
        ButtonSegment<TransactionType>(
          value: TransactionType.transfer,
          label: Text('Transfer'),
        ),
      ],
      selected: <TransactionType>{type},
      onSelectionChanged: (Set<TransactionType> newSelection) =>
          setType(newSelection),
    );
  }
}