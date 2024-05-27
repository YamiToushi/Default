import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/db/task_model.dart';

class TaskProvider extends ChangeNotifier {
  late Box<TaskModel> _taskBox;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  List<TaskModel> get tasks => _isInitialized ? _taskBox.values.toList() : [];

  TaskProvider() {
    _initializeBox();
  }

  Future<void> _initializeBox() async {
    _taskBox = await Hive.openBox<TaskModel>('tasks');
    _isInitialized = true;
    notifyListeners();
  }

  void addTask(TaskModel task) {
    if (_isInitialized) {
      _taskBox.add(task);
      notifyListeners();
    }
  }

  void deleteTask(int index) {
    if (_isInitialized) {
      _taskBox.deleteAt(index);
      notifyListeners();
    }
  }

  void updateTask(int index, TaskModel task) {
    if (_isInitialized) {
      _taskBox.putAt(index, task);
      notifyListeners();
    }
  }

  void addSubTask(int taskIndex, String subTaskTitle) {
    if (_isInitialized) {
      var task = _taskBox.getAt(taskIndex);
      if (task != null) {
        task.subtitle[subTaskTitle] = false;
        updateTask(taskIndex, task);
        notifyListeners();
      }
    }
  }

  void deleteSubTask(int taskIndex, String subTaskTitle) {
    if (_isInitialized) {
      var task = _taskBox.getAt(taskIndex);
      if (task != null) {
        task.subtitle.remove(subTaskTitle);
        updateTask(taskIndex, task);
        notifyListeners();
      }
    }
  }
}
