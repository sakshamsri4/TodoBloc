class TodoModel {
  final int? userId;
  final int? id;
  final String? title;
  final String? description;
  final bool? completed;
  List<TodoModel> todos;

  TodoModel(
      {this.userId,
      this.id,
      this.title,
      this.completed,
      this.description,
      this.todos = const []});

  // Factory constructor for creating a new TodoModel instance from a map.
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      userId: json['userId'] as int? ?? 0, // Default to 0 if null
      id: json['id'] as int? ?? 0, // Default to 0 if null
      title: json['title'] as String? ??
          'Untitled', // Default to 'Untitled' if null
      completed:
          json['completed'] as bool? ?? false, // Default to false if null
      description:
          json['description'] ?? "", // No default needed, already nullable
    );
  }

  // Method to convert TodoModel instance to a map.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }

  // Add a copyWith method
  TodoModel copyWith({
    int? userId,
    int? id,
    String? title,
    String? description,
    bool? completed,
  }) {
    return TodoModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}
