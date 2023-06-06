import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/ledger/widgets/widget_shaker.dart';
import 'package:flutter/material.dart';

import '../../model/ledger_input.dart';

//This should be where all the text editing controllers, focus, and keys should reside
class LedgerForm extends StatefulWidget {
  const LedgerForm({
    super.key,
    required this.inputType,
    required this.input,
    required this.children,
  });

  final InputType inputType;
  final LedgerInput input;
  final List<Widget> children;

  @override
  State<LedgerForm> createState() => _LedgerFormState();
}

class _LedgerFormState extends State<LedgerForm> {

  //For tracking if form is expanded
  late bool isExpanded;

  //Controllers
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController addNoteController = TextEditingController();

  //FocusNodes
  final FocusNode dateTimeFocus = FocusNode();
  final FocusNode accountFocus = FocusNode();
  final FocusNode categoryFocus = FocusNode();
  final FocusNode amountFocus = FocusNode();
  final FocusNode noteFocus = FocusNode();
  final FocusNode addNoteFocus = FocusNode();

  //Form Field Keys
  final GlobalKey<FormFieldState<DateTime>> dateTimeKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> accountKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> categoryKey = GlobalKey();
  final GlobalKey<FormFieldState<double>> amountKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> noteKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> addNoteKey = GlobalKey();

  //Form Shaker Keys
  final GlobalKey<ShakeErrorState> formShakerKey = GlobalKey();
  final GlobalKey<ShakeErrorState> accountShakerKey = GlobalKey();
  final GlobalKey<ShakeErrorState> categoryShakerKey = GlobalKey();

  @override
  void initState() {

    isExpanded = widget.inputType == InputType.add 
    ? true 
    : false;

    super.initState();
  }

  @override
  void dispose() {
    dateTimeController.dispose();
    accountController.dispose();
    categoryController.dispose();
    amountController.dispose();
    noteController.dispose();
    addNoteController.dispose();
    super.dispose();
  }
  
  Widget _buildChildrenTiles(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: child is Divider
          ? Divider(
              key: PageStorageKey(child.key),
              height: 0,
              thickness: 1,
            )
          : ListTile(
              title: child,
              key: PageStorageKey(child.key),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.input.formKey,
      child: Column(
        children: [
          ...widget.children.map(_buildChildrenTiles).toList(),
        ],
      ),
    );
  }
}
