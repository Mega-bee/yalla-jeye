import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';
import 'package:yallajeye/models/getAllCities.dart';
import 'package:yallajeye/providers/address.dart';

class CreateAddress extends StatefulWidget {
  @override
  _CreateAddressState createState() => _CreateAddressState();
}

class _CreateAddressState extends State<CreateAddress> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void validate() {
    if (formkey.currentState.validate()) {
      // ignore: avoid_print
      print('Validated');
    } else {
      // ignore: avoid_print
      print('Not validated');
    }
  }

  //cutom class
  String validatePass(value) {
    if (value.isEmpty) {
      return 'Required *';
    } else if (value.length < 6) {
      return 'Should Se At Least 6 Characters';
    } else if (value.length > 15) {
      return 'Should Not Be More Than 15 characters';
    } else {
      return null;
    }
  }

  String message="";

  bool pressed = false;

  // String cityChoose;
  List regionsInfo = [];
  List regionName = ["1", "2"];
  bool _isLoading = false;
  bool _hasInternet;
  int i = 4;
  getAllCitiesModel getCities ;
  Future getAllCities() async {
    final address = Provider.of<AddressProvider>(context, listen: false);
    if(address.isCreateAddress){
      address.clearFields();
    }
    await address.getAllCities();
    if(!address.isCreateAddress){
      address.cityChoosen=address.listcity.firstWhere((element) => element.id == address.cityUpdateId);
    }

    return;
  }



  @override
  void initState() {
    getAllCities();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final address = Provider.of<AddressProvider>(context, listen: true);
    // context.read<AddressProvider>().getAllRegions();
    // regionsInfo = context.read<AddressProvider>().regions;

    // var appBar = AppBar(
    //   titleSpacing: 0,
    //   leading: IconButton(
    //     onPressed: () {
    //       Navigator.of(context).pop();
    //     },
    //     icon: Icon(Icons.arrow_back, color: yellowColor),
    //   ),
    //   title: Text(
    //     "Address",
    //     style: appBarText,
    //   ),
    //   iconTheme: IconThemeData(color: yellowColor),
    // );
    var screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    // return Consumer<AddressProvider>(
    //   builder: (context, val, child) {
    //     print("regions from provider:${val.regions}");
    return Scaffold(
      appBar: AppBar(title:  Text(
        "Address",
        style: appBarText,
      ),foregroundColor: yellowColor,
     ),
      body: SingleChildScrollView(
        child: Container(
          // height: screenHeight * 1.15,
          padding: EdgeInsets.fromLTRB(25, 15, 25, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Text(
                 address.isCreateAddress? "Add new address" : "Update your address",
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: "BerlinSansFB",
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: screenHeight = MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top * 3,
                width: double.infinity,
                padding: EdgeInsets.only(top: 5.0, bottom: 0.0),
                child:

                //   child:
                  Column(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Center(
                          child: Form(
                            //  autovalidateMode: AutovalidateMode.onUserInteraction,
                            key: formkey,
                            child: Column(children: [
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: address.addresstitle,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: screenHeight * 0.02,
                                      bottom: screenHeight * 0.03,
                                      top: screenHeight * 0.03),
                                  hintText: 'Adress title',
                                  hintStyle: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'BerlinSansFB',
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(135, 135, 135, 1),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return " Please enter your title!";
                                  } else if (value.isNotEmpty) {
                                    return null;
                                  }
                                },
                              ),
                              //address title
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02),
                              GestureDetector(
                                onTap: (){
                                  showCupertinoModalPopup(context: context, builder: (context){
                                    final address=Provider.of<AddressProvider>(context,listen: true);
                                    return Container(
                                      height: screenHeight *0.3,
                                      width: double.infinity,
                                      color: Colors.white,
                                      child:
                                      address.cityLoading?Center(child: CircularProgressIndicator(),):
                                      Column(
                                        children: [
                                          CupertinoButton(child: Text("Pick City"), onPressed: (){
                                            if(address.cityChoosen.id==0){
                                              address.cityChoosen=address.listcity[0];
                                              setState(() {});
                                            }
                                            Navigator.of(context).pop();
                                          }), Expanded(
                                            child: CupertinoPicker(
                                              backgroundColor: Colors.white,
                                              itemExtent: 30,
                                              scrollController: FixedExtentScrollController(initialItem: 0),
                                              children: address.listcity.map((element){
                                                return Text(element.location);
                                              }).toList() ,
                                              onSelectedItemChanged: (value) {
                                                setState(() {
                                                  address.cityChoosen=address.listcity[value];
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                },
                                child:  Container(
                                  padding:EdgeInsets.only(
                                      left: screenHeight * 0.02,
                                      right: screenHeight * 0.02),
                                  margin:const EdgeInsets.symmetric(vertical: 10),
                                  width:double.infinity,
                                  height: 50,
                                  decoration:  BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:   BorderRadius.circular(15.0),
                                  ),
                                  child: Row(

                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      address.cityChoosen.location.isEmpty? const Text("Cities",style:  TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'BerlinSansFB',
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(135, 135, 135, 1),
                                      ),):Text(address.cityChoosen.location,style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'BerlinSansFB',
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(135, 135, 135, 1),)),
                                      Icon(FontAwesomeIcons.caretDown, color: Color.fromRGBO(135, 135, 135, 1),)
                                    ],
                                  ),
                                ),
                              ),





                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02),
                              TextFormField(
                                controller: address.street,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: screenHeight * 0.03,
                                      bottom: screenHeight * 0.03,
                                      top: screenHeight * 0.03),
                                  hintText: 'street',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'BerlinSansFB',
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(135, 135, 135, 1),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return " Please enter your street!";
                                  } else if (value.isNotEmpty) {
                                    return null;
                                  }
                                },
                              ),
                              //street
                              SizedBox(height: screenHeight * 0.02),
                              TextFormField(
                                controller: address.buildingName,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: screenHeight * 0.03,
                                      bottom: screenHeight * 0.03,
                                      top: screenHeight * 0.03),
                                  hintText: 'Building',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'BerlinSansFB',
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(135, 135, 135, 1),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return " Please enter your Building!";
                                  } else if (value.isNotEmpty) {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(2)
                                ],
                                controller: address.floor,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: screenHeight * 0.03,
                                      bottom: screenHeight * 0.03,
                                      top: screenHeight * 0.03),
                                  hintText: 'Floor',
                                  hintStyle:const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'BerlinSansFB',
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(135, 135, 135, 1),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return " Please enter your floor!";
                                  } else if (value.isNotEmpty) {
                                    return null;
                                  }
                                },
                              ),
                              //floor
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              TextFormField(
                                controller: address.description,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: screenHeight * 0.03,
                                      bottom: screenHeight * 0.03,
                                      top: screenHeight * 0.03),
                                  hintText: 'Description',
                                  hintStyle:const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'BerlinSansFB',
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(135, 135, 135, 1),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return " Please enter your description!";
                                  } else if (value.isNotEmpty) {
                                    return null;
                                  }
                                },
                              ),
                              //description
                              Flexible(
                                  flex: 2,
                                  child: SizedBox(height: screenHeight * 0.06)),
                              _isLoading
                                  ? CircularProgressIndicator()
                                  : Center(
                                      child: Column(children: [
                                      Container(
                                        height: screenHeight * 0.1,
                                        child: ElevatedButton(
                                          onPressed: () async {

                                            if (!formkey.currentState
                                                .validate()) {
                                              return;
                                            } else {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              if(address.isCreateAddress){
                                                message= await address.createAddress();
                                              }else{
                                                message=await address.updateAddress();
                                              }



                                              await address.getAllAddresses();
                                              showDialog(
                                                // barrierDismissible: false,
                                                  context: context, builder: (context){
                                                return  AlertDialog(
                                                  title: Text(message),
                                                );
                                              });



                                            }
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          await  Future.delayed(Duration(milliseconds: 1500));
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            address.clearFields();
                                          },
                                          child:
                                          FittedBox(child: Text(address.isCreateAddress?'Add':"Update")),
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.fromLTRB(
                                                screenHeight * 0.07,
                                                screenHeight * 0.03,
                                                screenHeight * 0.07,
                                                screenHeight * 0.03),
                                            onPrimary: const Color.fromRGBO(
                                                254, 212, 48, 1),
                                            primary: const Color.fromRGBO(
                                                51, 51, 51, 1),
                                            shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(15.0),
                                            ),
                                          ),
                                        ),
                                      )
                                    ])),
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

            ],
          ),
        ),
      ),
    );
    // },
    // );
  }

  Container AddButton(double screenHeight) {
    final address = Provider.of<AddressProvider>(context, listen: false);
    return Container(
      height: screenHeight * 0.1,
      child: ElevatedButton(
        onPressed: () async {
          // if (await address.createAddress()) print("Address Created");
        },
        child: FittedBox(child: Text('Add')),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.fromLTRB(screenHeight * 0.07, screenHeight * 0.03,
              screenHeight * 0.07, screenHeight * 0.03),
          onPrimary: Color.fromRGBO(254, 212, 48, 1),
          primary: Color.fromRGBO(51, 51, 51, 1),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(15.0),
          ),
        ),
      ),
    );
  }

  addAddress() async {
    if (!formkey.currentState.validate()) {
      return;
    } else {
      try {
        FocusScope.of(context).unfocus();
        setState(() {
          _isLoading = true;
        });
        formkey.currentState.save();
        // _hasInternet = await InternetConnectionChecker().hasConnection;
        if (_hasInternet == false) {
          // showSimpleNotification(Text(
          //   'No internet Connection',
          //   textAlign: TextAlign.center,
          // ));
          _isLoading = false;
          return;
        }
        // var response = await ApiCall().createAddress(
        //     title: titleController.text,
        //     description: descriptionController.text,
        //     buildingName: buildingController.text,
        //     floorNumber: floorController.text,
        //     street: streetController.text,
        //     cityId: cityChoose,
        //     id: 2);
        print("inside button addAddress");
        // print(response["message"]);
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        // buildShowDialog(context, response["message"].toString());
        //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SettingProfile()), (route) => false);
      } on HttpException catch (e) {
        var errorMessage = 'Unable to add new address';
        {
          // buildShowDialog(context, errorMessage);
          setState(() {
            _isLoading = false;
          });
        }
      } catch (error) {
        print(error);
        var errorMessage = 'please try again later';
        // buildShowDialog(context, errorMessage);
        setState(() {
          _isLoading = false;
        });
      }
      print('Validated');
    }
  }
}
