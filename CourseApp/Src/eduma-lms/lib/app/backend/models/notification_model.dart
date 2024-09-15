class NotificationModel {
  String? notification_id;
  String? name;
  String? type;
  String? title;
  String? content;
  String? image;
  String? status;
  String? source;
  String? date_reminder;
  String? date_created;

  NotificationModel({
    this.notification_id,
    this.name,
    this.type,
    this.title,
    this.content,
    this.image,
    this.status,
    this.source,
    this.date_reminder,
    this.date_created
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notification_id = json["notification_id"].toString();
    name = json['name'].toString();
    type = json['type'].toString();
    title = json['title'].toString();
    content = json['content'].toString();
    image = json['image'].toString();
    status = json['status'].toString();
    source = json['source'].toString();
    date_reminder = json['date_reminder'].toString();
    date_created = json['date_created'].toString();
  }
}
