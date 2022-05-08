class DriverOrder {
  int id=0;
  int orderStatusId=0;
  String orderStatus="";
  String userName="";
  String city="";

  DriverOrder();

  DriverOrder.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    orderStatusId = json['orderStatusId']??0;
    orderStatus = json['orderStatus']??"Not found";
    userName = json['userName']??"Not found";
    city = json['city']??"Not found";
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['orderStatusId'] = this.orderStatusId;
  //   data['orderStatus'] = this.orderStatus;
  //   data['userName'] = this.userName;
  //   data['city'] = this.city;
  //   return data;
  // }
}