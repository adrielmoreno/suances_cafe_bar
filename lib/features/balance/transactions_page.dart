import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/di/inject.dart';
import '../../core/presentation/common/localization/localization_manager.dart';
import '../../core/presentation/common/theme/constants/dimens.dart';
import '../../core/presentation/common/widgets/buttons/custom_appbar.dart';
import 'presentation/pages/expense_list_page.dart';
import 'presentation/pages/expense_page.dart';
import 'presentation/pages/income_list_page.dart';
import 'presentation/pages/income_page.dart';
import 'presentation/providers/transaction_provider.dart';
import 'presentation/viewmodels/expense_view_model.dart';
import 'presentation/viewmodels/income_view_model.dart';
import 'presentation/views/expenses_view.dart';
import 'presentation/views/incomes_view.dart';
import 'presentation/widgets/transaction_option.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({
    super.key,
  });

  static const route = '/transactions';

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final _incomeViewModel = getIt<IncomeViewModel>();
  final _expenseViewModel = getIt<ExpenseViewModel>();

  final _trasactionProvider = getIt<TransactionProvider>();

  @override
  void initState() {
    super.initState();

    _trasactionProvider.addListener(_updateState);

    _incomeViewModel.addListener(_updateState);
    _expenseViewModel.addListener(_updateState);

    if (_incomeViewModel.allItems.isEmpty ||
        _expenseViewModel.allItems.isEmpty) {
      _incomeViewModel.getAll();
      _expenseViewModel.getAll();
    }
  }

  @override
  void dispose() {
    _trasactionProvider.removeListener(_updateState);
    _incomeViewModel.removeListener(_updateState);
    _expenseViewModel.removeListener(_updateState);
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
              // MENU
              const BuildMenu(),
              // ---- Switchs
              const TransactionOption(),
              // ---- Income List
              _incomeViewModel.allItems.isEmpty
                  ? const Center(
                      child:
                          CircularProgressIndicator(), // Loader mientras carga
                    )
                  : Visibility(
                      visible: _trasactionProvider.transactionView ==
                          TypeTransaction.income,
                      child: Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: Dimens.medium,
                          ),
                          child: IncomesView(
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
              _expenseViewModel.allItems.isEmpty
                  ? const Center(
                      child:
                          CircularProgressIndicator(), // Loader mientras carga
                    )
                  : Visibility(
                      visible: _trasactionProvider.transactionView !=
                          TypeTransaction.income,
                      child: Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: Dimens.medium,
                          ),
                          child: ExpensesView(
                            items: _expenseViewModel
                                .groupExpensesByMonth()
                                .entries
                                .map((income) => income.value)
                                .toList(),
                          ),
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

class BuildMenu extends StatelessWidget {
  const BuildMenu({super.key});

  PopupMenuEntry _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return PopupMenuItem(
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: text.transaction,
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert_outlined),
          itemBuilder: (context) => [
            _buildMenuItem(
              context: context,
              icon: Icons.list_alt,
              title: text.income_list,
              iconColor: Colors.blue,
              onTap: () => context.goNamed(IncomeListPage.route),
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.add,
              title: text.new_income,
              iconColor: Colors.green,
              onTap: () => context.pushNamed(IncomePage.route),
            ),
            const PopupMenuDivider(),
            _buildMenuItem(
              context: context,
              icon: Icons.list,
              title: text.expense_list,
              iconColor: Colors.blue,
              onTap: () => context.goNamed(ExpenseListPage.route),
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.add,
              title: text.new_expense,
              iconColor: Colors.red,
              onTap: () => context.pushNamed(ExpensePage.route),
            ),
          ],
        ),
      ],
    );
  }
}
