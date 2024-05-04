import 'package:flutter/material.dart';

import '../../../../data/db_services/local_db.dart';
import '../../../../domain/entities/task.dart';
import '../../../../inject/inject.dart';

enum TypeToDo { errand, order }

class ToDosProvider extends ChangeNotifier {
  // Sqflite
  final _db = getIt<LocalDB>();

  List<Errand> _tasks = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TypeToDo _todoView = TypeToDo.errand;

  GlobalKey<FormState> get formKey => _formKey;
  List<Errand> get tasks => _tasks;
  TextEditingController get taskController => _taskController;
  TextEditingController get dateController => _dateController;
  DateTime get selectedDate => _selectedDate;
  TypeToDo get todoView => _todoView;

  void _addTask(Errand task) {
    _db.insert(TypeToDo.errand.name, task.toMap()).then((value) {
      task.id = value;
      _tasks.add(task);
      sortTasksByDate();
    });
    resetForm();
    notifyListeners();
  }

  void removeTask(Errand task) {
    _db
        .delete(TypeToDo.errand.name, task.id!)
        .then((value) => _tasks.remove(task));
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

  set stask(List<Errand> values) {
    _tasks = values;
    notifyListeners();
  }

  void setTask() {
    if (_formKey.currentState!.validate()) {
      final task =
          Errand(date: _selectedDate, name: _taskController.text.trim());
      _addTask(task);
    }
  }

  void resetForm() {
    _taskController.clear();
    _selectedDate = DateTime.now();
    _formKey.currentState?.reset();
    notifyListeners();
  }

  void toggleTask(Errand task) {
    task.isCompleted = !task.isCompleted;
    _db.update(TypeToDo.errand.name, task.toMap(), task.id!);
    notifyListeners();
  }

  // sqflite
  Future<void> loadDB() async {
    final results = await _db.queryAll(TypeToDo.errand.name);
    _tasks = results?.map((e) => Errand.fromMap(e)).toList() ?? [];
    sortTasksByDate();
    notifyListeners();
  }

  void sortTasksByDate() {
    _tasks.sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }
}
