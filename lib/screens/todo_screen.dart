import 'package:bloc_api_integration/bloc/todo_bloc.dart';
import 'package:bloc_api_integration/bloc/todo_event.dart';
import 'package:bloc_api_integration/bloc/todo_state.dart';
import 'package:bloc_api_integration/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoScreen extends StatefulWidget {
  final String? title;
  final String? image;
  const TodoScreen({super.key, this.title, this.image});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(LoadTodos());
  }

  void handleCheckboxChange(bool isChecked, TodoModel item) {
    context.read<TodoBloc>().add(TodoStatusChanged(item, isChecked));
  }

  Widget buildReorderableList(BuildContext context, bool isCheckedList) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodosLoadSuccess) {
          List<TodoModel> items = state.todos
              .where((todo) => todo.completed == isCheckedList)
              .toList();
          return SizedBox(
            height: 500,
            child: ReorderableListView(
              onReorder: (int oldIndex, int newIndex) =>
                  _onReorder(context, items, oldIndex, newIndex, isCheckedList),
              children: List.generate(items.length, (index) {
                return buildTodoItem(context, items[index], index);
              }),
            ),
          );
        } else {
          return const Center(child: Text('No tasks available'));
        }
      },
    );
  }

  void _onReorder(BuildContext context, List<TodoModel> items, int oldIndex,
      int newIndex, bool isCheckedList) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final TodoModel item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    // Dispatch reorder event
    context
        .read<TodoBloc>()
        .add(ReorderTodo(oldIndex, newIndex, isCheckedList));
  }

  Widget buildTodoItem(BuildContext context, TodoModel todo, int index) {
    return Dismissible(
      background: Container(
        color: const Color.fromARGB(
            255, 244, 92, 81), // Background color when the item is swiped
        alignment: Alignment.center,

        child: const Icon(Icons.delete, color: Colors.white),
      ),
      key: Key('${todo.id}'),
      onDismissed: (direction) {
        context.read<TodoBloc>().add(DeleteTodo(todo.id ?? 0));
      },
      child: Center(
        child: Card(
          child: ListTile(
            //   tileColor: Colors.grey.shade100,
            title: Text(
              todo.title ?? "",
              style: TextStyle(
                decoration: todo.completed == true
                    ? TextDecoration.lineThrough
                    : null, // Cross off text if completed
              ),
            ),
            subtitle: Text(todo.description ?? ""),
            leading: Checkbox(
              value: todo.completed,
              onChanged: (bool? newValue) {
                context
                    .read<TodoBloc>()
                    .add(TodoStatusChanged(todo, newValue ?? false));
              },
            ),
            trailing: const Icon(Icons.reorder),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddTaskBottomSheet(context);
          },
          backgroundColor: Colors.purple,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          )),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('To-Dos',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      ),
      body: buildBody(),
    );
  }

  void showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String description = '';

        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text('Add Task'),
                onPressed: () {
                  if (title.isNotEmpty) {
                    // Assuming you have a method to add a task
                    addTask(title, description);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Title cannot be empty'),
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void addTask(String title, String description) {
    context.read<TodoBloc>().add(AddTodo(TodoModel(
          title: title,
          description: description,
          completed: false,
        )));
  }

  Widget buildBody() {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodosLoadInProgress) {
          // Show loading indicator
          return const Center(child: CircularProgressIndicator());
        } else if (state is TodosLoadSuccess) {
          // Show the task list
          return buildTaskList(context, state.todos);
        }
        //  else if (state is TodosCountUpdated) {
        //   // Show the task list
        //   return buildTaskList(context, state.todos);
        // }
        else if (state is TodosLoadFailure) {
          // Show error message
          return Center(child: Text(state.message));
        } else {
          // Default case
          return const Center(child: Text('No tasks found'));
        }
      },
    );
  }

  Widget buildTaskList(BuildContext context, List<TodoModel> todos) {
    var completedTodos = todos.where((todo) => todo.completed == true).toList();
    var uncompletedTodos =
        todos.where((todo) => todo.completed == false).toList();
    return RefreshIndicator(
      onRefresh: () async {
        context.read<TodoBloc>().add(LoadTodos());
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${uncompletedTodos.length} Tasks",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey)),
                    Text(widget.title ?? "",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Flexible(
                          child: LinearProgressIndicator(
                            value: todos.isNotEmpty
                                ? completedTodos.length / todos.length
                                : 0.0,
                            color: Colors.purple,
                            backgroundColor: Colors.grey.shade300,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text("${completedTodos.length} / ${todos.length}")
                      ],
                    ),
                  ],
                ),
              ),
              uncompletedTodos.isNotEmpty
                  ? buildReorderableList(
                      context,
                      false,
                    )
                  : const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text("No Tasks Added Yet",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey)),
                      ),
                    ),
              Visibility(
                visible: completedTodos.isNotEmpty,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Text("+ ${completedTodos.length} Completed Tasks",
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey)),
                ),
              ),
              buildReorderableList(
                context,
                true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
