/// Represents a Todo item with various properties.
class TodoModel {
  final int? userId;
  final int? id;
  final String? title;
  final String? description;
  final bool? completed;
  List<TodoModel> todos;

  /// Constructs a [TodoModel] instance.
  ///
  /// The [userId], [id], [title], [completed], and [description] parameters are optional.
  /// The [todos] parameter is a list of [TodoModel] instances and is set to an empty list by default.
  TodoModel({
    this.userId,
    this.id,
    this.title,
    this.completed,
    this.description,
    this.todos = const [],
  });

  /// Factory constructor for creating a new [TodoModel] instance from a map.
  ///
  /// The [json] parameter is a map containing the properties of the [TodoModel].
  /// The [userId], [id], [title], [completed], and [description] properties are extracted from the [json] map.
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

  /// Converts the [TodoModel] instance to a map.
  ///
  /// Returns a map representation of the [TodoModel] instance, where the keys are the property names
  /// and the values are the corresponding property values.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }

  /// Creates a copy of the [TodoModel] instance with the specified properties overridden.
  ///
  /// The [userId], [id], [title], [description], and [completed] parameters are optional.
  /// If a parameter is provided, its value will be used in the new [TodoModel] instance.
  /// If a parameter is not provided, the corresponding property value from the original [TodoModel] instance will be used.
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
