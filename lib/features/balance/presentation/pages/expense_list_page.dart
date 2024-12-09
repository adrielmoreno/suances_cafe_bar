import 'package:flutter/material.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/presentation/common/localization/localization_manager.dart';
import '../../../../core/presentation/common/widgets/buttons/custom_appbar.dart';
import '../../../../core/presentation/common/widgets/margins/margin_container.dart';
import '../datasource/expenses_datasource.dart';
import '../viewmodels/expense_view_model.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  static String route = 'expense-list';

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  final _expenseViewModel = getIt<ExpenseViewModel>();

  int _sortColumnIndex = 0;
  bool _isAscending = false;
  late ExpensesDatasource _dataSource;

  @override
  void initState() {
    super.initState();

    _expenseViewModel.addListener(_updateState);

    if (_expenseViewModel.allItems.isEmpty) {
      _expenseViewModel.getAll();
    }

    _dataSource = ExpensesDatasource(context: context);
  }

  @override
  void dispose() {
    _expenseViewModel.removeListener(_updateState);
    super.dispose();
  }

  void _sort(int columnIndex, bool ascending,
      Comparable Function(dynamic expense) getField) {
    _sortColumnIndex = columnIndex;
    _isAscending = ascending;
    _dataSource.sort(getField, ascending);
    _updateState();
  }

  _updateState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            CustomAppBar(
              title: text.expenses,
            ),
            _expenseViewModel.allItems.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(), // Loader mientras carga
                  )
                : MarginContainer(
                    child: PaginatedDataTable(
                      header: const Text("Tabla de Gastos"),
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _isAscending,
                      showEmptyRows: false,
                      columns: [
                        DataColumn(
                          label: const Text("Fecha"),
                          onSort: (columnIndex, ascending) {
                            _sort(
                              columnIndex,
                              ascending,
                              (expense) => expense.createdAt.toDate(),
                            );
                          },
                        ),
                        DataColumn(
                          label: const Text("Total"),
                          onSort: (columnIndex, ascending) {
                            _sort(
                              columnIndex,
                              ascending,
                              (expense) => expense.total,
                            );
                          },
                        ),
                        DataColumn(
                          label: const Text("Categoría"),
                          onSort: (columnIndex, ascending) {
                            _sort(
                              columnIndex,
                              ascending,
                              (expense) => expense.category.getName,
                            );
                          },
                        ),
                        DataColumn(
                          label: const Text("Método de Pago"),
                          onSort: (columnIndex, ascending) {
                            _sort(
                              columnIndex,
                              ascending,
                              (expense) => expense.paymentMethod.getName,
                            );
                          },
                        ),
                        const DataColumn(
                          label: Text("Proveedor"),
                        ),
                        const DataColumn(label: Text("Ticket")),
                        const DataColumn(label: Text("Acciones")),
                      ],
                      source: _dataSource,
                      rowsPerPage: _expenseViewModel.allItems.length >= 31
                          ? 31
                          : _expenseViewModel.allItems.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}