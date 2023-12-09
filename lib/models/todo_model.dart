class TodoModel {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  TodoModel(
      {required this.userId,
      required this.id,
      required this.title,
      required this.completed});

  // Factory constructor for creating a new TodoModel instance from a map.
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    if (json['userId'] == null ||
        json['id'] == null ||
        json['title'] == null ||
        json['completed'] == null) {
      throw ArgumentError('Missing required property in JSON');
    }
    return TodoModel(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
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
}
