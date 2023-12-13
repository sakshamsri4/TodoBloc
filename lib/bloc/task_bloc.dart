import 'package:bloc_api_integration/bloc/task_event.dart';
import 'package:bloc_api_integration/bloc/task_state.dart';
import 'package:bloc_api_integration/models/todo_model.dart';
import 'package:bloc_api_integration/services/rest_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      // Fetch tasks and associated todos
      List<TodoModel> fetchedTodos = await RestService().fetchTodo();
      final tasks = await fetchTasksWithTodos();
      for (var task in tasks) {
        List<TodoModel> existingTodos = task['todos'];
        task['todos'] = List<TodoModel>.from(existingTodos)
          ..addAll(fetchedTodos);
      }
      emit(TasksLoadSuccess(tasks));
    });
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
          //    ..add(event.newTask);
          ..add(newTaskWithEmptyTodos);
        emit(TaskAdditionSuccess(updatedTasks));
      }
    });

    on<InitiateSearch>((event, emit) {
      // Transition to a state that indicates the search mode is active
      emit(TasksLoadSuccess((state as TasksLoadSuccess).tasks));
    });

    on<ClearSearch>((event, emit) {
      debugPrint(state.toString());
      if (state is TasksLoadSuccess) {
        // Re-emit TasksLoadSuccess with the original tasks list
        emit(TasksLoadSuccess((state as TasksLoadSuccess).tasks));
      }
    });
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
        // Convert the entire task title to lowercase for comparison
        String titleLower = task['title'].toString().toLowerCase();
        // Check if the entire query string is a substring of the title
        return titleLower.contains(query);
      }).toList();

      debugPrint('query: $query');

      debugPrint("searchResults ${searchResults.toString()}");
      if (searchResults.isNotEmpty) {
        emit(TasksSearchSuccess(searchResults));
      } else {
        emit(TasksSearchEmpty());
      }
    });
  }

  Future<List<Map<String, dynamic>>> fetchTasksWithTodos() async {
    try {
      List<Map<String, dynamic>> tasks = [
        {
          'title': 'Design',
          'progress': 0.75,
          'taskCount': 46,
          'image':
              "https://media.istockphoto.com/id/1290658063/photo/portrait-of-a-beautiful-woman-with-natural-make-up.jpg?s=2048x2048&w=is&k=20&c=dZsBcuhog3SZnTj6bq5Is_isO2TpBNWunUwlKkln_dw=",
          'todos': [
            TodoModel(title: 'Design  ', completed: false),
            // Add more todos...
          ],
        },
        {
          'title': 'Design  Page',
          'progress': 0.75,
          'taskCount': 46,
          'image':
              "https://media.istockphoto.com/id/1130907832/photo/stunning-young-woman.jpg?s=1024x1024&w=is&k=20&c=Dc8QN55OfE5mqgAVU34c-umwx32KKuMBA7M24VKx_kE=",
          'todos': [
            TodoModel(title: 'Design  Page', completed: false),
            // Add more todos...
          ],
        },
        {
          'title': ' Website',
          'progress': 0.75,
          'taskCount': 46,
          'image':
              "https://media.istockphoto.com/id/1290658063/photo/portrait-of-a-beautiful-woman-with-natural-make-up.jpg?s=2048x2048&w=is&k=20&c=dZsBcuhog3SZnTj6bq5Is_isO2TpBNWunUwlKkln_dw=",
          'todos': [
            TodoModel(title: ' Home Page', completed: false),
            // Add more todos...
          ],
        },
        {
          'title': 'Task Page',
          'progress': 0.75,
          'taskCount': 46,
          'image':
              "https://media.istockphoto.com/id/1174452879/photo/i-do-all-my-work-on-this-device.jpg?s=612x612&w=0&k=20&c=ukqiZAIztp7olWY2h4kbcvdZJQ4e0G6zqwNPRlF5Q9Y=",
          'todos': [
            TodoModel(title: 'Task Page', completed: false),
            // Add more todos...
          ],
        },
        {
          'title': 'Todo Page',
          'progress': 0.75,
          'taskCount': 46,
          'image':
              "https://media.istockphoto.com/id/1040964880/photo/stay-hungry-for-success.jpg?s=612x612&w=0&k=20&c=rA1HTQ_BS1bv1POYCRthD179B3yENJhJITVeJTt_vJg=",
          'todos': [
            TodoModel(title: 'Todo Page', completed: false),
            // Add more todos...
          ],
        },
        {
          'title': 'Design Home Page',
          'progress': 0.75,
          'taskCount': 46,
          'image':
              "https://media.istockphoto.com/id/1198027123/photo/real-woman.jpg?s=2048x2048&w=is&k=20&c=DEn5JjgfQOJL2o4hRcluSuU5AepL-NaNhiI7sdg8jcs=",
          'todos': [
            TodoModel(title: 'Design Home Page', completed: false),
            // Add more todos...
          ],
        },
        {
          'title': 'Shape Website',
          'progress': 0.75,
          'taskCount': 46,
          'image':
              "https://media.istockphoto.com/id/1364917563/photo/businessman-smiling-with-arms-crossed-on-white-background.jpg?s=612x612&w=0&k=20&c=NtM9Wbs1DBiGaiowsxJY6wNCnLf0POa65rYEwnZymrM=",
          'todos': [
            TodoModel(title: 'Design Home Page', completed: false),
            // Add more todos...
          ],
        },

        // Add more tasks...
      ];

      return tasks;
    } catch (e) {
      debugPrint('Error fetching tasks with todos: $e');
      return [];
    }
  }
}
