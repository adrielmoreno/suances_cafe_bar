import '../../presentation/common/enums/type_of_supplier.dart';

class Supplier {
  final String id;
  final String name;
  final String? cif;
  final String? tel;
  final String? contactName;
  final String? phone;
  final TypeOfSupplier type;

  Supplier({
    required this.id,
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
      type: TypeOfSupplier.values.byName(map['type'] ?? 'food'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cif': cif,
      'tel': tel,
      'contactName': contactName,
      'phone': phone,
      'type': type.name,
    };
  }

  Supplier copyWith({
    String? id,
    String? name,
    String? cif,
    String? tel,
    String? contactName,
    String? phone,
    TypeOfSupplier? type,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      cif: cif ?? this.cif,
      tel: tel ?? this.tel,
      contactName: contactName ?? this.contactName,
      phone: phone ?? this.phone,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Supplier && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
