class OrderModel {
  int id=0;
  int orderNumber=0;
  String orderDetails="";
  String orderStatus="";
  int deliveryPrice=0;
  int orderStatusId=0;
  String createdAt="";
  List<DestenationModel> destenation;

  OrderModel();

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    orderNumber = json['orderNumber']??0;
    orderDetails = json['orderDetails']??"Not found";
    orderStatus = json['orderStatus']??"Not found";
    deliveryPrice = json['deliveryPrice']??0;
    orderStatusId=json['orderStatusId']??0;
    createdAt = json['createdAt']??"";
    destenation = List<DestenationModel>.from(json['destinations'].map((model)=> DestenationModel.fromJson(model)));
  }

}

class CancelOrderReasonModel {
  int id=0;
  String stauts="";

  CancelOrderReasonModel();

  CancelOrderReasonModel.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    stauts = json['stauts']??"Not Found";
  }

}


class DestenationModel {
  int id=0;
  String name="";
  String location="";
  String description="";
  bool isDeliveryOnly=false;
  num price=0;

  DestenationModel();

  DestenationModel.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    name = json['name']??"Not Found";
    location = json['location']??"Not Found";
    description = json['description']??"Not Found";
    isDeliveryOnly = json['isDeliveryOnly'] ;
    price = json['price'] ;
  }

}