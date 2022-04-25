class Task {
  int? id;
  String? title;
  String? note;
  String? date;
  String? startTime;
  String? endTime;
  int? reminder;
  String? repeat;
  int? isCompleted;
  String? color;

  Task({
    this.id,
    this.title,
    this.note,
    this.date,
    this.startTime,
    this.endTime,
    this.reminder,
    this.repeat,
    this.isCompleted,
    this.color,
  });

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        note = json['note'],
        date = json['date'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        reminder = json['reminder'],
        repeat = json['repeat'],
        color = json['color'],
        isCompleted = json['isCompleted'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['note'] = note;
    data['date'] = date;
    data['color'] = color;
    data['isCompleted'] = isCompleted;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['reminder'] = reminder;
    data['repeat'] = repeat;
    return data;
  }
}
