import 'package:flutter/material.dart';

import '../../../../core/presentation/common/extensions/widget_extensions.dart';
import '../../../../core/presentation/common/localization/localization_manager.dart';
import '../../../../core/presentation/common/theme/constants/dimens.dart';
import '../../../../core/presentation/common/widgets/margins/margin_container.dart';
import '../../domain/entities/montly_expense.dart';
import 'amount_icon_text.dart';

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
            expense.id.capitalize(),
            style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Dimens.small),
          Card(
            elevation: 3,
            child: MarginContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AmountIconText(
                          backgroundColor: color.secondaryContainer,
                          iconColor: color.secondary,
                          icon: Icons.money_outlined,
                          text:
                              '${text.label_cash}: ${text.formattedAmount(expense.cash)}',
                        ),
                        const SizedBox(height: Dimens.small),
                        AmountIconText(
                          backgroundColor: color.primaryContainer,
                          iconColor: color.primary,
                          icon: Icons.credit_card_rounded,
                          text:
                              '${text.label_card}: ${text.formattedAmount(expense.card)}',
                        ),
                        const SizedBox(height: Dimens.small),
                        AmountIconText(
                          backgroundColor: color.tertiaryContainer,
                          iconColor: color.tertiary,
                          icon: Icons.account_balance_outlined,
                          text:
                              '${text.transfer}: ${text.formattedAmount(expense.transfer)}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: Dimens.small,
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
                          text.label_total,
                          style: theme.labelLarge?.copyWith(
                              color: color.onPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: Dimens.extraSmall),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            text.formattedAmount(expense.total),
                            style: theme.labelLarge?.copyWith(
                                color: color.onPrimary,
                                fontWeight: FontWeight.bold),
                          ),
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
