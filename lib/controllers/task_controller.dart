import 'package:dailyflow_prototype_2/database/db_helper.dart';
import 'package:dailyflow_prototype_2/models/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {

  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async{
    return await DbHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DbHelper.query();
    taskList.assignAll(tasks.map((data)=>Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    DbHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id) async {
    await DbHelper.update(id);
    getTasks();
  }

}