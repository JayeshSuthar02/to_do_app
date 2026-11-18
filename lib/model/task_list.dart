class TaskList {
  final int? id;
  final String todo;
  final bool completed;

  TaskList({
    this.id,
    required this.todo,
    required this.completed,
  });

  factory TaskList.fromJson(Map<String, dynamic> json) {
    return TaskList(
      id: json['id'],
      todo: json['todo'] ?? '',
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'todo': todo,
      'completed': completed,
    };
  }
}
