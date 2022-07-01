import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';

class DBHelper {
  DBHelper._privateConstructor();

  static final DBHelper instance = DBHelper._privateConstructor();

  Future<List<Task>> loadList(String email) async {
    List<Task> taskList = [];
    final userData =
        FirebaseFirestore.instance.collection('collection/users/$email');
    QuerySnapshot querySnapshot = await userData.get();
    List allData = querySnapshot.docs;
    for (dynamic doc in allData) {
      Map<String, dynamic> data = doc.data();
      Task task = Task(
          title: data['title'], isChecked: data['isChecked'], id: data['id']);
      taskList.add(task);
    }
    return taskList;
  }

  Future<String> createTask(Task task, String? email) async {
    final docTask =
        FirebaseFirestore.instance.collection('collection/users/$email').doc();
    final json = task.toJson(task, docTask.id);
    docTask.set(json);
    return docTask.id;
  }

  Future updateTask(Task task, String? email) async {
    final doc =
        FirebaseFirestore.instance.collection('collection/users/$email');
    final json = task.toJson(task, task.id);
    doc.doc(task.id).update(json);
  }

  Future deleteTask(Task task, String? email) async {
    final doc =
        FirebaseFirestore.instance.collection('collection/users/$email');
    doc.doc(task.id).delete();
  }
}
