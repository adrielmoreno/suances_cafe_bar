enum TypeOfSupplier { consumer, food, taxes }

class Supplier {
  final String? id;
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
      'id': id,
      'name': name,
      'cif': cif,
      'tel': tel,
      'contactName': contactName,
      'phone': phone,
      'type': TypeOfSupplier.values[type.index].name,
    };
  }

  List<Map<String, dynamic>> suppliersToMap(List<Supplier> suppliers) {
    return suppliers.map((supplier) => supplier.toMap()).toList();
  }

  List<Supplier> suppliersFromMap(List<Map<String, dynamic>> maps) {
    return maps.map((map) => Supplier.fromMap(map)).toList();
  }
}
