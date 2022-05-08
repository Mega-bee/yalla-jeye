class NotificationModel {
  int id = 0;
  String title = "";
  String description = "";
  String createdDate = "";
  int orderId = 0;

  NotificationModel(
      {this.id, this.title, this.description, this.createdDate, this.orderId});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    title = json['title']??"";
    description = json['description']??"";
    createdDate = json['createdDate']??"";
    orderId = json['orderId']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['createdDate'] = this.createdDate;
    data['orderId'] = this.orderId;
    return data;
  }
}
