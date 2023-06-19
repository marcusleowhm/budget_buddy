import 'package:budget_buddy/features/data/cubit/account_cubit.dart';
import 'package:budget_buddy/features/data/cubit/inflow_category_cubit.dart';
import 'package:budget_buddy/features/data/cubit/outflow_category_cubit.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/nav/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Insert MultiBlocProvider here
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CTransactionCubit(),
        ),
        BlocProvider(
          create: (_) => AccountCubit()..fetchAccountBalance(),
        ),
        BlocProvider(
          create: (_) => InflowCategoryCubit()..fetchInflowCategories(),
        ),
        BlocProvider(
          create: (_) => OutflowCategoryCubit()..fetchoutflowCategoryGroups(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: goRouter,
      ),
    );
  }
}
