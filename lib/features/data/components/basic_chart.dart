import 'package:flutter/material.dart';

class BasicChart extends StatelessWidget {
  const BasicChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: const Column(
            children: [
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
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
              ),
              Divider(thickness: 1.0),
            ],
          ),
        ),
      ),
    );
  }
}
