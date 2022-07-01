import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_firebase/providers/auth.dart';
import 'package:to_do_list_firebase/providers/task_data.dart';
import 'package:to_do_list_firebase/screens/login_screen.dart';
import 'package:to_do_list_firebase/widgets/task_tile.dart';

import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  static String id = '/HomeScreen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? email;
  @override
  void initState() {
    super.initState();
    print('Init State HomeScreen...............');
    initializeData();
  }

  void initializeData() async {
    email = await Provider.of<AuthProvider>(context, listen: false).userEmail;
    Provider.of<TaskData>(context, listen: false)
        .getTaskList(email ?? 'angela@gmail.com');
  }

  @override
  Widget build(BuildContext context) {
    print('Remade HomeScreen.............');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (_) {
                print('Opening modal screen');
                return AddTaskScreen();
              });
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${email?.split('@')[0]}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple),
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () async {
                            await auth.signOut();
                            Provider.of<AuthProvider>(context, listen: false)
                                .deleteToken();
                            Navigator.pushNamed(context, LoginScreen.id);
                          },
                          child: const Text('Logout'))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'To Do List',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF9537C1)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${Provider.of<TaskData>(context).tasksLength} tasks',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF9537C1)),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color(0xFF8A3DAE),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 55, left: 35, right: 35, bottom: 55),
                  child:
                      Consumer<TaskData>(builder: (context, taskData, child) {
                    return ListView.builder(
                        itemCount: taskData.tasksLength,
                        itemBuilder: (_, index) {
                          return TaskTile(taskData.taskList[index],
                              email ?? 'angela@gmail.com');
                        });
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
