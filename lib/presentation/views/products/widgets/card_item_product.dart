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
    return SizedBox(
      child: Card(
          child: ListTile(
        onTap: () => context.goNamed(ProductPage.route, extra: product),
        leading: Container(
          decoration: BoxDecoration(
            color: AppColors.inversePrimaryLight,
            borderRadius: BorderRadius.circular(Dimens.semiBig),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimens.small),
            child: Text(
                '${LocalDates.getCurrency()} ${product.priceUnit!.toStringAsFixed(2)}'),
          ),
        ),
        title: Text(product.name),
        subtitle: product.lastSupplier != null
            ? FutureBuilder(
                future:
                    getObjectFromRef(product.lastSupplier!, Supplier.fromMap),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data?.name ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                })
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios_outlined,
          size: Dimens.semiBig,
        ),
      )),
    );
  }
}
