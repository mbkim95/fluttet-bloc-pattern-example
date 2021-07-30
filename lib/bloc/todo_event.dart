import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_practice/model/todo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
abstract class TodoEvent extends Equatable {}

class GetListTodoEvent extends TodoEvent {
  @override
  List<Object?> get props => [];
}

class CreateTodoEvent extends TodoEvent {
  final String title;

  CreateTodoEvent({required this.title});

  @override
  List<Object?> get props => [title];
}

class DeleteTodoEvent extends TodoEvent {
  final Todo todo;

  DeleteTodoEvent({required this.todo});

  @override
  List<Object?> get props => [todo];
}
