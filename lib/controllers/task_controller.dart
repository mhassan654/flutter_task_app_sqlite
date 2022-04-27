import 'package:todo_using_sqlite/db_helper.dart';
import 'package:todo_using_sqlite/models/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController{

  var taskList = <Task>[].obs;


  //insert / add new task
  Future<int> addTask({Task? task}) async
  {
    return await DBHelper.insert(task!);
  }

  // get all the data from table
  void getTasks()async{
      List<Map<String, dynamic>> tasks = await DBHelper.query();
      taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void delete(Task task)
  {
      DBHelper.delete(task);
      getTasks();
  }

  void markTaskComplete(int id)async
  {
    await DBHelper.update(id);
    getTasks();
  }

}