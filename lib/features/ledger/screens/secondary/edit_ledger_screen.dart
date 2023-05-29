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
  //Keep track of whether the form is valid
  bool isValid = false;

  // Key to get Scaffold and show bottom sheet.
  // Also a controller to close the bottom sheet when tapped outside
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //Scroll controller for scrolling down
  final ScrollController _scrollController = ScrollController();

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
                                    type: widget.input.type,
                                    setType: (TransactionType newSelection) {
                                      BlocProvider.of<CTransactionCubit>(
                                              context)
                                          .changeTypeWhereIdEquals(
                                              widget.input.id, newSelection);
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
