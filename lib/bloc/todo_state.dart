import 'package:bloc_api_integration/models/todo_model.dart';

/// The base abstract class for all todo states.
abstract class TodoState {}

/// Represents the initial state of todos.
class TodosInitial extends TodoState {}

/// Represents the state when todos are being loaded.
class TodosLoadInProgress extends TodoState {}

/// Represents the state when todos are successfully loaded.
class TodosLoadSuccess extends TodoState {
  final List<TodoModel> todos;
  final int checkedCount;
  final int uncheckedCount;

  /// Constructs a [TodosLoadSuccess] instance with the given [todos], [checkedCount], and [uncheckedCount].
  TodosLoadSuccess(this.todos, this.checkedCount, this.uncheckedCount);
}

/// Represents the state when a todo operation is successful.
class TodoOperationSuccess extends TodoState {
  final TodoModel todo;

  /// Constructs a [TodoOperationSuccess] instance with the given [todo].
  TodoOperationSuccess(this.todo);
}

/// Represents the state when a todo operation fails.
class TodoOperationFailure extends TodoState {
  final String error;

  /// Constructs a [TodoOperationFailure] instance with the given [error].
  TodoOperationFailure(this.error);
}

/// Represents the state when loading todos fails.
class TodosLoadFailure extends TodoState {
  final String message;

  /// Constructs a [TodosLoadFailure] instance with the given [message].
  TodosLoadFailure(this.message);
}

/// Represents the state when the count of checked and unchecked todos is updated.
class TodosCountUpdated extends TodoState {
  final int checkedCount;
  final int uncheckedCount;
  final List<TodoModel> todos;

  /// Constructs a [TodosCountUpdated] instance with the given [checkedCount], [uncheckedCount], and [todos].
  TodosCountUpdated({
    required this.checkedCount,
    required this.uncheckedCount,
    this.todos = const [],
  });
}
