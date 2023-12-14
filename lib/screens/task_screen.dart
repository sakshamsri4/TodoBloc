import 'dart:math';

import 'package:bloc_api_integration/bloc/task_bloc.dart';
import 'package:bloc_api_integration/bloc/task_event.dart';
import 'package:bloc_api_integration/bloc/task_state.dart';
import 'package:bloc_api_integration/bloc/todo_bloc.dart';
import 'package:bloc_api_integration/bloc/todo_event.dart';
import 'package:bloc_api_integration/bloc/todo_state.dart';
import 'package:bloc_api_integration/models/todo_model.dart';
import 'package:bloc_api_integration/screens/todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The screen that displays the tasks and their progress.
class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Trigger loading tasks when the widget is initialized
    context.read<TaskBloc>().add(LoadTasks());
    context.read<TodoBloc>().add(LoadTodos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        backgroundColor: Colors.amberAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Builds the grid of tasks.
  ///
  /// This method takes a list of tasks as input and builds a grid of tasks using the `GridView.builder` widget.
  /// It uses the `BlocBuilder` widget to listen to changes in the `TodoBloc` state and rebuilds the grid accordingly.
  /// The grid is refreshed when the user performs a pull-to-refresh action.
  /// Each task is displayed as a `TaskCard` widget, which shows the task title, progress, task count, image, and todos.
  ///
  /// Parameters:
  /// - `tasks`: A list of maps representing the tasks.
  ///
  /// Returns:
  /// A `Widget` representing the grid of tasks.
  Widget _buildTaskGrid(List<Map<String, dynamic>> tasks) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        // Extract the counts from the state
        final checkedCount = _extractCheckedCount(state);
        final uncheckedCount = _extractUncheckedCount(state);
        if (tasks.isEmpty) {
          context.read<TaskBloc>().add(LoadTasks());
        }
        return RefreshIndicator(
          onRefresh: () async {
            context.read<TaskBloc>().add(LoadTasks());
            _searchController.clear();
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 16, // Horizontal space between cards
              mainAxisSpacing: 16, // Vertical space between cards
            ),
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              final task = tasks[index];
              return TaskCard(
                  title: task['title'],
                  progress: checkedCount > 0 || uncheckedCount > 0
                      ? checkedCount / (checkedCount + uncheckedCount)
                      : 0.0,
                  taskCount: uncheckedCount,
                  image: task['image'],
                  todos: task['todos']);
            },
          ),
        );
      },
    );
  }

  /// Extracts the count of checked tasks from the [TodoState].
  int _extractCheckedCount(TodoState state) {
    if (state is TodosCountUpdated) {
      return state.checkedCount;
    }
    return 0;
  }

  /// Extracts the count of unchecked tasks from the [TodoState].
  int _extractUncheckedCount(TodoState state) {
    if (state is TodosCountUpdated) {
      return state.uncheckedCount;
    }
    return 0;
  }

  /// Builds the body of the screen.
  Widget buildBody() {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TasksLoadSuccess) {
          return _buildTaskGrid(state.tasks);
        } else if (state is TaskAdditionSuccess) {
          return _buildTaskGrid(state.tasks);
        } else if (state is TasksSearchSuccess) {
          return _buildTaskGrid(state.tasks);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  /// Builds the app bar of the screen.
  ///
  /// This method returns an [AppBar] widget that contains a [TextField] for searching tasks.
  /// The [TextField] is connected to a [TaskBloc] using [BlocBuilder] to handle state changes.
  /// When the user types in the search field, it triggers the [SearchTasks] event in the [TaskBloc].
  /// The [AppBar] also contains action buttons based on the state of the [TaskBloc].
  /// If the state is [TasksSearchEmpty], it automatically triggers the [LoadTasks] event.
  /// If the state is [TasksSearchSuccess] or [TasksLoadSuccess], it shows a close button to clear the search field and trigger the [LoadTasks] event.
  /// Otherwise, it shows a search button to trigger the [LoadTasks] event.
  ///
  /// Example usage:
  /// ```dart
  /// AppBar appBar = buildAppBar();
  /// ```
  AppBar buildAppBar() {
    return AppBar(
      title: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          return TextField(
            onChanged: (value) {
              context.read<TaskBloc>().add(SearchTasks(value));
            },
            decoration: const InputDecoration(
              hintText: 'Search tasks...',
              border: InputBorder.none,
            ),
            controller: _searchController,
          );
        },
      ),
      actions: [
        BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TasksSearchEmpty) {
              context.read<TaskBloc>().add(LoadTasks());
            }
            if (state is TasksSearchSuccess || state is TasksLoadSuccess) {
              return IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    context.read<TaskBloc>().add(LoadTasks());
                  });
            } else {
              return IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => context.read<TaskBloc>().add(LoadTasks()),
              );
            }
          },
        ),
      ],
    );
  }

  /// Shows the dialog to add a new task.
  ///
  /// This method displays an AlertDialog with a text field where the user can enter a task title.
  /// The dialog has two buttons: "Cancel" and "Add". If the user taps "Cancel", the dialog is dismissed.
  /// If the user taps "Add" and the task title is not empty, the [_addNewTask] method is called to add the task.
  /// After adding the task, the dialog is dismissed. If the task title is empty, a SnackBar is displayed
  /// with a message indicating that the title cannot be empty.
  ///
  /// Parameters:
  ///   - [context]: The BuildContext of the current widget.
  ///
  /// Returns:
  ///   - [Future<void>]: A Future that resolves to void.
  Future<void> _showAddTaskDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Add a New Task'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Enter task title'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss dialog
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  _addNewTask(titleController.text, context);
                  Navigator.of(dialogContext).pop(); // Dismiss dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title cannot be empty')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewTask(String title, BuildContext context) {
    // Access the current state of TaskBloc
    final taskBloc = BlocProvider.of<TaskBloc>(context);
    final currentState = taskBloc.state;

    if (currentState is TasksLoadSuccess) {
      // Get the current list of tasks
      final currentTasks = currentState.tasks;

      // Generate a random index to select a picture
      int randomIndex = Random().nextInt(currentTasks.length);
      String randomImage = currentTasks[randomIndex]['image'];

      // Create the new task
      Map<String, dynamic> newTask = {
        'title': title,
        'progress': 0.0,
        'taskCount': 0,
        'image': randomImage,
        'todos': <TodoModel>[],
      };

      // Add the new task
      taskBloc.add(AddTask(newTask));
    }
  }
}

/// A card widget that represents a task.
///
/// This widget displays the title, progress, task count, and an image associated with the task.
/// It also allows the user to tap on the card to navigate to the [TodoScreen].
class TaskCard extends StatelessWidget {
  final String title;
  final double progress;
  final int taskCount;
  final String image;
  final VoidCallback? onTap;
  final List<TodoModel>? todos;

  /// Creates a [TaskCard] widget.
  ///
  /// The [title], [progress], [taskCount], [image], and [todos] parameters are required.
  /// The [onTap] parameter is optional.
  const TaskCard({
    Key? key,
    required this.title,
    required this.progress,
    required this.taskCount,
    required this.image,
    required this.todos,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoScreen(
              title: title,
              image: image,
            ),
          ),
        );
      },
      child: buildCard(),
    );
  }

  Widget buildCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 8, top: 8),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            var completedTodos = [];
            var uncompletedTodos = [];
            if (state is TodosLoadSuccess) {
              completedTodos =
                  state.todos.where((todo) => todo.completed == true).toList();
              uncompletedTodos =
                  state.todos.where((todo) => todo.completed == false).toList();
            }
            return buildTile(uncompletedTodos, completedTodos);
          },
        ),
      ),
    );
  }

  Widget buildTile(
      List<dynamic> uncompletedTodos, List<dynamic> completedTodos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(image),
          radius: 18,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${uncompletedTodos.length} Tasks',
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        LinearProgressIndicator(
          value: uncompletedTodos.isNotEmpty || completedTodos.isNotEmpty
              ? completedTodos.length /
                  (completedTodos.length + uncompletedTodos.length)
              : 0.0,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color.fromARGB(255, 136, 51, 151),
          ),
        ),
      ],
    );
  }
}
