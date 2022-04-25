import 'package:get/get.dart';
import 'package:reminder_app/data/db/db_helper.dart';
import 'package:reminder_app/data/entity/task.dart';

class TaskController extends GetxController {
  List<Task> taskList = <Task>[].obs;

  Future<int> addTask({required Task task}) async {
    return await DbHelper.insertDb(task: task);
  }

  Future<void> getAllTask() async {
    final tasks = await DbHelper.getAllTask();
    taskList.assignAll(tasks.map((task) => Task.fromJson(task)).toList());
  }

  Future<int> deleteTask({required Task task}) async {
    final index = await DbHelper.deleteTask(task);
    getAllTask();
    return index;
  }

  Future<int> completedTask({required int id}) async {
    final index = await DbHelper.submitCompletedTask(id);
    getAllTask();
    return index;
  }
}
