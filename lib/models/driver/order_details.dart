class DriverOrderDetails {
  int id=0;
  String userName="";
  Address address=Address();
  String phoneNumber="";
  List<CheckListItems> checkListItems=[];
  String description="";
  String orderStatus="";
  int orderStatusId=0;
  int deliveryPrice=0;

  DriverOrderDetails();

  DriverOrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    userName = json['userName']??"Not found";
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : Address();
    phoneNumber = json['phoneNumber']??"Not found";
    if (json['checkListItems'] != null) {
      checkListItems = <CheckListItems>[];
      json['checkListItems'].forEach((v) {
        checkListItems.add(new CheckListItems.fromJson(v));
      });
    }else{
      checkListItems=[];
    }
    description = json['description']??"Not found";
    orderStatus = json['orderStatus']??"Not found";
    orderStatusId = json['orderStatusId']??0;
    deliveryPrice = json['deliveryPrice']??0;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['userName'] = this.userName;
  //   if (this.address != null) {
  //     data['address'] = this.address!.toJson();
  //   }
  //   data['phoneNumber'] = this.phoneNumber;
  //   if (this.checkListItems != null) {
  //     data['checkListItems'] =
  //         this.checkListItems!.map((v) => v.toJson()).toList();
  //   }
  //   data['description'] = this.description;
  //   data['orderStatus'] = this.orderStatus;
  //   data['orderStatusId'] = this.orderStatusId;
  //   data['deliveryPrice'] = this.deliveryPrice;
  //   return data;
  // }
}

class Address {
  int id=0;
  String city="";
  int cityId=0;
  String street="";
  String buildingName="";
  int floorNumber=0;
  String title="";
  String description="";
  String longitude="";
  String latitude="";

  Address();

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    city = json['city']??"Not found";
    cityId = json['cityId']??0;
    street = json['street']??"Not found";
    buildingName = json['buildingName']??"Not found";
    floorNumber = json['floorNumber']??0;
    title = json['title']??"Not found";
    description = json['description']??"Not found";
    longitude = json['longitude']??"Not found";
    latitude = json['latitude']??"Not found";
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['city'] = this.city;
  //   data['cityId'] = this.cityId;
  //   data['street'] = this.street;
  //   data['buildingName'] = this.buildingName;
  //   data['floorNumber'] = this.floorNumber;
  //   data['title'] = this.title;
  //   data['description'] = this.description;
  //   data['longitude'] = this.longitude;
  //   data['latitude'] = this.latitude;
  //   return data;
  // }


}

class CheckListItems {
  int id=0;
  String item="";
  bool isDone=false;

  CheckListItems({this.id, this.item, this.isDone});

  CheckListItems.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    item = json['item']??"Not found";
    isDone = json['isDone']??false;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['item'] = this.item;
  //   data['isDone'] = this.isDone;
  //   return data;
  // }
}