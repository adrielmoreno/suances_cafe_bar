// keys

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/entities/supplier.dart';
import '../../views/balance/balance_page.dart';
import '../../views/home/home_page.dart';
import '../../views/metrics/metrics_page.dart';
import '../../views/products/pages/product_page.dart';
import '../../views/products/products_page.dart';
import '../../views/suppliers/pages/supplier_page.dart';
import '../../views/suppliers/suppliers_page.dart';
import '../../views/todos/to_dos_page.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _metricsKey = GlobalKey<NavigatorState>();
final _balance = GlobalKey<NavigatorState>();
final _todoKey = GlobalKey<NavigatorState>();
final _productsKey = GlobalKey<NavigatorState>();
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
        // ---- Balance ----
        StatefulShellBranch(
          navigatorKey: _balance,
          routes: [
            GoRoute(
              path: BalancePage.route,
              parentNavigatorKey: _balance,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: BalancePage(),
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
        // ---- Products ----
        StatefulShellBranch(
          navigatorKey: _productsKey,
          routes: [
            GoRoute(
              path: ProductsPage.route,
              parentNavigatorKey: _productsKey,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProductsPage(),
              ),
              routes: [
                GoRoute(
                  name: ProductPage.route,
                  path: ProductPage.route,
                  pageBuilder: (context, state) {
                    final data = state.extra as Product?;
                    return NoTransitionPage(
                        child: ProductPage(
                      product: data,
                    ));
                  },
                ),
              ],
            ),
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
              routes: [
                GoRoute(
                    name: SupplierPage.route,
                    path: SupplierPage.route,
                    pageBuilder: (context, state) {
                      final data = state.extra as Supplier?;
                      return NoTransitionPage(
                          child: SupplierPage(
                        supplier: data,
                      ));
                    }),
              ],
            )
          ],
        ),
      ],
    ),
  ],
);
