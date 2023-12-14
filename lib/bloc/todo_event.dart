// todo_event.dart

import 'package:bloc_api_integration/models/todo_model.dart';

/// The base class for all todo events.
abstract class TodoEvent {}

/// An event to load todos.
class LoadTodos extends TodoEvent {}

/// An event to add a new todo.
class AddTodo extends TodoEvent {
  final TodoModel todo;
  AddTodo(this.todo);
}

/// An event to update an existing todo.
class UpdateTodo extends TodoEvent {
  final TodoModel todo;
  UpdateTodo(this.todo);
}

/// An event to delete a todo by its ID.
class DeleteTodo extends TodoEvent {
  final int id;
  DeleteTodo(this.id);
}

/// An event to change the status of a todo.
class TodoStatusChanged extends TodoEvent {
  final TodoModel todo;
  final bool isChecked;

  TodoStatusChanged(this.todo, this.isChecked);
}

/// An event to reorder todos.
class ReorderTodo extends TodoEvent {
  final int oldIndex;
  final int newIndex;
  final bool isCheckedList;

  ReorderTodo(this.oldIndex, this.newIndex, this.isCheckedList);
}

// You can add more events as per your requirements.
