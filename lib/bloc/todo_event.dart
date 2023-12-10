// todo_event.dart

import 'package:bloc_api_integration/models/todo_model.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final TodoModel todo;
  AddTodo(this.todo);
}

class UpdateTodo extends TodoEvent {
  final TodoModel todo;
  UpdateTodo(this.todo);
}

class DeleteTodo extends TodoEvent {
  final int id;
  DeleteTodo(this.id);
}

class TodoStatusChanged extends TodoEvent {
  final TodoModel todo;
  final bool isChecked;

  TodoStatusChanged(this.todo, this.isChecked);
}

class ReorderTodo extends TodoEvent {
  final int oldIndex;
  final int newIndex;
  final bool isCheckedList;

  ReorderTodo(this.oldIndex, this.newIndex, this.isCheckedList);
}

// You can add more events as per your requirements.
