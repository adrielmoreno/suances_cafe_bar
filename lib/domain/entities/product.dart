import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? id;
  final String name;
  final double? packaging;
  final String? measure;
  final double? pricePacking;
  final double? priceUnit;
  final double? iva;
  final double? pricePlusIVA;
  final DocumentReference? lastSupplier;

  Product({
    this.id,
    required this.name,
    this.packaging,
    this.measure,
    this.pricePacking,
    this.priceUnit,
    this.lastSupplier,
    this.iva,
    this.pricePlusIVA,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String?,
      name: map['name'] as String,
      packaging: map['packaging'] as double?,
      measure: map['measure'] as String?,
      pricePacking: map['pricePacking'] as double?,
      priceUnit: map['priceUnit'] as double?,
      iva: map['iva'] as double?,
      pricePlusIVA: map['pricePlusIVA'] as double?,
      lastSupplier: map['lastSupplier'] as DocumentReference?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'packaging': packaging ?? 0,
      'measure': measure ?? '',
      'pricePacking': pricePacking ?? 0,
      'priceUnit': priceUnit ?? 0,
      'lastSupplier': lastSupplier,
      'iva': iva,
      'pricePlusIVA': pricePlusIVA,
    };
  }
}
