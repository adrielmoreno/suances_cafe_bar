class Task {
  final DateTime date;
  final String name;
  bool isCompleted;

  Task({required this.date, required this.name, this.isCompleted = false});
}
