import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TransactionType { income, expense, transfer }

class TypePicker extends StatelessWidget {
  const TypePicker({super.key, required this.type, required this.setType});

  final TransactionType type;
  final void Function(Set<TransactionType> newSelection) setType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: SegmentedButton<TransactionType>(
        style: const ButtonStyle(
          side: MaterialStatePropertyAll<BorderSide>(
            BorderSide(width: 0.5),
          ),
        ),
        showSelectedIcon: false,
        segments: const <ButtonSegment<TransactionType>>[
          ButtonSegment<TransactionType>(
            icon: FaIcon(FontAwesomeIcons.handHoldingDollar),
            value: TransactionType.income,
            label: Text('Income'),
          ),
          ButtonSegment<TransactionType>(
            icon: FaIcon(FontAwesomeIcons.moneyBill),
            value: TransactionType.expense,
            label: Text('Expense'),
          ),
          ButtonSegment<TransactionType>(
            icon: FaIcon(FontAwesomeIcons.moneyBillTransfer),
            value: TransactionType.transfer,
            label: Text('Transfer'),
          ),
        ],
        selected: <TransactionType>{type},
        onSelectionChanged: (Set<TransactionType> newSelection) =>
            setType(newSelection),
      ),
    );
  }
}
