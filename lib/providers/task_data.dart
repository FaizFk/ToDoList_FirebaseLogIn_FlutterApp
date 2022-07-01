import 'package:flutter/cupertino.dart';
import 'package:to_do_list_firebase/FirebaseDB/db_helper.dart';
import 'package:to_do_list_firebase/models/task.dart';

class TaskData with ChangeNotifier {
  List<Task> _taskList = [
    //Task(title: 'Long Press to delete'),
  ];

  void getTaskList(String email) async {
    _taskList = await DBHelper.instance.loadList(email);
    notifyListeners();
  }

  List<Task> get taskList {
    return [..._taskList];
  }

  int get tasksLength {
    return _taskList.length;
  }

  void deleteTask(Task task, String email) {
    _taskList.removeWhere((t) => t.title == task.title);
    DBHelper.instance.deleteTask(task, email);
    notifyListeners();
  }

  void addTask(taskTitle, String? email) {
    if (taskTitle != null) {
      Task task = Task(title: taskTitle);
      DBHelper.instance.createTask(task, email).then((id) {
        task.id = id;
        _taskList.add(task);
        notifyListeners();
      });
    }
  }

  void toggleCheckTask(Task task, String email) {
    task.toggleCheck();
    DBHelper.instance.updateTask(task, email);
    notifyListeners();
  }
}
