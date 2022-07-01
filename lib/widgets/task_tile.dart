import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_firebase/providers/auth.dart';
import 'package:to_do_list_firebase/providers/task_data.dart';

import '../models/task.dart';

class TaskTile extends StatelessWidget {
  Task task;
  String email;
  TaskTile(this.task, this.email);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        showDialog<void>(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('Delete Task'),
                actions: [
                  TextButton(
                      onPressed: () async {
                        Provider.of<TaskData>(context, listen: false)
                            .deleteTask(task, email);
                        Navigator.pop(context);
                      },
                      child: Text('Yes')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No')),
                ],
              );
            });
      },
      title: Text(task.title,
          style: TextStyle(
              color: Colors.white,
              decoration: task.isChecked
                  ? TextDecoration.lineThrough
                  : TextDecoration.none)),
      trailing: Checkbox(
        value: task.isChecked,
        onChanged: (value) async {
          Provider.of<TaskData>(context, listen: false)
              .toggleCheckTask(task, email);
        },
      ),
    );
  }
}
