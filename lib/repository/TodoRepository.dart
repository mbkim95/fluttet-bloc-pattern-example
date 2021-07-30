import 'package:flutter_bloc_practice/model/todo.dart';

class TodoRepository {
  Future<List<Map<String, dynamic>>> getTodoList() async {
    await Future.delayed(Duration(seconds: 1)); // Network 통신 딜레이 시뮬레이션

    return [
      {
        "id": 1,
        "title": "Flutter Study",
        "createdAt": DateTime.now().toString()
      },
      {
        "id": 2,
        "title": "Android Study",
        "createdAt": DateTime.now().toString()
      },
      {"id": 3, "title": "iOS Study", "createdAt": DateTime.now().toString()}
    ];
  }

  Future<Map<String, dynamic>> createTodo(Todo todo) async {
    await Future.delayed(Duration(seconds: 1)); // Network 통신 딜레이 시뮬레이션

    return todo.toJson();
  }

  Future<Map<String, dynamic>> deleteTodo(Todo todo) async {
    await Future.delayed(Duration(seconds: 1)); // Network 통신 딜레이 시뮬레이션

    return todo.toJson();
  }
}
