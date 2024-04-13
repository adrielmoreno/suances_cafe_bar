import 'package:flutter/material.dart';

import '../../../../domain/entities/task.dart';

enum TypeToDo { tasks, order }

class ToDosProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TypeToDo _todoView = TypeToDo.tasks;

  GlobalKey<FormState> get formKey => _formKey;
  List<Task> get tasks => _tasks;
  TextEditingController get taskController => _taskController;
  TextEditingController get dateController => _dateController;
  DateTime get selectedDate => _selectedDate;
  TypeToDo get todoView => _todoView;

  void _addTask(Task task) {
    _tasks.add(task);
    _tasks.sort((a, b) => a.date.compareTo(b.date));
    resetForm();
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  set selectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  set todoView(TypeToDo value) {
    _todoView = value;
    notifyListeners();
  }

  void setTask() {
    if (_formKey.currentState!.validate()) {
      final task = Task(date: _selectedDate, name: _taskController.text.trim());
      _addTask(task);
    }
  }

  void resetForm() {
    _taskController.clear();
    _selectedDate = DateTime.now();
    _formKey.currentState?.reset();
    notifyListeners();
  }

  void toggleTask(Task task) {
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }
}
