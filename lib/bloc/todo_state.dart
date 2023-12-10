import 'package:bloc_api_integration/models/todo_model.dart';

abstract class TodoState {}

class TodosInitial extends TodoState {}

class TodosLoadInProgress extends TodoState {}

class TodosLoadSuccess extends TodoState {
  final List<TodoModel> todos;
  TodosLoadSuccess(this.todos);
}

class TodoOperationSuccess extends TodoState {
  final TodoModel todo;
  TodoOperationSuccess(this.todo);
}

class TodoOperationFailure extends TodoState {
  final String error;
  TodoOperationFailure(this.error);
}

class TodosLoadFailure extends TodoState {
  final String message;

  TodosLoadFailure(this.message);
}
