abstract class TaskState {}

class TaskInitial extends TaskState {}

class TasksLoadSuccess extends TaskState {
  final List<Map<String, dynamic>> tasks;

  TasksLoadSuccess(this.tasks);
}

class TaskAdditionSuccess extends TaskState {
  final List<Map<String, dynamic>> tasks;

  TaskAdditionSuccess(this.tasks);
}

class TasksSearchSuccess extends TaskState {
  final List<Map<String, dynamic>> tasks;
  TasksSearchSuccess(this.tasks);
}

class TasksSearchEmpty extends TaskState {}
