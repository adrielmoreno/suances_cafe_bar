import '../../../products/domain/entities/product.dart';

class Order {
  final Product product;
  int quantity = 0;

  Order({
    required this.product,
  });
}
