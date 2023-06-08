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
              Row(
                children: [
                  Text(
                    'Basic Charts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1.0),
              
            ],
          ),
        ),
      ),
    );
  }
}
