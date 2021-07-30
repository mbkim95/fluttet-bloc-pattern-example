import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_practice/bloc/todo_bloc.dart';
import 'package:flutter_bloc_practice/bloc/todo_event.dart';
import 'package:flutter_bloc_practice/repository/TodoRepository.dart';

import 'bloc/todo_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => TodoBloc(repository: TodoRepository()),
        child: MaterialApp(title: 'To-Do', home: MyHome()));
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TodoBloc>(context).add(GetListTodoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do App"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          context.read<TodoBloc>().add(CreateTodoEvent(title: controller.text));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: BlocBuilder<TodoBloc, TodoState>(
                builder: (_, state) {
                  if (state is Empty) {
                    return Container();
                  } else if (state is Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is Error) {
                    return Container(
                      child: Text(state.message),
                    );
                  } else if (state is Loaded) {
                    var todos = (state).todos;
                    return ListView.separated(
                        itemBuilder: (_, index) {
                          return Row(
                            children: [
                              Expanded(child: Text(todos[index].title)),
                              GestureDetector(
                                child: Icon(Icons.delete),
                                onTap: () {
                                  context
                                      .read<TodoBloc>()
                                      .add(DeleteTodoEvent(todo: todos[index]));
                                },
                              )
                            ],
                          );
                        },
                        separatorBuilder: (_, index) {
                          return Divider();
                        },
                        itemCount: todos.length);
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
