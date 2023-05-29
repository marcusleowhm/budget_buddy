import 'package:budget_buddy/features/configuration/screens/primary/more_screen.dart';
import 'package:budget_buddy/features/configuration/screens/secondary/report_bug_screen.dart';
import 'package:budget_buddy/features/configuration/screens/secondary/user_edit_screen.dart';
import 'package:budget_buddy/features/data/screens/balance_screen.dart';
import 'package:budget_buddy/features/data/screens/dashboard_screen.dart';
import 'package:budget_buddy/features/data/screens/statistics_screen.dart';
import 'package:budget_buddy/features/ledger/cubit/u_transaction_cubit.dart';
import 'package:budget_buddy/features/ledger/screens/primary/ledger_screen.dart';
import 'package:budget_buddy/features/ledger/screens/secondary/add_ledger_screen.dart';
import 'package:budget_buddy/features/ledger/screens/secondary/edit_ledger_screen.dart';
import 'package:budget_buddy/nav/routes.dart';
import 'package:budget_buddy/nav/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/ledger/model/ledger_input.dart';

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
      builder: (context, state, child) => TabNavigator(child: child),
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
                LedgerInput input = state.extra as LedgerInput;
                return EditLedgerScreen(
                  input: input,
                );
              },
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: '${routes[SubRoutes.addledger]}',
              builder: (context, state) => BlocProvider(
                create: (_) => UTransactionCubit()..addInputRow(),
                child: const AddLedgerScreen(),
              ),
            ),
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
