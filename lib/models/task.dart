class Task {
  String id;
  String title;
  bool isChecked;

  Task({required this.title, this.isChecked = false, this.id = 'ABC'});

  void toggleCheck() {
    isChecked = !isChecked;
  }

  Map<String, dynamic> toJson(Task task, String Id) => {
        'id': Id,
        "title": task.title,
        "isChecked": task.isChecked,
      };
}
