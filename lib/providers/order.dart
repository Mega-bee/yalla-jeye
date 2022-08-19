import 'package:flutter/cupertino.dart';
import 'package:yallajeye/Services/ApiLink.dart';
import 'package:yallajeye/Services/ServiceAPi.dart';
import 'package:yallajeye/models/Adresses.dart';
import 'package:yallajeye/models/order.dart';
import 'package:yallajeye/models/orderByid.dart';
import 'package:yallajeye/screens/order/other_order.dart';

import '../models/home_page.dart';

class OrderProvider extends ChangeNotifier{
  ServiceAPi _serviceAPi=ServiceAPi();
  TextEditingController _otherType=TextEditingController();
  OrderByIdModel _orderByIdModel=OrderByIdModel();
  bool _loadingId=false;

  bool get loadingId => _loadingId;

  set loadingId(bool value) {
    _loadingId = value;
  }

  TextEditingController get otherType => _otherType;

  set otherType(TextEditingController value) {
    _otherType = value;
  }

  bool _show=false;

  bool get show => _show;

  set show(bool value) {
    _show = value;
  }

  TextEditingController orderDetails=TextEditingController();
  List _selectedTypeId=[];

  List get selectedTypeId => _selectedTypeId;

  set selectedTypeId(List value) {
    _selectedTypeId = value;
  }

  Map<String,dynamic> _selectedType={};

  Map<String, dynamic> get selectedType => _selectedType;
  


  OrderByIdModel get orderByIdModel => _orderByIdModel;

  set orderByIdModel(OrderByIdModel value) {
    _orderByIdModel = value;
  }

  set selectedType(Map<String, dynamic> value) {
    _selectedType = value;
  }
  Map<String,dynamic> _allData={};

  Map<String, dynamic> get allData => _allData;

  set allData(Map<String, dynamic> value) {
    _allData = value;
  }

  List<OrderModel> _getOrder=[];


  List<OrderModel> get getOrder => _getOrder;

  set getOrder(List<OrderModel> value) {
    _getOrder = value;
  }

  bool _loading=false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
  }

  int _orderIdForRedeemCode=0;

  int get orderIdForRedeemCode => _orderIdForRedeemCode;

  set orderIdForRedeemCode(int value) {
    _orderIdForRedeemCode = value;
  }
String _messagePlaceOrder="";

  String get messagePlaceOrder => _messagePlaceOrder;

  set messagePlaceOrder(String value) {
    _messagePlaceOrder = value;
  }

  Future<bool> placeOrder(int addressId ,List<OtherOrder> _listOfObject) async{
    print(selectedTypeId);
    List jsonList = [];
    _listOfObject.map((item) => jsonList.add(item.toJson())).toList();
   allData= await _serviceAPi.postAPiRawJson(ApiLink.placeOrder, {
      "addressId": addressId,
     "orderDestination":jsonList,
     "promoCode":promoCode
    }, {'Content-Type': 'application/json'}, false);
    if (allData["error"] != null) {
      messagePlaceOrder= allData["error"];
      return false;
    } else {
      orderIdForRedeemCode=allData['data']['id'];
      messagePlaceOrder=allData["message"];
    return true;
    }
  }

  getOrders(int id) async{
    loading=true;
    allData= await _serviceAPi.getAPi(ApiLink.GetAllOrders, [id.toString()], {});
    if (allData["error"] != null) {
      print(allData["error"]);
    } else {
      getOrder=List<OrderModel>.from(allData["data"].map((model)=> OrderModel.fromJson(model)));

    }
    loading=false;
    notifyListeners();
  }

  clearFields(){
    show=false;
    orderDetails.clear();
    selectedTypeId=[];
    selectedItem=[];
    otherType.clear();
    redeemCodeController.clear();
    notifyListeners();
  }
  List<ItemTypes> _selectedItem=[];


  List<ItemTypes> get selectedItem => _selectedItem;

  set selectedItem(List<ItemTypes> value) {
    _selectedItem = value;
  }

  addItem(ItemTypes item){
    _selectedItem.add(item);
    notifyListeners();
  }
  removeItem(ItemTypes item){
    _selectedItem.remove(item);
    notifyListeners();
  }

  Map<String,dynamic> _allDatabyId={};

  Map<String, dynamic> get allDatabyId => _allDatabyId;

  set allDatabyId(Map<String, dynamic> value) {
    _allDatabyId = value;
  }
List<ItemTypes> _itemTyppesById=[];

  List<ItemTypes> get itemTyppesById => _itemTyppesById;

  set itemTyppesById(List<ItemTypes> value) {
    _itemTyppesById = value;
  }
  List<CheckList> _checkList=[];

  List<CheckList> get checkList => _checkList;

  set checkList(List<CheckList> value) {
    _checkList = value;
  }

  AddressesModel _addressesModelByOrderId=AddressesModel();

  AddressesModel get addressesModelByOrderId => _addressesModelByOrderId;

  set addressesModelByOrderId(AddressesModel value) {
    _addressesModelByOrderId = value;
  }

  getOrderByid(int id) async{
    loadingId=true;
    allDatabyId=await _serviceAPi.getAPi(ApiLink.GetOrderById, [id.toString()], {});

    if (allDatabyId["error"] != null) {
      print(allDatabyId["error"]);
    } else {
      orderByIdModel=OrderByIdModel.fromJson(allDatabyId["data"]);
      itemTyppesById = List<ItemTypes>.from(
          allDatabyId["data"]["itemTypes"].map((model) => ItemTypes.fromJson(model)));
   checkList=List<CheckList>.from(allDatabyId["data"]["checkList"].map((model)=>CheckList.fromJson(model)));
   addressesModelByOrderId=AddressesModel.fromJson(allDatabyId["data"]["address"]);
      if(orderByIdModel.orderStatusId==1||orderByIdModel.orderStatusId==2){
        await getCancelOrderReason();
      }
    }
    loadingId=false;
    notifyListeners();
  }

  bool _loadingButton=false;

  bool get loadingButton => _loadingButton;

  set loadingButton(bool value) {
    _loadingButton = value;
  }

  setOrderStatus(int idOrder,int statusId) async{
    loadingButton=true;
    await _serviceAPi.postAPi(ApiLink.SetOrderStatus,[idOrder.toString(),statusId.toString()], {}, [], {}, false);
    if (allData["error"] != null) {
      print(allData["error"]);
    }
    await getOrderByid(idOrder);
    await getOrders(0);
    loadingButton=false;
    notifyListeners();
  }


TextEditingController redeemCodeController=TextEditingController();
  Future<bool> redemCode() async{
  allData= await _serviceAPi.postAPi(ApiLink.redeemCode, [orderIdForRedeemCode.toString()],
        {'promoCode': redeemCodeController.text}, [], {}, false);
   if (allData["error"] != null) {
     messagePlaceOrder = allData["error"];
     return false;
   } else {
     messagePlaceOrder=allData["message"];
     return true;
   }
  }
  List<CancelOrderReasonModel> _cancelOrderReason=[];

  List<CancelOrderReasonModel> get cancelOrderReason => _cancelOrderReason;

  set cancelOrderReason(List<CancelOrderReasonModel> value) {
    _cancelOrderReason = value;
  }
Map<String,dynamic> _allDataReason={};

  Map<String, dynamic> get allDataReason => _allDataReason;

  set allDataReason(Map<String, dynamic> value) {
    _allDataReason = value;
  }
  TextEditingController cancelOrderController=TextEditingController();


  getCancelOrderReason() async{

allDataReason= await _serviceAPi.getAPi(ApiLink.getCancelOrderReason, [],
    {});
if(allDataReason['error']!=null){
  print(allDataReason['error']);
}else{
  cancelOrderReason=List<CancelOrderReasonModel>.from(allDataReason['data'].map((model)=> CancelOrderReasonModel.fromJson(model)));
}
notifyListeners();
  }

  cancelOrder(int idOrder,int idOfReason)async{

   await _serviceAPi.postAPi(ApiLink.cancelOrder, [idOrder.toString()], {
     'cancelStatus': idOfReason.toString(),
     'comments': cancelOrderController.text
   }, [], {}, false);
    await getOrderByid(idOrder);
   await getOrders(0);
    notifyListeners();
  }

  ratingOrder(int idOrder,int idRating) async{
    await _serviceAPi.postAPi(ApiLink.rateOrder,[idOrder.toString()], {
        'rating': idRating.toString()
    }, [], {}, false);
    if (allData["error"] != null) {
      print(allData["error"]);
    }
    await getOrderByid(idOrder);
    await getOrders(0);
    notifyListeners();


  }
  List<OtherOrder> selectedOrder = [];

  String promoCode;
}