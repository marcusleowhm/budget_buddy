import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More')
      ),
      body: Container(
        color: Colors.amber,
        child: Row(
          children: const [
            Text('Test')
          ],
        ),
      ),
    );
  }
}