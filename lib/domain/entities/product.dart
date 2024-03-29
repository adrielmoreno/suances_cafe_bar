class Product {
  final String? id;
  final String name;
  final int? packaging;
  final String? measure;
  final double? pricePacking;
  final double? priceUnit;
  final String? lastSupplier;

  Product({
    this.id,
    required this.name,
    this.packaging,
    this.measure,
    this.pricePacking,
    this.priceUnit,
    this.lastSupplier,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String?,
      name: map['name'] as String,
      packaging: map['packaging'] as int?,
      measure: map['measure'] as String?,
      pricePacking: map['pricePacking'] as double?,
      priceUnit: map['priceUnit'] as double?,
      lastSupplier: map['lastSupplier'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'packaging': packaging ?? 0,
      'measure': measure ?? '',
      'pricePacking': pricePacking ?? 0,
      'priceUnit': priceUnit ?? 0,
      'lastSupplier': lastSupplier ?? '',
    };
  }

  List<Map<String, dynamic>> productsToMap(List<Product> products) {
    return products.map((product) => product.toMap()).toList();
  }

  List<Product> productsFromMap(List<Map<String, dynamic>> maps) {
    return maps.map((map) => Product.fromMap(map)).toList();
  }
}
