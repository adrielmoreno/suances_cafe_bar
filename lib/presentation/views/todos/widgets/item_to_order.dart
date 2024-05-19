import 'package:flutter/material.dart';

import '../../../../data/mappable/mappable.dart';
import '../../../../domain/entities/orden.dart';
import '../../../../domain/entities/supplier.dart';
import '../../../../inject/inject.dart';
import '../../../common/theme/constants/dimens.dart';
import '../provider/order_provider.dart';

class ItemToOrder extends StatefulWidget {
  const ItemToOrder({
    super.key,
    required this.order,
  });
  final Order order;

  @override
  State<ItemToOrder> createState() => _ItemToOrderState();
}

class _ItemToOrderState extends State<ItemToOrder> {
  final _orderProvider = getIt<OrderProvider>();
  int quantity = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      quantity = _orderProvider.selectedProducts
          .firstWhere(
              (element) => element.product.id == widget.order.product.id,
              orElse: () => widget.order)
          .quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Checkbox(
            value: _orderProvider.selectedProducts.any(
                (element) => element.product.id == widget.order.product.id),
            onChanged: (value) {
              setState(() {
                value != null && value
                    ? _orderProvider.addSelectedProduct(widget.order)
                    : _orderProvider.removeSelectedProduct(widget.order);
              });
            },
          ),
          title: Text(
            widget.order.product.name,
            style: theme.labelLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.order.product.lastSupplier != null)
              FutureBuilder(
                future: getObjectFromRef(
                    widget.order.product.lastSupplier!, Supplier.fromMap),
                builder: (context, snapshot) {
                  return Expanded(
                    child: Text(
                      snapshot.data?.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.labelSmall,
                    ),
                  );
                },
              ),
            const SizedBox(width: Dimens.semiBig),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.order.product.measure}',
                  style: theme.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  width: Dimens.medium,
                ),

                // Counter
                getButton(
                  onTap: () {
                    setState(() {
                      if (quantity > 0) {
                        quantity--;
                        updateQuantity();
                      }
                    });
                  },
                  icon: Icons.remove,
                ),
                SizedBox(
                  width: Dimens.semiBig,
                  child: Text(
                    '$quantity',
                    style:
                        theme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),

                getButton(
                  onTap: () {
                    setState(() {
                      quantity++;
                      updateQuantity();
                    });
                  },
                  icon: Icons.add,
                ),
              ],
            ),
            const SizedBox(width: Dimens.semiBig),
          ],
        ),
        const Divider()
      ],
    );
  }

  Widget getButton({Function()? onTap, IconData? icon}) {
    final color = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
          color: color.tertiary,
          borderRadius: BorderRadius.circular(Dimens.medium)),
      padding: const EdgeInsets.all(Dimens.extraSmall),
      child: InkWell(
        onTap: onTap,
        child: Icon(icon, color: color.onTertiary),
      ),
    );
  }

  void updateQuantity() {
    if (quantity == 0) {
      _orderProvider.removeSelectedProduct(widget.order);
    } else {
      widget.order.quantity = quantity;
      _orderProvider.addSelectedProduct(widget.order);
    }
  }
}
