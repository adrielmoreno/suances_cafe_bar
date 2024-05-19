import 'product.dart';

class Order {
  final Product product;
  int quantity = 0;

  Order({
    required this.product,
  });
}
