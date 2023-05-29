import 'package:budget_buddy/features/ledger/components/inputs/form_fields/date_field.dart';
import 'package:budget_buddy/features/ledger/components/inputs/form_fields/submit_button.dart';
import 'package:budget_buddy/features/ledger/components/inputs/type_picker.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/widgets/ledger_form.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditLedgerScreen extends StatefulWidget {
  const EditLedgerScreen({
    super.key,
    required this.input,
  });

  final LedgerInput input;

  @override
  State<EditLedgerScreen> createState() => _EditLedgerScreenState();
}

class _EditLedgerScreenState extends State<EditLedgerScreen> {
  //Date for the datepicker
  DateTime localNow = DateTime.now();

  //Keep track of whether the form is valid
  bool isValid = false;

  // Key to get Scaffold and show bottom sheet.
  // Also a controller to close the bottom sheet when tapped outside
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PersistentBottomSheetController? _bottomSheetController;

  //Scroll controller for scrolling down
  final ScrollController _scrollController = ScrollController();

  //Create temporary state to change it all one shot when user submits
  late TransactionType type;
  late DateTime localDateTime;

  Future<DateTime?> _selectDate(BuildContext context, LedgerInput ledger) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: ledger.utcDateTime.toLocal(),
      firstDate: DateTime(1970),
      lastDate: localNow.add(
        const Duration(days: 365 * 10),
      ),
    );
    return selectedDate;
  }

  void _setDate(BuildContext context) {
    _selectDate(context, widget.input).then((selectedDate) {
      if (selectedDate != null) {
        //Set value and close the dialog
        setState(() => localDateTime = selectedDate);
        //Move focus to account after selecting date
        // _moveFocusTo(ledger.accountOrAccountFromFocus);
        // _selectAccount(ledger, index);
      }
    });
  }

  void _resetDate() {
    setState(() => localDateTime = widget.input.utcDateTime.toLocal());
  }

  @override
  void initState() {
    setState(() => type = widget.input.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('${titles[SubRoutes.editLedger]}'),
          ),
          backgroundColor: Colors.grey[200], //TODO change color
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
                padding: const EdgeInsets.only(top: 16.0, bottom: 64.0),
                child: BlocBuilder<CTransactionCubit, CTransactionState>(
                  builder: (context, state) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: const BorderRadius.all(
                            //Edit this to change the border radius for the ExpansionTile
                            Radius.circular(0),
                          ),
                        ),
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: Form(
                            child: Column(
                          children: [
                            LedgerForm(ledger: widget.input, children: [
                              TypePicker(
                                type: type,
                                setType: (TransactionType newSelection) {
                                  setState(() => type = newSelection);
                                  // if (_bottomSheetController != null) {
                                  //   _bottomSheetController?.setState!(
                                  //     () {

                                  //     },
                                  //   );
                                  // }
                                },
                              ),
                              DateField(
                                input: widget.input,
                                now: localNow,
                                onTapTrailing: _resetDate,
                                onTap: () {
                                  _setDate(context);
                                },
                              ),
                              SubmitButton(
                                action: () {
                                  BlocProvider.of<CTransactionCubit>(context)
                                      .changeTypeWhereIdEquals(
                                          widget.input.id, type);

                                  //Go to previous page
                                  Navigator.of(context).pop();
                                },
                              )
                            ])
                          ],
                        )),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
      onWillPop: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return Future.value(true);
      },
    );
  }
}
