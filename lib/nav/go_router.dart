import 'package:budget_buddy/features/configuration/screens/primary/more_screen.dart';
import 'package:budget_buddy/features/configuration/screens/secondary/report_bug_screen.dart';
import 'package:budget_buddy/features/configuration/screens/secondary/user_edit_screen.dart';
import 'package:budget_buddy/features/data/screens/balance_screen.dart';
import 'package:budget_buddy/features/data/screens/dashboard_screen.dart';
import 'package:budget_buddy/features/data/screens/statistics_screen.dart';
import 'package:budget_buddy/features/ledger/screens/primary/ledger_screen.dart';
import 'package:budget_buddy/features/ledger/screens/secondary/add_ledger_screen.dart';
import 'package:budget_buddy/nav/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

//Reference https://codewithandrea.com/articles/flutter-bottom-navigation-bar-nested-routes-gorouter-beamer/
//Add more routes here in the future
final goRouter = GoRouter(
  initialLocation: '/dashboard',
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return TabNavigator(child: child);
      },
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          redirect: (context, sttate) => '/dashboard',
        ),
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardScreen(),
          ),
        ),
        GoRoute(
          path: '/statistics',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: StatisticsScreen(),
          ),
        ),
        GoRoute(
          path: '/ledger',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LedgerScreen(),
          ),
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: 'add',
              builder: (context, state) => const AddLedgerScreen(),
            )
          ],
        ),
        GoRoute(
          path: '/balance',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BalanceScreen(),
          ),
        ),
        GoRoute(
          path: '/more',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MoreScreen(),
          ),
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: 'useredit',
              builder: (context, state) => const UserEditScreen(),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: 'reportbug',
              builder: (context, state) => const ReportBugScreen(),
            )
          ],
        ),
      ],
    ),
  ],
);
