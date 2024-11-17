import 'package:cloud_firestore/cloud_firestore.dart';

class Income {
  String? id;
  final Timestamp date;
  double cash;
  double card;
  double total;
  String urlImgTicket;

  Income({
    this.id,
    required this.date,
    required this.cash,
    required this.card,
    required this.total,
    this.urlImgTicket = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'cash': cash,
      'card': card,
      'total': total,
      'imgTicket': urlImgTicket,
    };
  }

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'] as String?,
      date: map['date'],
      cash: map['cash'],
      card: map['card'],
      total: map['total'],
      urlImgTicket: map['imgTicket'],
    );
  }
}
