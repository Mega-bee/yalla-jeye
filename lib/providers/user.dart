import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yallajeye/Services/ApiLink.dart';
import 'package:yallajeye/Services/ServiceAPi.dart';
import 'package:yallajeye/models/driver/driver_orders.dart';
import 'package:yallajeye/models/driver/order_details.dart';
import '../models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


enum Status {
  isVerified, //inside application
  isAnonymous,
  isother,
  isDriver,
}

class UserProvider with ChangeNotifier {
  ServiceAPi _serviceAPi = ServiceAPi();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController forgetPassword = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController insta = TextEditingController();
  TextEditingController facebook = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController birthday = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController zipcode = TextEditingController();
  TextEditingController cityname = TextEditingController();
  TextEditingController apartment = TextEditingController();
  TextEditingController street = TextEditingController();

  TextEditingController shopnumber = TextEditingController();
  TextEditingController buldingname = TextEditingController();
  TextEditingController floornumber = TextEditingController();
  TextEditingController district = TextEditingController();

  TextEditingController shopname = TextEditingController();
  TextEditingController specialist = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController emailChat = TextEditingController();

  TextEditingController loyatlypoint = TextEditingController();
  String dateTimeRandom = DateTime(1996,04,01).toString().split(' ').first;

  clearControllers() {
    password.clear();
    confirmpassword.clear();
    oldPassword.clear();
  }

  String _birthDate = "";
  String _imageUrl = "";
  Map<String, dynamic> _allData = {};

  Map<String, dynamic> get allData => _allData;

  set allData(Map<String, dynamic> value) {
    _allData = value;
  }

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
  }

  String get birthDate => _birthDate;

  set birthDate(String value) {
    _birthDate = value;
  }

  Status _status = Status.isAnonymous;

  Status get status => _status;

  set status(Status value) {
    _status = value;
    notifyListeners();
  }

  String _messagelogin = "";
  String _messageSignUp = "";
  String _messageNextSignUp = "";
  String _forgetpass = '';
  String _messageUpdateInfo = "";

  String get messageUpdateInfo => _messageUpdateInfo;

  set messageUpdateInfo(String value) {
    _messageUpdateInfo = value;
  }

  String get forgetpass => _forgetpass;

  set forgetpass(String value) {
    _forgetpass = value;
  }

  String get messageNextSignUp => _messageNextSignUp;

  set messageNextSignUp(String value) {
    _messageNextSignUp = value;
  }

  String get messagelogin => _messagelogin;

  set messagelogin(String value) => _messagelogin = value;

  String get messageSignUp => _messageSignUp;

  set messageSignUp(String value) => _messageSignUp = value;

  UserProvider.statusfunction() {
    getdata();
  }

  getdata() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    emailChat.text = sh.getString('email');

    if (sh.getBool("logged") ?? false) {
      if(sh.getString("role")=="user"){
        _status = Status.isVerified;
      }else{
        _status = Status.isDriver;
      }
      notifyListeners();
    } else if (sh.getBool("wlkdone") ?? false) {
      _status = Status.isAnonymous;
      notifyListeners();
    }
  }

  String _message = "";

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  int _id = 0;

  Gender _genderId = Gender(0, "");

  Gender get genderId => _genderId;

  set genderId(Gender value) {
    _genderId = value;
  }


  Future<bool> SignIn() async {
    String tokenFire = await FirebaseMessaging.instance.getToken();
    allData = await _serviceAPi.postAPiUser(
        ApiLink.login,
        {
          'Email': email.text.toString(),
          'Password': password.text.toString(),
          'DeviceToken': tokenFire ?? '',
        },
        [],
        {},
        false);
    if (allData["error"] != null) {
      print("${allData["error"]}");
      message = allData["error"];
      // if(allData["isAnonymous"]=true){
      //   _status=Status.isAnonymous;
      // }else{}
      return false;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", allData["data"]["data"]["token"]);
      prefs.setString("email", allData["data"]["data"]["email"]);

      prefs.setString('imageUrl', allData['data']['data']['imageUrl'] ?? "");


      // prefs.setString("isVerified", allData["isVerified"]);
      if (allData["isVerified"] == true) {
        if(allData['data']['data']['role'].toLowerCase()=="user"){
          prefs.setString("role", "user");
          _status = Status.isVerified;
        }else{
          prefs.setString("role", "driver");
          prefs.setString("driverId", allData["data"]["data"]["id"].toString());
          prefs.setBool("driverIsActive", allData["data"]["data"]["isActive"]);
          _status = Status.isDriver;
        }

      } else {
        _status = Status.isAnonymous;
      }
      // allData["data"]["isVerified"]==true?_status=Status.isVerified:
      // _status=Status.isAnonymous;
      return true;
    }
  }

  signUp(File image)async{
    String tokenFire = await FirebaseMessaging.instance.getToken();
    // FirebaseMessaging.instance.getToken().then((tokenFire) async {
    //   tokenIre = tokenFire ?? '';
    // });
      List<File> imageList = [];
      if (image != null) {
        imageList.add(image);
      }
      print(birthday.text);
      print('DATE DATE DATE');
      allData = await _serviceAPi.postAPiUser(ApiLink.Register, {
        'Email': email.text.toString(),
        'Password': password.text.toString(),
        'ConfirmPassword': confirmpassword.text.toString(),
        'Name': name.text.toString(),
        'GenderId': genderId.id.toString(),
        'PhoneNumber': phoneNumber.text.toString(),
        'Birthdate': birthday.text.isEmpty ?dateTimeRandom : birthday.text.toString(),
        'DeviceToken': tokenFire ??''
      }, imageList, {}, false);
      print("requseee" '$allData');
      if (allData["error"] != null) {

        print("${allData["error"]}");
        message = allData["error"];
        return false;
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", allData['data']["data"]["token"]);
        prefs.setString("email", allData['data']["data"]["email"]);
        print("Token iss: ${prefs.getString("token")}");
        print("EMAIL iss: ${prefs.getString("email")}");
        prefs.setString('imageUrl', allData['data']['data']['imageUrl'] ?? "");
        prefs.setString(
            'phoneNumber', allData['data']['data']['phoneNumber'] ?? "");
        print("Token iss: ${prefs.getString("token")}");
        prefs.commit();
        return true;
      }

  }
  resendOtp(String number) async{
    await _serviceAPi.postAPi(ApiLink.resendOtp, [], {
      "phone":number
    }, [], {}, false);
  }
  generateOtp(String number) async{
    await _serviceAPi.postAPi(ApiLink.generateOtp, [], {
      "phone":number
    }, [], {}, false);
  }
 Future<bool> confirmOtp(String number,String otp) async{
    allData = await _serviceAPi.postAPi(ApiLink.confirmOtp, [], {
      'otp': otp,
      'phone': number
    }, [],
        {}, false);
    if(allData['error']!=null){
      print("${allData["error"]}");
      message = allData["error"];
      return false;
    }else{
      SharedPreferences sh=await SharedPreferences.getInstance();
      sh.setBool("logged", true) ;
        sh.setString("role","user");
      _status=Status.isVerified;
      return true;
    }
  }

  Future<bool> confirmAccountOtp(String number) async{
    allData = await _serviceAPi.postAPi(ApiLink.confirmAccountOtp, [], {
      'phone': number
    }, [],
        {}, false);
    if(allData['error']!=null){
      print("${allData["error"]}");
      message = allData["error"];
      return false;
    }else{
      return true;
    }
  }

  List<Gender> genderIdList = [Gender(1, "Male"), Gender(2, "Female"),Gender(3, "Rather not to say")];

  Future<bool> forgetpasswordWithPhone(String phoneNumber) async {
    allData = await _serviceAPi.postAPi(
        ApiLink.ForgetPasswordWithPhone, [], {
          "identifier":phoneNumber
    }, [], {}, false);
    if (allData["error"] != null) {
      print("${allData["error"]}");
      message = allData["error"];
      return false;
    } else {
      return true;
    }
  }

  Future<bool> ConfirmEmail() async {
    allData =
        await _serviceAPi.postAPi(ApiLink.ConfirmEmail, [], {}, [], {}, false);
    if (allData["error"] != null) {
      print("${allData["error"]}");
      message = allData["error"];
      return false;
    } else {
      return true;
    }
  }

  Future<bool> ResetPassword() async {
    allData = await _serviceAPi.postAPi(
        ApiLink.ResetPassword,
        [],
        {
          'OldPassword': oldPassword.text,
          'NewPassword': password.text,
          'ConfirmPassword': confirmpassword.text
        },
        [],
        {},
        false);
    if (allData["error"] != null) {
      print("${allData["error"]}");
      message = allData["error"];
      return false;
    } else {
      return true;
    }
  }
  Future<bool> SetNewPasswordWithPhone(String phone ,String pass ,String confirmPass) async {
    allData = await _serviceAPi.postAPi(
        ApiLink.resetPasswordPhone,
        [],
        {
          'PhoneNumber': phone,
          'NewPassword': pass,
          'ConfirmPassword':confirmPass
        },
        [],
        {},
        false);
    if (allData["error"] != null) {
      print("${allData["error"]}");
      message = allData["error"];
      return false;
    } else {
      return true;
    }
  }

  getUserProfile() async {
    allData = await _serviceAPi.getAPi(ApiLink.GetUserProfile, [], {});
    if (allData["error"] != null) {
      print(allData["error"]);
    } else {
      name.text = allData['data']['name'];
      phoneNumber.text = allData['data']['phoneNumber'];
      birthDate = birthDate.toString();
      birthday.text = allData['data']['birthDate'];
      // imageUrl=imageUrl.toString();
      imageUrl = allData["data"]["imageUrl"];
      print("iamge is:${imageUrl}");
      notifyListeners();
    }
  }

  Future<bool> UpdateProfile(File image) async {
    List<File> imageList = [];
    if (image != null) {
      imageList.add(image);
    }
    allData = await _serviceAPi.postAPi(
        ApiLink.UpdateProfile,
        [],
        {
          'Name': name.text.toString(),
          'PhoneNumber': phoneNumber.text.toString(),
          'BirthDate': birthday.text.toString()
        },
        imageList,
        {},
        false);
    if (allData["error"] != null) {
      print("${allData["error"]}");
      message = allData["error"];
      return false;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("name", allData["data"]["name"]);
      prefs.setString('imageUrl', allData['data']['imageUrl'] ?? "");
      prefs.setString('phoneNumber', allData['data']['phoneNumber'] ?? "");
      print("Token iss: ${prefs.getString("imageUrl")}");
      return true;
    }
  }

  clearAllTextController() {
    status = Status.isAnonymous;
    oldPassword.clear();
    email.clear();
    insta.clear();
    facebook.clear();
    confirmpassword.clear();
    password.clear();
    password1.clear();
    name.clear();
    phoneNumber.clear();
    birthday.clear();
    gender.clear();
    zipcode.clear();
    cityname.clear();
    apartment.clear();
    street.clear();

    shopnumber.clear();
    buldingname.clear();
    floornumber.clear();
    district.clear();

    shopname.clear();
    specialist.clear();
    bio.clear();

    loyatlypoint.clear();
  }

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount _user;

  GoogleSignInAccount get user => _user;

  set user(GoogleSignInAccount value) {
    _user = value;
  }

  String _idToken = "";

  String get idToken => _idToken;

  set idToken(String value) {
    _idToken = value;
  }

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      idToken = googleAuth.idToken;
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

  Future<bool> signInWithFacebook() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance
          .login(permissions: ['email', 'public_profile']);

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken.token);
      final UserData = await FacebookAuth.instance.getUserData();

      prefs.setString("email", UserData['email']);
      prefs.setString('imageUrl', UserData['picture']['data']['url']);

      // Once signed in, return the UserCredential
      FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      status = Status.isVerified;
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future logoutFacebook() async {
    await FacebookAuth.instance.logOut();
    FirebaseAuth.instance.signOut();
  }


  ///Driver Provider///
toggleActivity()async{
  allData=  await _serviceAPi.postAPi(ApiLink.setToggleActivity, [], {}, [], {}, false);
  if (allData["error"] != null) {
    print("${allData["error"]}");
    message = allData["error"];
    return false;
  } else {
    return true;
  }

}
List<DriverOrder> _listOfDriverOrder=[];

  List<DriverOrder> get listOfDriverOrder => _listOfDriverOrder;

  set listOfDriverOrder(List<DriverOrder> value) {
    _listOfDriverOrder = value;
  }

  getDriverOrders()async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String id=prefs.getString("driverId");
    allData=await  _serviceAPi.getAPi(ApiLink.getDriverOrders, [id], {});
      if (allData["error"] != null) {
        print("${allData["error"]}");
        message = allData["error"];
        listOfDriverOrder=[];
        notifyListeners();
        return false;
      }else{
        listOfDriverOrder=List<DriverOrder>.from(allData["data"].map((model)=> DriverOrder.fromJson(model)));
        notifyListeners();
        return true;
      }
    }catch(e){
      listOfDriverOrder=[];
      notifyListeners();
      return false;
    }

}

DriverOrderDetails _orderDetails=DriverOrderDetails();

  DriverOrderDetails get orderDetails => _orderDetails;

  set orderDetails(DriverOrderDetails value) {
    _orderDetails = value;
  }

  getDriverOrderDetails(int orderId)async{
    List<String> id=[];
    id.add(orderId.toString());
    allData=await _serviceAPi.getAPi(ApiLink.getDriverOrderDetails, id,
        {});
    if (allData["error"] != null) {
      print("${allData["error"]}");
      message = allData["error"];
      orderDetails=DriverOrderDetails();
    }else{
      orderDetails=DriverOrderDetails.fromJson(allData['data']);
    }
    notifyListeners();
}

setDriverOrderStatus(int orderId,int statusId)async{
    List<String> id=[];
    id.add(orderId.toString());
    id.add(statusId.toString());
    allData=await _serviceAPi.postAPi(ApiLink.setDriverOrderStatus, id, {} , [], {}, false);
    if (allData["error"] != null) {
      print("${allData["error"]}");
      message = allData["error"];
      return false;
    }else{
      return true;
    }
}

Future<bool> markItemAsDone(int id) async{
    List<String> idList=[];
    idList.add(id.toString());
    allData=await _serviceAPi.postAPi(ApiLink.markItemAsDone, idList, {}, [],
        {}, false);
    if (allData["error"] != null) {
      print("${allData["error"]}");
      message = allData["error"];
      return false;
    }else{
      return true;
    }
}
}
