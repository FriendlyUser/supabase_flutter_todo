import 'dart:convert';

TodoModel todoModelFromJson(String str) => TodoModel.fromJson(json.decode(str));

String todoModelToJson(TodoModel data) => json.encode(data.toJson());

class TodoModel {
  TodoModel({
    required this.todos,
  });

  final List<Todo> todos;

  factory TodoModel.fromJson(List<dynamic> todoList) => TodoModel(
        todos: List<Todo>.from(todoList.map((x) => Todo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "todos": List<dynamic>.from(todos.map((x) => x.toJson())),
      };
}

class Todo {
  Todo({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.isDone,
  });

  final int id;
  final DateTime createdAt;
  final String title;
  final String description;
  final bool isDone;

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        title: json["title"],
        description: json["description"],
        isDone: json["isDone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "title": title,
        "description": description,
        "isDone": isDone,
      };
}