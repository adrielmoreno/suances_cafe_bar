class MonthlyExpense {
  final String id;
  double cash;
  double card;
  double transfer;
  double total;

  MonthlyExpense({
    required this.id,
    required this.cash,
    required this.card,
    required this.transfer,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cash': cash,
      'card': card,
      'transfer': transfer,
      'total': total,
    };
  }

  factory MonthlyExpense.fromMap(Map<String, dynamic> map) {
    return MonthlyExpense(
      id: map['id'],
      cash: map['cash'] ?? 0.0,
      card: map['card'] ?? 0.0,
      transfer: map['transfer'] ?? 0.0,
      total: map['total'] ?? 0.0,
    );
  }

  void updateTotals() {
    total = cash + card + transfer;
  }
}
