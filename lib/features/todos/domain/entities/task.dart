class Errand {
  final String id;
  final DateTime date;
  final String name;
  bool isCompleted;

  Errand({
    required this.id,
    required this.date,
    required this.name,
    this.isCompleted = false,
  });

  factory Errand.fromMap(Map<dynamic, dynamic> map) {
    return Errand(
      id: map['id'],
      date: DateTime.parse(map['date']),
      name: map['name'],
      // sqflite
      isCompleted: map['isCompleted'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'name': name,
      // sqflite
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
