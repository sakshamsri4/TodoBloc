import 'package:bloc_api_integration/models/todo_model.dart';
import 'package:bloc_api_integration/services/rest_service.dart';
import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TodoModel> uncheckedItems = [];
  List<TodoModel> checkedItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    uncheckedItems = await RestService().fetchTodo();
  }

  void handleCheckboxChange(bool isChecked, TodoModel item) {
    setState(() {
      if (isChecked) {
        uncheckedItems.remove(item);
        checkedItems.add(item);
      } else {
        checkedItems.remove(item);
        uncheckedItems.add(item);
      }
    });
  }

  void reorderData(int oldIndex, int newIndex, bool isCheckedList) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final TodoModel item = isCheckedList
          ? checkedItems.removeAt(oldIndex)
          : uncheckedItems.removeAt(oldIndex);
      isCheckedList
          ? checkedItems.insert(newIndex, item)
          : uncheckedItems.insert(newIndex, item);
    });
  }

  Widget buildReorderableList(bool isCheckedList) {
    List<TodoModel> items = isCheckedList ? checkedItems : uncheckedItems;
    return SizedBox(
      height: 500,
      child: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) =>
            reorderData(oldIndex, newIndex, isCheckedList),
        children: List.generate(items.length, (index) {
          return Dismissible(
            key:
                Key('${items[index].title}_${items[index].description}_$index'),
            onDismissed: (direction) {
              setState(() {
                isCheckedList
                    ? checkedItems.removeAt(index)
                    : uncheckedItems.removeAt(index);
              });
            },
            child: Card(
              child: ListTile(
                title: Text(
                  items[index].title ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    decoration:
                        isCheckedList ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  items[index].description ?? "",
                  style: TextStyle(
                    fontSize: 12,
                    decoration:
                        isCheckedList ? TextDecoration.lineThrough : null,
                  ),
                ),
                leading: Checkbox(
                  value: isCheckedList,
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      handleCheckboxChange(newValue, items[index]);
                    }
                  },
                ),
                trailing: const Icon(Icons.reorder),
              ),
            ),
          );
        }),
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
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        // title: const Text(" To-Dos",
        //     style: TextStyle(
        //         color: Colors.white,
        //         fontSize: 24,
        //         fontWeight: FontWeight.bold)),
        // backgroundColor: Colors.purple.shade500,
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
    setState(() {
      // Add the new task to the unchecked list
      // You might want to create a proper Task model class instead of using int
      uncheckedItems.add(TodoModel(title: title, description: description));
      // Implement logic to use the title and description
    });
  }

  Widget buildBody() {
    return SingleChildScrollView(
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
                  Text("${uncheckedItems.length} Tasks",
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey)),
                  const Text("To-Do",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Flexible(
                        child: LinearProgressIndicator(
                          value: checkedItems.isNotEmpty ||
                                  uncheckedItems.isNotEmpty
                              ? checkedItems.length /
                                  (checkedItems.length + uncheckedItems.length)
                              : 0,
                          color: Colors.purple,
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                          "${checkedItems.length} / ${checkedItems.length + uncheckedItems.length}")
                    ],
                  ),
                ],
              ),
            ),
            buildReorderableList(false),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: Text("+ ${checkedItems.length} Completed Tasks",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey)),
            ),
            buildReorderableList(true),
          ],
        ),
      ),
    );
  }
}
