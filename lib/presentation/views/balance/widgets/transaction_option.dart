import 'package:flutter/material.dart';

import '../../../../external/inject/inject.dart';
import '../../../common/localization/localization_manager.dart';
import '../../../common/widgets/margins/margin_container.dart';
import '../provider/transaction_provider.dart';

class TransactionOption extends StatefulWidget {
  const TransactionOption({
    super.key,
  });

  @override
  State<TransactionOption> createState() => _TransactionOptionState();
}

class _TransactionOptionState extends State<TransactionOption> {
  final _transactionProvider = getIt<TransactionProvider>();

  @override
  Widget build(BuildContext context) {
    return MarginContainer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SegmentedButton<TypeTransaction>(
              selected: <TypeTransaction>{_transactionProvider.transactionView},
              segments: [
                ButtonSegment(
                  value: TypeTransaction.income,
                  label: Text(text.incomes),
                  icon: const Icon(Icons.trending_up_outlined),
                ),
                ButtonSegment(
                  value: TypeTransaction.expense,
                  label: Text(text.expenses),
                  icon: const Icon(Icons.trending_down_outlined),
                ),
              ],
              onSelectionChanged: (value) => setState(() {
                _transactionProvider.transactionView = value.first;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
