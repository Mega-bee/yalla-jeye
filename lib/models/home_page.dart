class HomePageModel {
  Events events;
  List<ItemTypes> itemTypes;
  List<Restaurants> resturnats;

  HomePageModel();

  HomePageModel.fromJson(Map<String, dynamic> json) {
    events =
    json['events'] != null ? Events.fromJson(json['events']) : null;
    if (json['destinationPrice'] != null) {
      itemTypes = <ItemTypes>[];
      json['destinationPrice'].forEach((v) {
        itemTypes.add(ItemTypes.fromJson(v));
      });
    }
    if (json['resturnats'] != null) {
      resturnats = <Restaurants>[];
      json['resturnats'].forEach((v) {
        resturnats.add(Restaurants.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.events != null) {
  //     data['events'] = this.events.toJson();
  //   }
  //   if (this.itemTypes != null) {
  //     data['itemTypes'] = this.itemTypes.map((v) => v.toJson()).toList();
  //   }
  //   if (this.resturnats != null) {
  //     data['resturnats'] = this.resturnats.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Events {
  List<Ads> services;
  List<Ads> other;

  Events();

  Events.fromJson(Map<String, dynamic> json) {
    if (json['services'] != null) {
      services = <Ads>[];
      json['services'].forEach((v) {
        services.add(Ads.fromJson(v));
      });
    }
    if (json['other'] != null) {
      other = <Ads>[];
      json['other'].forEach((v) {
        other.add(Ads.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.services != null) {
  //     data['services'] = this.services!.map((v) => v.toJson()).toList();
  //   }
  //   if (this.other != null) {
  //     data['other'] = this.other!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Ads {
  int id=0;
  String title="";
  String description="";
  String imageUrl="";

  Ads();

  Ads.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    title = json['title']??"";
    description = json['description']??"";
    imageUrl = json['imageUrl']??"";
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['title'] = this.title;
  //   data['description'] = this.description;
  //   data['imageUrl'] = this.imageUrl;
  //   return data;
  // }
}

class ItemTypes {
  int id=0;
  String title="";
   List<DestinationPlace> places;
  bool checked=false;
  num price=0;

//  ItemTypes();
  ItemTypes(this.title ,this.id ,this.checked ,this.places );

  ItemTypes.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    title = json['name']??"";
    if (json['destinationPlace'] != null) {
      places = <DestinationPlace>[];
      json['destinationPlace'].forEach((v) {
        places.add(DestinationPlace.fromJson(v));
      });
      places.add(DestinationPlace(12,'other'));
    }

    checked= false;
    price = json['price']?? 0;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['title'] = this.title;
  //   return data;
  // }
}

class Restaurants {
  int id=0;
  String restaurantName="";
  String location="";
  String speciality="";
  String opensAt="";
  String closesAt="";
  int rating=0;
  String imageName="";
  String imageUrl="";
  int cityId=0;
  String pdfName="";
  String pdfUrl="";

  Restaurants();

  Restaurants.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    restaurantName = json['restaurantName']??"";
    location = json['location']??"";
    speciality = json['speciality']??"";
    opensAt = json['opensAt']??"";
    closesAt = json['closesAt']??"";
    rating = json['rating']??0;
    imageName = json['imageName']??"";
    imageUrl = json['imageUrl']??"";
    cityId = json['cityId']??0;
    pdfName = json['pdfName']??"";
    pdfUrl = json['pdfUrl']??"";
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['restaurantName'] = this.restaurantName;
  //   data['location'] = this.location;
  //   data['speciality'] = this.speciality;
  //   data['opensAt'] = this.opensAt;
  //   data['closesAt'] = this.closesAt;
  //   data['rating'] = this.rating;
  //   data['imageName'] = this.imageName;
  //   data['imageUrl'] = this.imageUrl;
  //   data['cityId'] = this.cityId;
  //   data['pdfName'] = this.pdfName;
  //   data['pdfUrl'] = this.pdfUrl;
  //   return data;
  // }

}
class DestinationPlace{
  int id=0;
  String title="";


  DestinationPlace(this.id, this.title,);

  DestinationPlace.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    title = json['name']??"";
  }

}