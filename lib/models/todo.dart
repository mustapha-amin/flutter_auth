class Todo {
  String id;
  String title;
  String description;
  bool isComplete;
  DateTime createdAt;
  DateTime updatedAt;
  int version;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isComplete,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      isComplete: json['isComplete'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'isComplete': isComplete,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isComplete,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isComplete: isComplete ?? this.isComplete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}
