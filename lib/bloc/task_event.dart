abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Map<String, dynamic> newTask;

  AddTask(this.newTask);
}

// Add to your TaskEvent
class SearchTasks extends TaskEvent {
  final String query;
  SearchTasks(this.query);
}

class ClearSearch extends TaskEvent {}

class InitiateSearch extends TaskEvent {}
