class MonthlyIcome {
  final String id;
  double cash;
  double card;
  double total;

  MonthlyIcome({
    required this.id,
    required this.cash,
    required this.card,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'cash': cash,
      'card': card,
      'total': total,
    };
  }

  factory MonthlyIcome.fromMap(Map<String, dynamic> map) {
    return MonthlyIcome(
      id: map['id'],
      cash: map['cash'],
      card: map['card'],
      total: map['total'],
    );
  }
}
