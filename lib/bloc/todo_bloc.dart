import 'dart:math';

import 'package:bloc_api_integration/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import 'package:bloc_api_integration/services/rest_service.dart';

/// The BLoC class responsible for managing the state and business logic of the Todo feature.
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodosInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<TodoStatusChanged>(_onTodoStatusChanged);
    on<ReorderTodo>(_onReorderTodo);
    on<AddTodo>(_onAddTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  /// Handles the [LoadTodos] event by fetching the todos from the REST service.
  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    try {
      emit(TodosLoadInProgress());
      final todos = await RestService().fetchTodo();
      final checkedCount = todos.where((todo) => todo.completed == true).length;
      final uncheckedCount = todos.length - checkedCount;
      emit(TodosLoadSuccess(todos, checkedCount, uncheckedCount));
    } catch (_) {
      emit(TodoOperationFailure("Failed to load Todos"));
    }
  }

  /// Handles the [ReorderTodo] event by reordering the todos.
  Future<void> _onReorderTodo(
      ReorderTodo event, Emitter<TodoState> emit) async {
    if (state is TodosLoadSuccess) {
      final currentState = state as TodosLoadSuccess;
      final updatedTodos = List<TodoModel>.from(currentState.todos);

      // Reorder logic
      final item = updatedTodos.removeAt(event.oldIndex);
      updatedTodos.insert(event.newIndex, item);
      // Recalculate the counts
      final checkedCount =
          updatedTodos.where((todo) => todo.completed == true).length;
      final uncheckedCount = updatedTodos.length - checkedCount;

      emit(TodosLoadSuccess(updatedTodos, checkedCount, uncheckedCount));
    }
  }

  /// Handles the [TodoStatusChanged] event by updating the status of a todo.
  Future<void> _onTodoStatusChanged(
      TodoStatusChanged event, Emitter<TodoState> emit) async {
    if (state is TodosLoadSuccess) {
      try {
        // Clone the current list of todos
        final List<TodoModel> updatedTodos =
            List.from((state as TodosLoadSuccess).todos);

        // Find the index of the todo to be updated
        final int todoIndex =
            updatedTodos.indexWhere((todo) => todo.id == event.todo.id);
        if (todoIndex != -1) {
          // Update the status of the todo
          updatedTodos[todoIndex] =
              updatedTodos[todoIndex].copyWith(completed: event.isChecked);

          // Emit the new state with updated todos list
          final checkedCount =
              updatedTodos.where((todo) => todo.completed == true).length;
          final uncheckedCount = updatedTodos.length - checkedCount;

          emit(TodosLoadSuccess(updatedTodos, checkedCount, uncheckedCount));
        }
      } catch (e) {
        emit(TodoOperationFailure("Failed to update Todo status"));
      }
    }

    // Implement other event handlers
  }

  /// Handles the [AddTodo] event by adding a new todo.
  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    if (state is TodosLoadSuccess) {
      final currentState = state as TodosLoadSuccess;
      final updatedTodos = List<TodoModel>.from(currentState.todos);

      // Add the new todo
      // Determine the next ID
      final int nextId =
          updatedTodos.fold<int>(0, (maxId, todo) => max(maxId, todo.id ?? 0)) +
              1;
      final checkedCount =
          updatedTodos.where((todo) => todo.completed == true).length;
      final uncheckedCount = updatedTodos.length - checkedCount;

      // Create a new todo with a unique ID
      final newTodo = event.todo.copyWith(id: nextId);
      updatedTodos.insert(0, newTodo);

      emit(TodosLoadSuccess(updatedTodos, checkedCount, uncheckedCount));
    } else {
      // Handle the case where todos are not loaded yet
      emit(TodoOperationFailure("Cannot add Todo at this time"));
    }
  }

  /// Handles the [DeleteTodo] event by deleting a todo.
  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodosLoadSuccess) {
      final currentState = state as TodosLoadSuccess;
      final updatedTodos = List<TodoModel>.from(currentState.todos);

      // Remove the todo with the specified ID
      updatedTodos.removeWhere((todo) => todo.id == event.id);
      final checkedCount =
          updatedTodos.where((todo) => todo.completed == true).length;
      final uncheckedCount = updatedTodos.length - checkedCount;

      emit(TodosLoadSuccess(updatedTodos, checkedCount, uncheckedCount));
    } else {
      // Handle the case where todos are not loaded yet
      emit(TodoOperationFailure("Cannot delete Todo at this time"));
    }
  }
}
