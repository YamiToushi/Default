import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/db/task_model.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/utils/colors.dart';

class Task extends StatelessWidget {
  final int index;
  final TaskModel task;

  const Task({required this.index, required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final TextEditingController subTaskController = TextEditingController();

    return Consumer<TaskProvider>(
      builder: (context, value, child) => ExpansionTile(
        trailing: const SizedBox.shrink(),
        backgroundColor: RGBColors().inactive,
        shape: const Border(),
        title: Row(
          children: [
            Checkbox(
              value: task.check,
              onChanged: (bool? value) {
                task.check = value ?? false;
                taskProvider.updateTask(index, task);
              },
              fillColor: WidgetStatePropertyAll(RGBColors().checkbox),
              side: BorderSide(color: RGBColors().checkbox),
            ),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  decoration: task.check ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: RGBColors().primary,
              ),
              onPressed: () {
                taskProvider.deleteTask(index);
              },
            ),
          ],
        ),
        children: [
          for (var sub in task.subtitle.entries)
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Row(
                children: [
                  Checkbox(
                    shape: const CircleBorder(),
                    fillColor: WidgetStatePropertyAll(RGBColors().inactive),
                    checkColor: RGBColors().primary,
                    side: BorderSide(color: RGBColors().checkbox),
                    value: sub.value,
                    onChanged: (bool? value) {
                      task.subtitle[sub.key] = value ?? false;
                      taskProvider.updateTask(index, task);
                    },
                  ),
                  Expanded(
                    child: Text(
                      sub.key,
                      style: TextStyle(
                        decoration: sub.value ? TextDecoration.lineThrough : TextDecoration.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: RGBColors().primary,
                    ),
                    onPressed: () {
                      taskProvider.deleteSubTask(index, sub.key);
                    },
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 60.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: subTaskController,
                    decoration: InputDecoration(
                      labelText: 'Add Subtask',
                      labelStyle: TextStyle(color: RGBColors().primary),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: RGBColors().primary),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: RGBColors().primary),
                      ),
                    ),
                    cursorColor: RGBColors().primary,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: RGBColors().primary,
                  ),
                  onPressed: () {
                    if (subTaskController.text.isNotEmpty) {
                      taskProvider.addSubTask(index, subTaskController.text);
                      subTaskController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
