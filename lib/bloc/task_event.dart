/// The base class for all task events.
abstract class TaskEvent {}

/// An event to load tasks.
class LoadTasks extends TaskEvent {}

/// An event to add a new task.
class AddTask extends TaskEvent {
  final Map<String, dynamic> newTask;

  AddTask(this.newTask);
}

/// An event to search tasks based on a query.
class SearchTasks extends TaskEvent {
  final String query;

  SearchTasks(this.query);
}

/// An event to clear the search results.
class ClearSearch extends TaskEvent {}

/// An event to initiate a search.
class InitiateSearch extends TaskEvent {}
