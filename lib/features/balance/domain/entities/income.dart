import 'package:cloud_firestore/cloud_firestore.dart';

class Income {
  final String id;
  final Timestamp createdAt;
  final double cash;
  final double card;
  final double total;
  final String? urlImgTicket;

  Income({
    required this.id,
    required this.createdAt,
    required this.cash,
    required this.card,
    required this.total,
    this.urlImgTicket,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'cash': cash,
      'card': card,
      'total': total,
      'imgTicket': urlImgTicket,
    };
  }

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'],
      createdAt: map['createdAt'],
      cash: map['cash'].toDouble(),
      card: map['card'].toDouble(),
      total: map['total'].toDouble(),
      urlImgTicket: map['imgTicket'],
    );
  }

  Income copyWith({
    String? id,
    Timestamp? createdAt,
    double? cash,
    double? card,
    double? total,
    String? urlImgTicket,
  }) {
    return Income(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      cash: cash ?? this.cash,
      card: card ?? this.card,
      total: total ?? this.total,
      urlImgTicket: urlImgTicket ?? this.urlImgTicket,
    );
  }
}
