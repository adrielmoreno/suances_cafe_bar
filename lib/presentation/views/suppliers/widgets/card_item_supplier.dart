import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/supplier.dart';
import '../../../common/theme/constants/dimens.dart';
import '../pages/supplier_page.dart';

class CardItemSuplier extends StatelessWidget {
  const CardItemSuplier({
    super.key,
    required this.supplier,
  });
  final Supplier supplier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return Card(
        child: ListTile(
      dense: true,
      onTap: () => context.goNamed(SupplierPage.route, extra: supplier),
      leading: Container(
        decoration: BoxDecoration(
          color: color.secondaryContainer,
          borderRadius: BorderRadius.circular(Dimens.semiBig),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Dimens.small),
          child: Icon(
            supplier.type.getIconData,
            size: Dimens.medium,
            color: color.primary,
          ),
        ),
      ),
      title: Text(
        supplier.name,
        style: theme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        getFirstNonNullOrEmpty(
          [
            supplier.contactName,
            supplier.tel,
            supplier.phone,
            supplier.cif,
            supplier.type.name,
          ],
        ),
        style: theme.bodySmall,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_outlined,
        size: Dimens.semiBig,
      ),
    ));
  }

  String getFirstNonNullOrEmpty(List<String?> values) {
    for (var value in values) {
      if (value != null && value.isNotEmpty && value.length > 3) {
        return value;
      }
    }
    return "";
  }
}
