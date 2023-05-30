import 'package:flutter/material.dart';

class BasicChart extends StatelessWidget {
  const BasicChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Card(
        child: Container(
          color: Colors.red,
          margin: const EdgeInsets.all(64.0),
          padding: const EdgeInsets.all(104.0),
          child: const Column(
            children: [
              Text('Basic Charts'),
            ],
          ),
        ),
      ),
    );
  }
}