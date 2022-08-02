class OtherOrder {
  String name;
  String location;
  String description;
  int destinationId;
  bool isDeliveryOnly;
  num price;

  OtherOrder({ this.name, this.location, this.destinationId, this.description ,this.price, this.isDeliveryOnly});

 Map<String, dynamic> toJson() {
   final Map<String, dynamic> data = new Map<String, dynamic>();
   data['isDeliveryOnly'] = this.isDeliveryOnly;
   data['destinationId'] = this.destinationId;
   data['description'] = this.description;
   data['name'] = this.name;
   data['location'] = this.location;
   return data;
 }
}
