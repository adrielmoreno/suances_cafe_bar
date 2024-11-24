import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/data/db_services/firebase_db.dart';
import '../../../../core/presentation/common/enums/payment_method.dart';
import '../../../../core/presentation/common/enums/type_of_expense.dart';
import '../../../suppliers/domain/entities/supplier.dart';

class Expense {
  final String id;
  final Timestamp createdAt;
  final double total;
  final String? urlImgTicket;
  final TypeOfExpense category;
  final PaymentMethod paymentMethod;
  final String? description;
  final DocumentReference<Supplier>? supplier;

  Expense({
    required this.id,
    required this.createdAt,
    required this.total,
    this.urlImgTicket,
    required this.category,
    required this.paymentMethod,
    this.description,
    this.supplier,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'total': total,
      'urlImgTicket': urlImgTicket,
      'category': category.name,
      'paymentMethod': paymentMethod.name,
      'description': description,
      'supplier': supplier,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      createdAt: map['createdAt'],
      total: map['total'],
      urlImgTicket: map['urlImgTicket'],
      category: TypeOfExpense.values.byName(map['category']),
      paymentMethod: PaymentMethod.values.byName(map['paymentMethod']),
      description: map['description'],
      supplier: map['supplier'] != null
          ? getIt<FirebaseDB>().suppliers.doc(map['supplier'].id)
          : null,
    );
  }

  Expense copyWith({
    String? id,
    Timestamp? createdAt,
    double? total,
    String? urlImgTicket,
    TypeOfExpense? category,
    PaymentMethod? paymentMethod,
    String? description,
    DocumentReference<Supplier>? supplier,
  }) {
    return Expense(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      total: total ?? this.total,
      urlImgTicket: urlImgTicket ?? this.urlImgTicket,
      category: category ?? this.category,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      description: description ?? this.description,
      supplier: supplier ?? this.supplier,
    );
  }
}
