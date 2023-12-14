import 'package:bloc_api_integration/bloc/task_event.dart';
import 'package:bloc_api_integration/bloc/task_state.dart';
import 'package:bloc_api_integration/models/todo_model.dart';
import 'package:bloc_api_integration/services/data.dart';
import 'package:bloc_api_integration/services/rest_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    /// Event handler for loading tasks.
    /// Fetches tasks and associated todos from the REST service.
    /// Merges the fetched todos with the existing todos for each task.
    /// Emits a [TasksLoadSuccess] event with the updated tasks.
    on<LoadTasks>((event, emit) async {
      List<TodoModel> fetchedTodos = await RestService().fetchTodo();
      final tasks = TaskData().tasks;
      for (var task in tasks) {
        List<TodoModel> existingTodos = task['todos'];
        task['todos'] = List<TodoModel>.from(existingTodos)
          ..addAll(fetchedTodos);
      }
      emit(TasksLoadSuccess(tasks));
    });

    /// Event handler for adding a new task.
    /// If the current state is [TasksLoadSuccess], a new task is added to the list of tasks.
    /// The new task contains the title, progress, task count, image, and an empty list of todos.
    /// The updated list of tasks is then emitted as [TaskAdditionSuccess].
    on<AddTask>((event, emit) {
      if (state is TasksLoadSuccess) {
        final currentState = state as TasksLoadSuccess;

        Map<String, dynamic> newTaskWithEmptyTodos = {
          'title': event.newTask['title'],
          'progress': event.newTask['progress'],
          'taskCount': event.newTask['taskCount'],
          'image': event.newTask['image'],
          'todos': <TodoModel>[], // Empty todos list
        };
        final updatedTasks = List<Map<String, dynamic>>.from(currentState.tasks)
          ..add(newTaskWithEmptyTodos);
        emit(TaskAdditionSuccess(updatedTasks));
      }
    });

    /// Handles the [InitiateSearch] event and transitions to a state that indicates the search mode is active.
    on<InitiateSearch>((event, emit) {
      emit(TasksLoadSuccess((state as TasksLoadSuccess).tasks));
    });

    /// Handles the [ClearSearch] event and re-emits [TasksLoadSuccess] with the original tasks list if the current state is [TasksLoadSuccess].
    on<ClearSearch>((event, emit) {
      if (state is TasksLoadSuccess) {
        emit(TasksLoadSuccess((state as TasksLoadSuccess).tasks));
      }
    });

    /// Handles the [SearchTasks] event and performs a search based on the provided query.
    /// If the current state is [TasksLoadSuccess], it searches within the original tasks list.
    /// If the current state is [TasksSearchSuccess], it searches within the search results.
    /// If the current state is neither [TasksLoadSuccess] nor [TasksSearchSuccess], it returns without performing any search.
    on<SearchTasks>((event, emit) async {
      List<Map<String, dynamic>> tasks;
      final query = event.query.toLowerCase().trim();
      if (state is TasksLoadSuccess) {
        tasks = (state as TasksLoadSuccess).tasks;
      } else if (state is TasksSearchSuccess) {
        tasks = (state as TasksSearchSuccess).tasks;
      } else {
        // Handle other state types if needed or return
        return;
      }
      final searchResults = tasks.where((task) {
        String titleLower = task['title'].toString().toLowerCase();
        return titleLower.contains(query);
      }).toList();

      if (searchResults.isNotEmpty) {
        emit(TasksSearchSuccess(searchResults));
      } else {
        emit(TasksSearchEmpty());
      }
    });
  }
}
