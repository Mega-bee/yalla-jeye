class OtherOrder {
  String name;
  String palceName;
  String location;
  String description;
  int destinationId;
  int destinationPlaceId;
  bool isDeliveryOnly;
  num price;

  OtherOrder({ this.name, this.location, this.destinationId, this.palceName,this.description ,this.destinationPlaceId,this.price, this.isDeliveryOnly});

 Map<String, dynamic> toJson() {
   final Map<String, dynamic> data = new Map<String, dynamic>();
   data['isDeliveryOnly'] = this.isDeliveryOnly;
   data['destinationId'] = this.destinationId;
   data['description'] = this.description;
   data['name'] = this.name;
   data['location'] = this.location;
   data['destinationPlaceId'] = this.destinationPlaceId;
   return data;
 }
}
