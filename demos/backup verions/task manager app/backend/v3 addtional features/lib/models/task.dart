class Task {
  final String id;
  final String title;
  final String? description;
  final bool isDone;
  final DateTime? dueDate;
  final String category;
  final DateTime createdAt; // 📅 required field

  Task({
    required this.id,
    required this.title,
    this.description,
    this.isDone = false,
    this.dueDate,
    this.category = "General",
    required this.createdAt, // ✅ must always be provided
  });

  // 🔄 Convert Task to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'dueDate': dueDate?.toIso8601String(),
      'category': category,
      'createdAt': createdAt.toIso8601String(), // ✅ store as ISO string
    };
  }

  // 🔄 Create Task from Firestore Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'] ?? false,
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      category: map['category'] ?? "General",
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(), // ✅ fallback for older tasks
    );
  }
}
