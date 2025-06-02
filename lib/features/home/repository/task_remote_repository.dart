import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager_client/core/utils.dart';
import 'package:task_manager_client/models/task_model.dart';
import 'package:task_manager_client/core/constants/constants.dart';
import 'package:task_manager_client/features/home/repository/task_local_repository.dart';

class TaskRemoteRepository {
  final taskLocalRepository = TaskLocalRepository();

  Future<TaskModel> createTask({
    required String title,
    required String description,
    required String hexColor,
    required String token,
    required String uid,
    required DateTime dueAt,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("${ServerConstant.serverURL}/task/add"),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'hexColor': hexColor,
          'dueAt': dueAt.toIso8601String(),
        }),
      );
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['detail'];
      }
      return TaskModel.fromJson(res.body);
    } catch (e) {
      try {
        final taskModel = TaskModel(
          id: const Uuid().v6(),
          uid: uid,
          title: title,
          description: description,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          dueAt: dueAt,
          color: hexToRgb(hexColor),
          isSynced: 0,
        );
        await taskLocalRepository.insertTask(taskModel);
        return taskModel;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<List<TaskModel>> getTasks({required String token}) async {
    try {
      final res = await http.get(
        Uri.parse("${ServerConstant.serverURL}/task/list"),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['detail'];
      }
      final listOfTasks = jsonDecode(res.body);
      List<TaskModel> tasksList = [];
      for (var elem in listOfTasks) {
        tasksList.add(TaskModel.fromMap(elem));
      }
      await taskLocalRepository.insertTasks(tasksList);
      return tasksList;
    } catch (e) {
      final tasks = await taskLocalRepository.getTasks();
      if (tasks.isNotEmpty) {
        return tasks;
      }
      rethrow;
    }
  }

  Future<bool> syncTasks({
    required String token,
    required List<TaskModel> tasks,
  }) async {
    try {
      final taskListInMap = [];
      for (final task in tasks) {
        taskListInMap.add(task.toMap());
      }
      final res = await http.post(
        Uri.parse("${ServerConstant.serverURL}/task/sync"),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(taskListInMap),
      );
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['detail'];
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
