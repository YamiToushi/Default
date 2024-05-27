import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/task.dart';
import 'package:todo_app/db/task_model.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/utils/colors.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Consumer<TaskProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'tasked',
            style: TextStyle(
              fontFamily: 'iA Writer Quattro',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: RGBColors().primary,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (BuildContext context, int index) {
              return Task(index: index, task: taskProvider.tasks[index]);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: RGBColors().primary,
          onPressed: () => _showAddTaskDialog(context),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: RGBColors().bg,
          title: Text(
            'Add Task',
            style: TextStyle(color: RGBColors().primary),
          ),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: RGBColors().primary),
              ),
            ),
            TextButton(
              onPressed: () {
                final newTask = TaskModel(
                  check: false,
                  title: titleController.text,
                  subtitle: {},
                );
                taskProvider.addTask(newTask);
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: RGBColors().primary),
              ),
            ),
          ],
        );
      },
    );
  }
}
