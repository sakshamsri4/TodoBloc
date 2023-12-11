abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Map<String, dynamic> newTask;

  AddTask(this.newTask);
}

// More events can be added as needed
