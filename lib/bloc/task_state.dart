/// The base class for all task states.
abstract class TaskState {}

/// Represents the initial state of tasks.
class TaskInitial extends TaskState {}

/// Represents the state when tasks are successfully loaded.
class TasksLoadSuccess extends TaskState {
  final List<Map<String, dynamic>> tasks;

  TasksLoadSuccess(this.tasks);
}

/// Represents the state when a task is successfully added.
class TaskAdditionSuccess extends TaskState {
  final List<Map<String, dynamic>> tasks;

  TaskAdditionSuccess(this.tasks);
}

/// Represents the state when tasks are successfully searched.
class TasksSearchSuccess extends TaskState {
  final List<Map<String, dynamic>> tasks;

  TasksSearchSuccess(this.tasks);
}

/// Represents the state when no tasks are found during a search.
class TasksSearchEmpty extends TaskState {}
