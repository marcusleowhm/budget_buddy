import 'package:budget_buddy/features/auth/cubit/authentication_cubit.dart';
import 'package:budget_buddy/features/auth/screens/primary/login_screen.dart';
import 'package:budget_buddy/features/configuration/screens/primary/more_screen.dart';
import 'package:budget_buddy/features/configuration/screens/secondary/report_bug_screen.dart';
import 'package:budget_buddy/features/configuration/screens/secondary/user_edit_screen.dart';
import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/screens/primary/balance_screen.dart';
import 'package:budget_buddy/features/data/screens/primary/dashboard_screen.dart';
import 'package:budget_buddy/features/data/screens/primary/statistics_screen.dart';
import 'package:budget_buddy/features/ledger/cubit/u_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/model/ledger_input.dart';
import 'package:budget_buddy/features/ledger/model/transaction_data.dart';
import 'package:budget_buddy/features/ledger/screens/primary/ledger_screen.dart';
import 'package:budget_buddy/features/ledger/screens/secondary/add_ledger_screen.dart';
import 'package:budget_buddy/features/ledger/screens/secondary/edit_ledger_screen.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:budget_buddy/nav/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

//Reference https://codewithandrea.com/articles/flutter-bottom-navigation-bar-nested-routes-gorouter-beamer/
//Add more routes here in the future

final goRouter = GoRouter(
  initialLocation: '/${routes[MainRoutes.dashboard]}',
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, authState) {
            return authState.isLoggedIn
                ? TabNavigator(child: child)
                : const LoginScreen();
          },
        );
      },
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          redirect: (context, state) => '/${routes[MainRoutes.dashboard]}',
        ),
        GoRoute(
          path: '/${routes[MainRoutes.dashboard]}',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardScreen(),
          ),
        ),
        GoRoute(
          path: '/${routes[MainRoutes.statistics]}',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: StatisticsScreen(),
          ),
        ),
        GoRoute(
          path: '/${routes[MainRoutes.ledger]}',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LedgerScreen(),
          ),
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: '${routes[SubRoutes.editLedger]}',
              builder: (context, state) {
                TransactionData data = state.extra as TransactionData;
                return EditLedgerScreen(
                  data: data,
                );
              },
            ),
            GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                path: '${routes[SubRoutes.addledger]}',
                builder: (context, state) {
                  //Used when
                  //1. Duplicating entry from the edit ledger screen
                  //2. Creating new entry from clicking on date of transaction block
                  var extraData = state.extra as Map<String, dynamic>;
                  var inputToClone = extraData['data'];
                  var defaultDateIsToday = extraData['defaultDateIsToday'];
                  return BlocProvider(
                    create: (_) => UTransactionCubit()..addInputRow(),
                    child: AddLedgerScreen(
                      inputToClone: inputToClone != null
                          ? inputToClone as LedgerInput
                          : null,
                      defaultDateIsToday: defaultDateIsToday as bool,
                    ),
                  );
                }),
          ],
        ),
        GoRoute(
          path: '/${routes[MainRoutes.balance]}',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BalanceScreen(),
          ),
        ),
        GoRoute(
          path: '/${routes[MainRoutes.more]}',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MoreScreen(),
          ),
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: '${routes[SubRoutes.useredit]}',
              builder: (context, state) => const UserEditScreen(),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: '${routes[SubRoutes.reportbug]}',
              builder: (context, state) => const ReportBugScreen(),
            )
          ],
        ),
      ],
    ),
  ],
);
