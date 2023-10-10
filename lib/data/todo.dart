class Todo {
  final String id;
  final String title;
  final String subtitle;
  bool isDone;

  Todo(
      {this.id = '', this.title = '', this.subtitle = '', this.isDone = false});

  Todo copyWith({String? id, String? title, String? subtitle, bool? isDone}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isDone: isDone ?? this.isDone,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      isDone: json['isDone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'isDone': isDone,
    };
  }

  String toString() {
    return '''
      Title: $title''';
  }
}
