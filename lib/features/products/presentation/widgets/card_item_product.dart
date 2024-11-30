import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/common/localization/localization_manager.dart';
import '../../../../core/presentation/common/theme/constants/app_colors.dart';
import '../../../../core/presentation/common/theme/constants/dimens.dart';
import '../../domain/entities/product.dart';
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
          child: Container(
            padding: const EdgeInsets.all(Dimens.small),
            width: Dimens.giant,
            child: Text(
              text.formattedAmount(product.pricePlusIVA),
              style: theme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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
                future: product.lastSupplier?.get(),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data?.data()?.name ?? "",
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
