import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';
import 'package:yallajeye/models/Adresses.dart';
import 'package:yallajeye/providers/order.dart';
import 'package:yallajeye/screens/order/promoCode.dart';
import 'package:yallajeye/screens/settings/addresses/create_update_address.dart';
import 'package:yallajeye/widgets/address_card.dart';
import 'package:yallajeye/widgets/custom_alert_dialog.dart';
import '../../providers/address.dart';
import '../../widgets/custom_alert_dialog_Peter.dart';
import 'adresses.dart';
import 'location.dart';

class LocationP extends StatefulWidget {
  const LocationP({Key key}) : super(key: key);

  @override
  _LocationPState createState() => _LocationPState();
}

class _LocationPState extends State<LocationP> {
  bool PlacedOrder = false;
  bool _isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    final address = Provider.of<AddressProvider>(context, listen: false);
    address.addressChoosen = AddressesModel();
    await address.getAllAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final address = Provider.of<AddressProvider>(context, listen: true);
    final order = Provider.of<OrderProvider>(context, listen: true);
    var screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: Icon(
            Icons.arrow_back,
            size: 41,
            color: Color.fromRGBO(254, 212, 48, 1),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          "Location",
          style: appBarText,
        ),
        foregroundColor: yellowColor,
        actions: [
          IconButton(
              onPressed: () {
                address.isCreateAddress = true;
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => CreateAddress()));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FittedBox(
                child: Text(
                  "Where do you want\nthings delivered?",
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: "BerlinSansFB",
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Type in new Address or choose an old one!",
                  style: TextStyle(fontSize: 17, fontFamily: "BerlinSansFB"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        final address =
                            Provider.of<AddressProvider>(context, listen: true);
                        return Container(
                          height: screenHeight * 0.3,
                          width: double.infinity,
                          color: Colors.white,
                          child: address.loading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : address.addresses.length == 0
                                  ? CupertinoButton(
                                      child: Text("Please add address"),
                                      onPressed: () {
                                        address.isCreateAddress = true;
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    CreateAddress()));
                                      })
                                  : Column(
                                      children: [
                                        CupertinoButton(
                                            child: Text("Pick Address"),
                                            onPressed: () {
                                              if (address.addressChoosen.id ==
                                                  0) {
                                                address.addressChoosen =
                                                    address.addresses[0];
                                                setState(() {});
                                              }
                                              Navigator.pop(context);
                                            }),
                                        // const Text("Pick Address",style: TextStyle(color: redColor,fontSize: 15,fontFamily: 'BerlinSansFB',),),
                                        Expanded(
                                          child: CupertinoPicker(
                                            backgroundColor: Colors.white,
                                            itemExtent: 30,
                                            scrollController:
                                                FixedExtentScrollController(
                                                    initialItem: 0),
                                            children: address.addresses
                                                .map((element) {
                                              return Text(element.title);
                                            }).toList(),
                                            onSelectedItemChanged: (value) {
                                              setState(() {
                                                address.addressChoosen =
                                                    address.addresses[value];
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                        );
                      });
                },
                child: Container(
                  padding: EdgeInsets.only(
                      left: screenHeight * 0.02, right: screenHeight * 0.02),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      address.addressChoosen.title.isEmpty
                          ? const Text(
                              "Address",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'BerlinSansFB',
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(135, 135, 135, 1),
                              ),
                            )
                          : Text(address.addressChoosen.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'BerlinSansFB',
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(135, 135, 135, 1),
                              )),
                      Icon(
                        FontAwesomeIcons.caretDown,
                        color: Color.fromRGBO(135, 135, 135, 1),
                      )
                    ],
                  ),
                ),
              ),
              address.addressChoosen.id == 0
                  ? Container(
                      height: screenHeight * 0.2,
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: AddressCard(
                        address.addressChoosen.title,
                        address.addressChoosen.city,
                        address.addressChoosen.street,
                        address.addressChoosen.buildingName,
                        address.addressChoosen.floorNumber.toString(),
                      ),
                    ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        // ElevatedButton(onPressed: (){
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) =>
                        //               PromoCode()));
                        // }, child: Text('Redeem code'),),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  showDialog(
                                      context: context,
                                      builder: (context) => CustomAlertDialogPeter(

                                            title:
                                                "Are you sure  you want to order? You can't change the order later",
                                            content: "",
                                            cancelBtnFn: () =>
                                          Navigator.pop(context, false),
                                            confrimBtnFn: () async {
                                              print("Loadingg");

                                              if (address.addressChoosen.id ==
                                                  0) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please choose an address",
                                                    fontSize: 15,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 2,
                                                    textColor: Colors.white,
                                                    backgroundColor: redColor,
                                                    toastLength:
                                                        Toast.LENGTH_SHORT);
                                              } else {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                // Navigator.of(context).pop();

                                                PlacedOrder = await order
                                                    .placeOrder(address
                                                        .addressChoosen.id);

    if (mounted) {
    setState(() {
    _isLoading = false;
    });
                                                if (!PlacedOrder) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(order
                                                              .messagePlaceOrder),
                                                        );
                                                      });
                                                } else {
                                             navToPromoCode();
                                                }}


                                                order.clearFields();
                                                address.addressChoosen =
                                                    AddressesModel();
                                              }
                                            },
                                          ));

                                },
                                child: Text("Place Order",
                                    style: TextStyle(
                                      color: yellowColor,
                                      fontFamily: 'BerlinSansFB',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    )),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF333333),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 40),
                                  side: const BorderSide(
                                      color: Colors.black, width: 1),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  // backgroundColor: const Color(0xFF333333)),),
                                ))),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
  void navToPromoCode(){

    Navigator.push(context, MaterialPageRoute(
        builder: (_) =>
            PromoCode()));
  }
}
