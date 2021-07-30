import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_practice/bloc/todo_event.dart';
import 'package:flutter_bloc_practice/bloc/todo_state.dart';
import 'package:flutter_bloc_practice/model/todo.dart';
import 'package:flutter_bloc_practice/repository/TodoRepository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc({required this.repository}) : super(Empty());

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is GetListTodoEvent) {
      yield* _mapGetListTodo();
    } else if (event is CreateTodoEvent) {
      yield* _mapCreateTodo(event);
    } else if (event is DeleteTodoEvent) {
      yield* _mapDeleteTodo(event);
    }
  }

  Stream<TodoState> _mapGetListTodo() async* {
    try {
      yield Loading();

      var result = await repository.getTodoList();
      var todos = result.map((e) => Todo.fromJson(e)).toList();

      yield Loaded(todos: todos);
    } catch (e) {
      yield Error(message: e.toString());
    }
  }

  Stream<TodoState> _mapCreateTodo(CreateTodoEvent event) async* {
    try {
      if (state is Loaded) {
        yield Loading();

        var todos = (state as Loaded).todos;

        var newTodo = Todo(
            id: todos[todos.length - 1].id + 1,
            title: event.title,
            createdAt: DateTime.now().toString());

        var result = await repository.createTodo(newTodo);
        var newTodos = [...todos, Todo.fromJson(result)];
        yield Loaded(todos: newTodos);
      }
    } catch (e) {
      yield Error(message: e.toString());
    }
  }

  Stream<TodoState> _mapDeleteTodo(DeleteTodoEvent event) async* {
    try {
      if (state is Loaded) {
        var currentState = state as Loaded;

        yield Loading();

        await repository.deleteTodo(event.todo);

        var newTodos = currentState.todos
            .where((element) => element.id != event.todo.id)
            .toList();
        yield Loaded(todos: newTodos);
      }
    } catch (e) {
      yield Error(message: e.toString());
    }
  }
}
