import 'package:flutter/material.dart';

import '../../../../core/presentation/common/theme/constants/dimens.dart';
import '../../../../core/presentation/common/widgets/margins/margin_container.dart';
import '../../domain/entities/montly_expense.dart';

class ExpenseMonthItem extends StatelessWidget {
  const ExpenseMonthItem({
    super.key,
    required this.expense,
  });

  final MonthlyExpense expense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return MarginContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            expense.id, // Month label (e.g., "January 2024")
            style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Dimens.small),
          Card(
            elevation: 3,
            child: MarginContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: color.secondaryContainer,
                            child: Icon(Icons.money_outlined,
                                color: color.secondary),
                          ),
                          const SizedBox(width: Dimens.small),
                          Text('Cash: \$${expense.cash.toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: Dimens.small),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: color.primaryContainer,
                            child: Icon(Icons.credit_card_rounded,
                                color: color.primary),
                          ),
                          const SizedBox(width: Dimens.small),
                          Text('Card: \$${expense.card.toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: Dimens.small),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: color.tertiaryContainer,
                            child: Icon(Icons.account_balance_outlined,
                                color: color.tertiary),
                          ),
                          const SizedBox(width: Dimens.small),
                          Text(
                              'Transfer: \$${expense.transfer.toStringAsFixed(2)}'),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimens.small, horizontal: Dimens.semiMedium),
                    decoration: BoxDecoration(
                      color: color.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Total',
                          style: theme.labelLarge?.copyWith(
                              color: color.onPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: Dimens.extraSmall),
                        Text(
                          '\$${(expense.total).toStringAsFixed(2)}',
                          style: theme.labelLarge?.copyWith(
                              color: color.onPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
