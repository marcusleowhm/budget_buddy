import 'package:flutter/material.dart';
import 'package:budget_buddy/nav/routes.dart';

class ReportBugScreen extends StatelessWidget {
  const ReportBugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${titles[SubRoutes.reportbug]}'),
      ),
    );
  }
}
