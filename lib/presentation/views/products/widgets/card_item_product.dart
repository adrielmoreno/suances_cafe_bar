import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/mappable/mappable.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/supplier.dart';
import '../../../common/theme/constants/app_colors.dart';
import '../../../common/theme/constants/dimens.dart';
import '../../../common/utils/local_dates.dart';
import '../pages/product_page.dart';

class CardItemProduct extends StatelessWidget {
  const CardItemProduct({
    super.key,
    required this.product,
  });
  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Card(
      child: ListTile(
        dense: true,
        onTap: () => context.goNamed(ProductPage.route, extra: product),
        trailing: Container(
          decoration: BoxDecoration(
            color: AppColors.inversePrimaryLight,
            borderRadius: BorderRadius.circular(Dimens.semiBig),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimens.small),
            child: Text(
              '${LocalDates.getCurrency()} ${product.pricePlusIVA!.toStringAsFixed(2)}',
              style: theme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Text(
          product.name,
          style: theme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: product.lastSupplier != null
            ? FutureBuilder(
                future:
                    getObjectFromRef(product.lastSupplier!, Supplier.fromMap),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data?.name ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.labelSmall,
                  );
                })
            : null,
      ),
    );
  }
}
