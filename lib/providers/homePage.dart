import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:rxdart/rxdart.dart';
import 'package:yallajeye/Services/ApiLink.dart';
import 'package:yallajeye/Services/HomePage.dart';
import 'package:yallajeye/Services/ServiceAPi.dart';
import 'package:yallajeye/models/home_page.dart';
import 'package:geocoding/geocoding.dart';

class HomePageProvider extends ChangeNotifier {
  HomePageService _homePageService = HomePageService();
  ServiceAPi _serviceAPi=ServiceAPi();

  static final PublishSubject<String> _currentLoc =
  PublishSubject<String>();
  Stream<String> get currentLocStream => _currentLoc.stream;

  List<Ads> _services = [];

  List<Ads> get services => _services;

  set services(List<Ads> value) {
    _services = value;
  }

  List<Ads> _other = [];

  List<Ads> get other => _other;

  set other(List<Ads> value) {
    _other = value;
  }

  Map<String, dynamic> _allData = {};

  Map<String, dynamic> get allData => _allData;

  set allData(Map<String, dynamic> value) {
    _allData = value;
  }
List<Restaurants> _restaurants=[];

  List<Restaurants> get restaurants => _restaurants;

  set restaurants(List<Restaurants> value) {
    _restaurants = value;
  }

  List<ItemTypes> _itemTypes=[];

  List<ItemTypes> get itemTypes => _itemTypes;

  set itemTypes(List<ItemTypes> value) {
    _itemTypes = value;
  }
  bool _loading = true;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
  }





  // List<ItemTypes> _selectedItem=[];
  //
  //
  // List<ItemTypes> get selectedItem => _selectedItem;
  //
  // set selectedItem(List<ItemTypes> value) {
  //   _selectedItem = value;
  // }
  //
  // addItem(ItemTypes item){
  //   _selectedItem.add(item);
  //   notifyListeners();
  // }
  // removeItem(ItemTypes item){
  //   _selectedItem.remove(item);
  //   notifyListeners();
  // }
  //
  // List<int> _selectItemId=[];
  //
  // List<int> get selectItemId => _selectItemId;
  //
  // set selectItemId(List<int> value) {
  //   _selectItemId = value;
  // }
  //
  // selectItemById(){
  //   selectItemId=[];
  //   _selectedItem.forEach((element) {
  //     selectItemId.add(element.id);
  //   });
  //   notifyListeners();
  // }

  getHomePage() async{
    loading = true;
    allData=await _serviceAPi.getAPi(ApiLink.HomePage, [], {});
    if(allData["error"]!=null){
      print(allData["error"]);
    }else{
      services=List<Ads>.from(
          allData["data"]["events"]["services"].map((model) => Ads.fromJson(model)));
      other = List<Ads>.from(
          allData["data"]["events"]["other"].map((model) => Ads.fromJson(model)));
      restaurants = List<Restaurants>.from(
          allData["data"]["restaurants"].map((model) => Restaurants.fromJson(model)));
      itemTypes = List<ItemTypes>.from(
          allData["data"]["itemTypes"].map((model) => ItemTypes.fromJson(model)));
    }
    loading = false;
    notifyListeners();
  }

  defaultLocation() async {
    loc.Location locationF =   loc.Location();
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;
    loc.LocationData _locationData;

    _serviceEnabled = await locationF.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await locationF.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await locationF.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await locationF.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return null;
      }
    }
    var myLocation = await loc.Location.instance.getLocation();
    LatLng myPos = LatLng(myLocation.latitude ?? 0, myLocation.longitude ?? 0);

    print("Mypos {$myPos}");

//    List<Placemark> placemarks = await placemarkFromCoordinates(52.2165157, 6.9437819);
    List<Placemark> newPlace = await GeocodingPlatform.instance.placemarkFromCoordinates(myPos.latitude, myPos.longitude,localeIdentifier: "en");

    print(newPlace[0].locality  + newPlace[0].subLocality +newPlace[0].thoroughfare );
    _currentLoc.add(newPlace[0].locality+' '+newPlace[0].thoroughfare );

  }
}
