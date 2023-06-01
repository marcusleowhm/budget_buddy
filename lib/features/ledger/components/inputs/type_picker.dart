import 'package:budget_buddy/features/constants/enum.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TypePicker extends StatelessWidget {
  const TypePicker({super.key, required this.type, required this.setType});

  final TransactionType type;
  final void Function(TransactionType newSelection) setType;

  @override
  Widget build(BuildContext context) {
    
    const EdgeInsets buttonPadding =
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Material(
          child: Ink(
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: type == TransactionType.income
                      ? Colors.blue[100]
                      : Theme.of(context).canvasColor,
                  border: Border.all(
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: buttonPadding,
                child: const Column(
                  children: [
                    FaIcon(FontAwesomeIcons.handHoldingDollar),
                    SizedBox(height: 10.0),
                    Text("Income")
                  ],
                ),
              ),
              onTap: () {
                setType(TransactionType.income);
              },
            ),
          ),
        ),
        Material(
          child: Ink(
            child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: type == TransactionType.expense
                        ? Colors.red[100]
                        : Theme.of(context).canvasColor,
                    border: Border.all(
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: buttonPadding,
                  child: const Column(
                    children: [
                      FaIcon(FontAwesomeIcons.moneyBill),
                      SizedBox(height: 10.0),
                      Text("Expense")
                    ],
                  ),
                ),
                onTap: () {
                  setType(TransactionType.expense);
                }),
          ),
        ),
        Material(
          child: Ink(
            child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: type == TransactionType.transfer
                        ? Colors.grey[200]
                        : Theme.of(context).canvasColor,
                    border: Border.all(
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: buttonPadding,
                  child: const Column(
                    children: [
                      FaIcon(FontAwesomeIcons.moneyBillTransfer),
                      SizedBox(height: 10.0),
                      Text("Transfer")
                    ],
                  ),
                ),
                onTap: () {
                  setType(TransactionType.transfer);
                }),
          ),
        ),
      ],
    );
  }
}
