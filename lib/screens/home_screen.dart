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

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  // List of tasks and their progress. This could come from your backend or state management logic.
  @override
  void initState() {
    super.initState();
    // Trigger loading tasks when the widget is initialized
    context.read<TaskBloc>().add(LoadTasks());
    context.read<TodoBloc>().add(LoadTodos());
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<TodoBloc>().add(LoadTodos());
    // });
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
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskGrid(List<Map<String, dynamic>> tasks) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        // Extract the counts from the state
        int checkedCount = 0;
        int uncheckedCount = 0;
        debugPrint('state is $state');
        if (state is TodosCountUpdated) {
          checkedCount = state.checkedCount;
          uncheckedCount = state.uncheckedCount;
        }
        return GridView.builder(
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
        );
      },
    );
  }

  Widget buildBody() {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TasksLoadSuccess) {
          return _buildTaskGrid(state.tasks);
        } else if (state is TaskAdditionSuccess) {
          return _buildTaskGrid(state.tasks);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Goals'),
      elevation: 0,
      leading: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TasksLoadSuccess && state.tasks.isNotEmpty) {
            String imageUrl =
                state.tasks[1]['image']; // Access the first task's image URL
            return Container(
              margin: const EdgeInsets.all(8),
              width: 20,
              height: 20,
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Implement search functionality
          },
        ),
      ],
    );
  }

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

class TaskCard extends StatelessWidget {
  final String title;
  final double progress;
  final int taskCount;
  final String image;
  final VoidCallback? onTap;
  final List<TodoModel>? todos;

  const TaskCard(
      {Key? key,
      required this.title,
      required this.progress,
      required this.taskCount,
      required this.image,
      required this.todos,
      this.onTap})
      : super(key: key);

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
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 8, top: 8),
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              var completedTodos = [];
              var uncompletedTodos = [];
              if (state is TodosLoadSuccess) {
                completedTodos = state.todos
                    .where((todo) => todo.completed == true)
                    .toList();
                uncompletedTodos = state.todos
                    .where((todo) => todo.completed == false)
                    .toList();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    // First member of the team
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
                    // '$taskCount Tasks',
                    '${uncompletedTodos.length} Tasks',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  LinearProgressIndicator(
                    //  value: progress,
                    value: uncompletedTodos.isNotEmpty ||
                            completedTodos.isNotEmpty
                        ? completedTodos.length /
                            (completedTodos.length + uncompletedTodos.length)
                        : 0.0,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 136, 51, 151)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
