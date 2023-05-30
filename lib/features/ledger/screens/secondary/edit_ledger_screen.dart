import 'package:budget_buddy/features/ledger/components/inputs/account/account_picker.dart';
import 'package:budget_buddy/features/ledger/components/inputs/category/category_picker.dart';
import 'package:budget_buddy/features/ledger/components/inputs/form_fields/account_from_field.dart';
import 'package:budget_buddy/features/ledger/components/inputs/form_fields/category_account_to_field.dart';
import 'package:budget_buddy/features/ledger/components/inputs/form_fields/date_field.dart';
import 'package:budget_buddy/features/ledger/components/inputs/form_fields/submit_button.dart';
import 'package:budget_buddy/features/ledger/components/inputs/type_picker.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/widgets/ledger_form.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/date_formatter.dart';

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
  PersistentBottomSheetController? _bottomSheetController;

  //Scroll controller for scrolling down
  final ScrollController _scrollController = ScrollController();

  //Controller for the edit page form only
  TextEditingController dateTimeController = TextEditingController();
  TextEditingController accountOrAccountFromController =
      TextEditingController();
  TextEditingController categoryOrAccountToController = TextEditingController();

  //Create temporary state to change it all one shot when user submits
  late TransactionType type;
  late DateTime localDateTime;
  late String accountOrAccountFrom;
  late String categoryOrAccountTo;

  @override
  void initState() {
    setState(() => type = widget.input.type);

    //Date
    setState(() => localDateTime = widget.input.utcDateTime.toLocal());
    dateTimeController.text = dateLongFormatter.format(localDateTime);

    //Account
    setState(() => accountOrAccountFrom = widget.input.accountOrAccountFrom);
    accountOrAccountFromController.text = accountOrAccountFrom;

    //Category
    setState(() => categoryOrAccountTo = widget.input.categoryOrAccountTo);
    categoryOrAccountToController.text = categoryOrAccountTo;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    dateTimeController.dispose();
    accountOrAccountFromController.dispose();
  }

  void _closeBottomSheet() {
    if (_bottomSheetController != null) {
      _bottomSheetController?.close();
    }
    _bottomSheetController = null;
  }

  Future<DateTime?> _selectDate(
      BuildContext context, LedgerInput ledger) async {
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
        setState(
          () {
            localDateTime = selectedDate;
            dateTimeController.text = dateLongFormatter.format(localDateTime);
          },
        );
        //Move focus to account after selecting date
        // _moveFocusTo(ledger.accountOrAccountFromFocus);
        // _selectAccount(ledger, index);
      }
    });
  }

  void _resetDate() {
    setState(() {
      localDateTime = widget.input.utcDateTime.toLocal();
      dateTimeController.text = dateLongFormatter.format(localDateTime);
    });
  }

  void _selectAccount() {
    //To allow initState to call this function and open the account selection
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _bottomSheetController =
            _scaffoldKey.currentState?.showBottomSheet<void>(
          (context) {
            return AccountPicker(
              onPressed: (selectedAccount) {
                if (selectedAccount != null) {
                  //Set value and close the dialog
                  setState(() {
                    accountOrAccountFrom = selectedAccount;
                    accountOrAccountFromController.text = accountOrAccountFrom;
                  });
                }
              },
            );
          },
        );
      },
    );
  }

  void _clearAccount() {
    setState(() {
      accountOrAccountFromController.clear();
      accountOrAccountFrom = accountOrAccountFromController.text;
    });
  }

  void _selectCategory() {
    _bottomSheetController =
        _scaffoldKey.currentState?.showBottomSheet<void>((context) {
      return CategoryPicker(
        isTransfer: (widget.input.type == TransactionType.transfer),
        onPressed: (selectedCategory) {
          if (selectedCategory != null) {
            //Set value and close the dialog
            setState(() {
              categoryOrAccountTo = selectedCategory;
              categoryOrAccountToController.text = categoryOrAccountTo;
            });
            //Move focus to amount input,
            //Then show the keypad
            // _moveFocusTo(input.amountFocus);
            // _selectAmount(input);
            // _scrollToWidget(input.amountKey, scrollAlignment);
          } else {
            _closeBottomSheet();
          }
        },
      );
    });
  }

  void _clearCategory() {
    setState(() {
      categoryOrAccountToController.clear();
      categoryOrAccountTo = categoryOrAccountToController.text;
    });
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
                    builder: (context, state) {
                  return Column(
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
                                controller: dateTimeController,
                                now: localDateTime,
                                onTapTrailing: _resetDate,
                                onTap: () {
                                  _setDate(context);
                                },
                              ),
                              AccountFromField(
                                input: widget.input,
                                controller: accountOrAccountFromController,
                                onTapTrailing: _clearAccount,
                                onTap: _selectAccount,
                              ),
                              CategoryAccountToField(
                                input: widget.input,
                                controller: categoryOrAccountToController,
                                onTapTrailing: _clearCategory,
                                onTap: _selectCategory,
                              ),
                              SubmitButton(
                                action: () {
                                  BlocProvider.of<CTransactionCubit>(context)
                                    ..changeTypeWhereIdEquals(
                                        widget.input.id, type)
                                    ..changeDateTimeWhereIdEquals(
                                        widget.input.id, localDateTime.toUtc())
                                    ..changeAccountFromWhereIdEquals(
                                        widget.input.id, accountOrAccountFrom)
                                    ..changeCategoryWhereIdEquals(
                                        widget.input.id, categoryOrAccountTo);

                                  //Close the bottom sheet if open
                                  _closeBottomSheet();

                                  //Close the snackbar because we are navigating back
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  //Go to previous page
                                  Navigator.of(context).pop();
                                },
                              )
                            ])
                          ],
                        )),
                      ),
                    ],
                  );
                })),
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
