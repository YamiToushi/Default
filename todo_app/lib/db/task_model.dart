import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  bool check;

  @HiveField(1)
  String title;

  @HiveField(2)
  Map<String, bool> subtitle;

  TaskModel({required this.check, required this.title, required this.subtitle});
}
