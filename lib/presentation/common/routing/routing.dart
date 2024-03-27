// keys

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../views/bills/bills_pages.dart';
import '../../views/home/home_page.dart';
import '../../views/metrics/metrics.dart';
import '../../views/receipts/receipts_pages.dart';
import '../../views/suppliers/suppliers_pages.dart';
import '../../views/todos/to_dos_pages.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _metricsKey = GlobalKey<NavigatorState>();
final _receiptsKey = GlobalKey<NavigatorState>();
final _todoKey = GlobalKey<NavigatorState>();
final _billsKey = GlobalKey<NavigatorState>();
final _suppliersKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: MetricsPage.route,
  routes: [
    StatefulShellRoute.indexedStack(
        builder: (context, state, navShell) => HomePage(
              navigationShell: navShell,
            ),
        branches: [
          // ---- Metrics ----
          StatefulShellBranch(
            navigatorKey: _metricsKey,
            routes: [
              GoRoute(
                path: MetricsPage.route,
                parentNavigatorKey: _metricsKey,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MetricsPage(),
                ),
              )
            ],
          ),
          // ---- Receipts ----
          StatefulShellBranch(
            navigatorKey: _receiptsKey,
            routes: [
              GoRoute(
                path: ReceiptsPage.route,
                parentNavigatorKey: _receiptsKey,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ReceiptsPage(),
                ),
              )
            ],
          ),
          // ---- ToDos ----
          StatefulShellBranch(
            navigatorKey: _todoKey,
            routes: [
              GoRoute(
                path: ToDosPage.route,
                parentNavigatorKey: _todoKey,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ToDosPage(),
                ),
              )
            ],
          ),
          // ---- Bills ----
          StatefulShellBranch(
            navigatorKey: _billsKey,
            routes: [
              GoRoute(
                path: BillsPage.route,
                parentNavigatorKey: _billsKey,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: BillsPage(),
                ),
              )
            ],
          ),
          // ---- Supliers ----
          StatefulShellBranch(
            navigatorKey: _suppliersKey,
            routes: [
              GoRoute(
                path: SuppliersPage.route,
                parentNavigatorKey: _suppliersKey,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SuppliersPage(),
                ),
              )
            ],
          ),
        ])
  ],
);
