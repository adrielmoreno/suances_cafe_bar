import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/income.dart';
import '../../../external/inject/inject.dart';
import '../../common/interfaces/resource_state.dart';
import '../../common/localization/localization_manager.dart';
import '../../common/theme/constants/dimens.dart';
import '../../common/widgets/buttons/custom_appbar.dart';
import 'pages/expense/expenses_page.dart';
import 'pages/income/income_page.dart';
import 'pages/income/incomes_page.dart';
import 'provider/expense_provider.dart';
import 'provider/income_provider.dart';
import 'provider/transaction_provider.dart';
import 'view_model/income_view_model.dart';
import 'widgets/transaction_option.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({
    super.key,
  });

  static const route = '/transaction_page';

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final _incomeProvider = getIt<IncomeProvider>();
  final _incomeViewModel = getIt<IncomeViewModel>();

  final _expenseProvider = getIt<ExpenseProvider>();
  final _trasactionProvider = getIt<TransactionProvider>();

  @override
  void initState() {
    super.initState();

    _incomeProvider.addListener(_updateState);

    _expenseProvider.addListener(_updateState);

    _trasactionProvider.addListener(_updateState);

    _incomeViewModel.getAllState.stream.listen((event) {
      switch (event.state) {
        case Status.LOADING:
          // TODO: Implement loading...
          log('Cargando incomes...');
          break;
        case Status.COMPLETED:
          _onProductsChanged(event.data);
          break;
        // TODO: Implement error...
        default:
      }
    });

    _incomeViewModel.getAll();
  }

  @override
  void dispose() {
    _incomeProvider.removeListener(_updateState);

    _expenseProvider.removeListener(_updateState);

    _trasactionProvider.removeListener(_updateState);
    super.dispose();
  }

  _updateState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _onProductsChanged(List<Income> list) {
    _incomeProvider.allItems = list;
    _incomeProvider.filteredItems = list;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              CustomAppBar(
                title: text.transaction,
                actions: [
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert_outlined),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () => context.pushNamed(IncomePage.route),
                        child: const Text("Nueva Ingreso"),
                      ),
                      PopupMenuItem(
                        onTap: () {},
                        child: const Text("Nuevo Gasto"),
                      ),
                    ],
                  ),
                ],
              ),
              // ---- Switchs
              const TransactionOption(),
              // ---- Income List
              Visibility(
                visible: _trasactionProvider.transactionView ==
                    TypeTransaction.income,
                child: Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: Dimens.medium,
                    ),
                    child: IncomesPage(
                      items: _incomeProvider
                          .groupIncomesByMonth()
                          .entries
                          .map((income) => income.value)
                          .toList(),
                    ),
                  ),
                ),
              ),
              // ---- Expenses List
              Visibility(
                visible: _trasactionProvider.transactionView !=
                    TypeTransaction.income,
                child: Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: Dimens.medium,
                    ),
                    child: const ExpensesPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
