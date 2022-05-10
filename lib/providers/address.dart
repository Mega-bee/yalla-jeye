import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yallajeye/Services/Addresses.dart';
import 'package:yallajeye/Services/ApiLink.dart';
import 'package:yallajeye/Services/ServiceAPi.dart';
import 'package:yallajeye/models/Adresses.dart';
import 'package:yallajeye/models/getAllCities.dart';

class AddressProvider extends ChangeNotifier {
  ServiceAPi _serviceAPi = ServiceAPi();
  bool _cityLoading=false;

  bool get cityLoading => _cityLoading;

  set cityLoading(bool value) {
    _cityLoading = value;
  }

  int _idOfAddressToUpdate=0;

  int get idOfAddressToUpdate => _idOfAddressToUpdate;

  set idOfAddressToUpdate(int value) {
    _idOfAddressToUpdate = value;
  }

  //use it to show user the city choosen in address when need to update
  int _cityUpdateId=0;

  int get cityUpdateId => _cityUpdateId;

  set cityUpdateId(int value) {
    _cityUpdateId = value;
  }

  bool _isCreateAddress=false;

  bool get isCreateAddress => _isCreateAddress;

  set isCreateAddress(bool value) {
    _isCreateAddress = value;
  }

  bool _loading=false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
  }

  AddressesModel _addressChoosen=AddressesModel();

  AddressesModel get addressChoosen => _addressChoosen;

  set addressChoosen(AddressesModel value) {
    _addressChoosen = value;
  }

  getAllCitiesModel _cityChoosen = getAllCitiesModel();

  getAllCitiesModel get cityChoosen => _cityChoosen;

  set cityChoosen(getAllCitiesModel value) {
    _cityChoosen = value;
  }

  List<getAllCitiesModel> _listcity = [];


  List<getAllCitiesModel> get listcity => _listcity;

  set listcity(List<getAllCitiesModel> value) {
    _listcity = value;
  }

  Map<String, dynamic> _allData = {};

  Map<String, dynamic> get allData => _allData;

  set allData(Map<String, dynamic> value) {
    _allData = value;
  }

  List<AddressesModel> _addresses = [];

  List<AddressesModel> get addresses => _addresses;

  set addresses(List<AddressesModel> value) {
    _addresses = value;
  }


  TextEditingController addresstitle = TextEditingController();
  TextEditingController buildingName = TextEditingController();
  TextEditingController floor = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController street = TextEditingController();
  LatLng _location;

  clearFields() {
    addresstitle.clear();
    buildingName.clear();
    floor.clear();
    description.clear();
    street.clear();
    // cityId.clear();
    cityChoosen = getAllCitiesModel();
  }


  Future<String> createAddress() async {
    allData = await _serviceAPi.postAPi(ApiLink.CreateAdress, [],{
      'title': addresstitle.text,
      'description': description.text,
      'cityId': cityChoosen.id.toString(),
      'street': street.text,
      'buildingName': buildingName.text,
      'floorNumber': floor.text,
      'latitude':_location.latitude.toString(),
      'longitude':_location.longitude.toString(),
    },[], {}, false);
    if (allData["error"] != null) {
      return allData["error"];
    } else {
      return allData["message"];
    }
  }

  Future<String> deleteAddress(int id) async {
    String link=ApiLink.DeleteAddress + "/$id";
    allData =
    await _serviceAPi.postAPi(link,[], {},[], {}, false);
    if (allData["error"] != null) {
      print("not doneee${allData["error"]}");
      return allData["error"];
    } else {
      print("doneee${allData["message"]}");
      return allData["message"];
    }
  }

  Future<String> updateAddress() async{
   allData= await _serviceAPi.postAPi(ApiLink.updateAddress,[],
        {
          'Id': idOfAddressToUpdate.toString(),
          'title': addresstitle.text,
        'description': description.text,
        'cityId': cityChoosen.id.toString(),
        'street': street.text,
        'buildingName': buildingName.text,
        'floorNumber': floor.text
    },[], {}, false);
   if (allData["error"] != null) {
     return allData["error"];
   } else {
     return allData["message"];
   }
  }

  getAllAddresses() async {
    loading=true;
    allData = await _serviceAPi.getAPi(ApiLink.getAllAddresses, [], {});
    if (allData["error"] != null) {
      print(allData["error"]);
    } else {
      addresses = List<AddressesModel>.from(
          allData["data"].map((model) => AddressesModel.fromJson(model)));
    }
loading=false;
    notifyListeners();
  }


    getAllCities() async {
    cityLoading=true;
      allData = await _serviceAPi.getAPi(ApiLink.getAllCities, [], {});
      if (allData["error"] != null) {
        print(allData["error"]);
      } else {
        listcity = List<getAllCitiesModel>.from(
            allData["data"].map((model) => getAllCitiesModel.fromJson(model)));

      }
      cityLoading=false;
    notifyListeners();
    }

  void setlocation(value) {
    _location = value;
  }

}
