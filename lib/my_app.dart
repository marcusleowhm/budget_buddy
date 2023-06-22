import 'package:budget_buddy/env.dart';
import 'package:budget_buddy/features/auth/cubit/authentication_cubit.dart';
import 'package:budget_buddy/features/configuration/cubit/account_cubit.dart';
import 'package:budget_buddy/features/configuration/cubit/category_cubit.dart';
import 'package:budget_buddy/features/ledger/cubit/c_transaction_cubit.dart';
import 'package:budget_buddy/nav/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Insert MultiBlocProvider here
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthenticationCubit(),
        ),
        BlocProvider(
          create: (_) => CTransactionCubit(),
        ),
        BlocProvider(
          create: (_) => AccountCubit()..fetchAccountBalance(),
        ),
        BlocProvider(
          create: (_) => CategoryCubit()..fetchCategories(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner:
            (AppEnvironment.environment == Environment.local ||
                    AppEnvironment.environment == Environment.dev)
                ? true
                : false,
        routerConfig: goRouter,
      ),
    );
  }
}
