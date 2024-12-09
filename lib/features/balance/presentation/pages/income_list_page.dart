import 'package:flutter/material.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/presentation/common/localization/localization_manager.dart';
import '../../../../core/presentation/common/widgets/buttons/custom_appbar.dart';
import '../../../../core/presentation/common/widgets/margins/margin_container.dart';
import '../../domain/entities/income.dart';
import '../datasource/incomes_datasource.dart';
import '../viewmodels/income_view_model.dart';

class IncomeListPage extends StatefulWidget {
  const IncomeListPage({super.key});
  static String route = 'incomes-list';

  @override
  State<IncomeListPage> createState() => _IncomeListPageState();
}

class _IncomeListPageState extends State<IncomeListPage> {
  final _incomeViewModel = getIt<IncomeViewModel>();
  int _sortColumnIndex = 0;
  bool _isAscending = false;
  late IncomesDatasource _dataSource;

  @override
  void initState() {
    super.initState();

    _incomeViewModel.addListener(_updateState);

    if (_incomeViewModel.allItems.isEmpty) {
      _incomeViewModel.getAll();
    }

    _dataSource = IncomesDatasource(context: context);
  }

  @override
  void dispose() {
    _incomeViewModel.removeListener(_updateState);
    super.dispose();
  }

  void _sort(int columnIndex, bool ascending,
      Comparable Function(Income income) getField) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _isAscending = ascending;
      _dataSource.sort(getField, ascending);
    });
  }

  _updateState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            CustomAppBar(
              title: text.incomes,
            ),
            _incomeViewModel.allItems.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : MarginContainer(
                    child: PaginatedDataTable(
                      header: Text(text.column_date),
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _isAscending,
                      showEmptyRows: false,
                      columns: [
                        DataColumn(
                          label: Text(text.column_date),
                          onSort: (columnIndex, ascending) {
                            _sort(
                              columnIndex,
                              ascending,
                              (income) => income.createdAt.toDate(),
                            );
                          },
                        ),
                        DataColumn(
                          label: Text(text.column_total),
                          onSort: (columnIndex, ascending) {
                            _sort(
                              columnIndex,
                              ascending,
                              (income) => income.total,
                            );
                          },
                        ),
                        DataColumn(
                          label: Text(text.column_card),
                          onSort: (columnIndex, ascending) {
                            _sort(
                              columnIndex,
                              ascending,
                              (income) => income.card,
                            );
                          },
                        ),
                        DataColumn(
                          label: Text(text.column_cash),
                          onSort: (columnIndex, ascending) {
                            _sort(
                              columnIndex,
                              ascending,
                              (income) => income.cash,
                            );
                          },
                        ),
                        DataColumn(label: Text(text.column_ticket)),
                        DataColumn(label: Text(text.column_actions)),
                      ],
                      source: _dataSource,
                      rowsPerPage: _incomeViewModel.allItems.length >= 31
                          ? 31
                          : _incomeViewModel.allItems.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
