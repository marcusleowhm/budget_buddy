import 'package:flutter/material.dart';

class BasicChart extends StatelessWidget {
  const BasicChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: const Column(
            children: [
              Text(
                'Basic Charts',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
