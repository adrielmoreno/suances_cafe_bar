import 'package:flutter/material.dart';

import '../../../../domain/entities/income.dart';
import '../../../common/localization/localization_manager.dart';
import '../../../common/theme/constants/dimens.dart';
import '../../../common/widgets/margins/margin_container.dart';

class IncomeMonthItem extends StatelessWidget {
  const IncomeMonthItem({
    super.key,
    required this.income,
  });

  final Income income;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return MarginContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text.month_format(income.date.toDate()),
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
                            child: Icon(Icons.euro_outlined,
                                color: color.secondary),
                          ),
                          const SizedBox(width: Dimens.small),
                          Text('Cash: \$${income.cash.toStringAsFixed(2)}'),
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
                          Text('Card: \$${income.card.toStringAsFixed(2)}'),
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
                          '\$${(income.total).toStringAsFixed(2)}',
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
