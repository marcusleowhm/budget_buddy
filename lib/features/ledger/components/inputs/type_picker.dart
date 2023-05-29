import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TransactionType { income, expense, transfer }

class TypePicker extends StatelessWidget {
  const TypePicker({super.key, required this.type, required this.setType});

  final TransactionType type;
  final void Function(TransactionType newSelection) setType;

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 30.0),
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
                        ? Colors.blue[100]
                        : Theme.of(context).canvasColor,
                    border: Border.all(
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 30.0),
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
                        ? Colors.blue[100]
                        : Theme.of(context).canvasColor,
                    border: Border.all(
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 30.0),
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