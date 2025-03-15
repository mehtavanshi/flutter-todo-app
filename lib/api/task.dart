class Task {
  final String title;
  final String description;
  final String date;
  final String priority;
  final bool checkboxValue;
  final String id;

  Task({
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    required this.checkboxValue,
    required this.id,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['Title'],
      description: json['Description'],
      date: json['Date'],
      priority: json['Priority'],
      checkboxValue: json['Checkboxvalue'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Title': title,
      'Description': description,
      'Date': date,
      'Priority': priority,
      'Checkboxvalue': checkboxValue,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? priority,
    bool? checkboxValue,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      checkboxValue: checkboxValue ?? this.checkboxValue,
    );
  }
}



