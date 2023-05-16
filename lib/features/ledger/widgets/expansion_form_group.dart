import 'package:flutter/material.dart';

import 'expansion_form_item.dart';

class ExpansionFormGroup extends StatelessWidget {
  const ExpansionFormGroup({super.key, required this.children});

  final List<ExpansionFormItem> children;

  List<ExpansionFormItem> _buildGroup(BuildContext context) {
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      color: Theme.of(context).canvasColor,
      child: Column(
        children: _buildGroup(context),
      ),
    );
  }
}
