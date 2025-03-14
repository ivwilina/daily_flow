// ignore_for_file: public_member_api_docs, sort_constructors_first
class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;

  Task({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted= json['isCompleted'];
    date= json['date'];
    startTime= json['startTime'];
    endTime= json['endTime'];
    color= json['color'];
    remind= json['remind'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id']=id;
    data['title']=title;
    data['note']=note;
    data['date']=date;
    data['isCompleted']=isCompleted;
    data['startTime']=startTime;
    data['endTime']=endTime;
    data['color']=color;
    data['remind']=remind;
    return data;
  }
}
