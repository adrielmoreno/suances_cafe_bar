import 'package:flutter/material.dart';

enum TypeOfSupplier {
  consumer,
  food,
  drink,
  taxes;

  IconData get getIconData => switch (this) {
        consumer => Icons.miscellaneous_services_outlined,
        food => Icons.fastfood_outlined,
        drink => Icons.liquor_outlined,
        taxes => Icons.attach_money,
      };
}

class Supplier {
  String? id;
  final String name;

  final String? cif;
  final String? tel;

  final String? contactName;
  final String? phone;
  final TypeOfSupplier type;

  Supplier({
    this.id,
    required this.name,
    this.cif,
    this.tel,
    this.contactName,
    this.phone,
    required this.type,
  });

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'],
      name: map['name'],
      cif: map['cif'],
      tel: map['tel'],
      contactName: map['contactName'],
      phone: map['phone'],
      type: TypeOfSupplier.values[TypeOfSupplier.values
          .indexWhere((element) => element.name == map['type'])],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cif': cif,
      'tel': tel,
      'contactName': contactName,
      'phone': phone,
      'type': type.name,
    };
  }
}
