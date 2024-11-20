import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/di/inject.dart';
import '../../presentation/common/localization/localization_manager.dart';
import '../../presentation/common/theme/constants/dimens.dart';
import '../../presentation/common/widgets/buttons/custom_appbar.dart';
import '../../presentation/common/widgets/indicator/custom_progress_indicator.dart';
import '../expense/presentation/viewmodels/expense_provider.dart';
import '../expense/presentation/views/expenses_view.dart';
import '../incomes/presentation/pages/income_page.dart';
import '../incomes/presentation/viewmodels/income_view_model.dart';
import '../incomes/presentation/views/incomes_view.dart';
import 'provider/transaction_provider.dart';
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
  final _incomeViewModel = getIt<IncomeViewModel>();

  final _expenseProvider = getIt<ExpenseProvider>();
  final _trasactionProvider = getIt<TransactionProvider>();

  @override
  void initState() {
    super.initState();

    _expenseProvider.addListener(_updateState);

    _trasactionProvider.addListener(_updateState);

    _incomeViewModel.addListener(_updateState);

    _incomeViewModel.getAll();
  }

  @override
  void dispose() {
    _expenseProvider.removeListener(_updateState);
    _trasactionProvider.removeListener(_updateState);
    _incomeViewModel.removeListener(_updateState);
    super.dispose();
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
                    child: (_incomeViewModel.isLoading)
                        ? const CustomProgressIndicator()
                        : IncomesView(
                            items: _incomeViewModel
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
                    child: const ExpensesView(),
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
