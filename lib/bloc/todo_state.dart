import 'package:bloc_api_integration/models/todo_model.dart';

abstract class TodoState {}

class TodosInitial extends TodoState {}

class TodosLoadInProgress extends TodoState {}

class TodosLoadSuccess extends TodoState {
  final List<TodoModel> todos;
  final int checkedCount;
  final int uncheckedCount;
  TodosLoadSuccess(this.todos, this.checkedCount, this.uncheckedCount);
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

class TodosCountUpdated extends TodoState {
  final int checkedCount;
  final int uncheckedCount;
  final List<TodoModel> todos;

  TodosCountUpdated(
      {required this.checkedCount,
      required this.uncheckedCount,
      this.todos = const []});
}
