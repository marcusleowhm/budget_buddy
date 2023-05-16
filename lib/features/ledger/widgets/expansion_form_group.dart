import 'package:flutter/material.dart';

import 'expansion_form_item.dart';

class ExpansionFormGroup extends StatelessWidget {
  const ExpansionFormGroup({super.key, required this.child});

  final ExpansionFormItem child;

  ExpansionFormItem _buildGroup(BuildContext context) {
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      color: Theme.of(context).canvasColor,
      child: _buildGroup(context),
    );
  }
}
