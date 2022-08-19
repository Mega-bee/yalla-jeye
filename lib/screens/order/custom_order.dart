import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';
import 'package:yallajeye/main.dart';
import 'package:yallajeye/models/home_page.dart';
import 'package:yallajeye/providers/address.dart';
import 'package:yallajeye/providers/homePage.dart';
import 'package:yallajeye/providers/order.dart';
import 'package:yallajeye/providers/user.dart';
import 'package:yallajeye/screens/auth/signin_screen.dart';
import 'package:yallajeye/screens/order/other_order.dart';

import 'package:yallajeye/screens/settings/addresses/create_update_address.dart';
import 'package:yallajeye/widgets/custom_alert_dialog.dart';

import 'Loaction_page.dart';

class CustomOrder extends StatefulWidget {
  const CustomOrder({Key key}) : super(key: key);

  @override
  _CustomOrderState createState() => _CustomOrderState();
}

class _CustomOrderState extends State<CustomOrder> {
  final _formKey = GlobalKey<FormState>();
  int groupVALUE;
  bool isExpanded;
  bool expanded = false;

  String dropdownvalue = 'Delivery';
  ItemTypes _selectedPackage;
  DestinationPlace _selectedPlace;

  TextEditingController _name = TextEditingController();
  TextEditingController _Location = TextEditingController();
  var itemsg;
  var itePlace;
  num totalFees = 0;
  // List of items in our dropdown menu
  var items = [
    'Delivery',
    'Delivery + order',
  ];

  clearData() {
    final order = Provider.of<OrderProvider>(context, listen: false);
    order.show = false;
    order.selectedItem = [];
    order.selectedTypeId = [];
    order.orderDetails.clear();
  }

  getAddressData() async {
    final address = Provider.of<AddressProvider>(context, listen: false);
    await address.getAllAddresses();
  }

  @override
  void initState() {
    final homePage = Provider.of<HomePageProvider>(context, listen: false);
    _selectedPackage = homePage.itemTypes.last;
    itemsg = homePage.itemTypes.map((item) {
      return DropdownMenuItem<ItemTypes>(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.title),
              Text(
                item.price.toString() + 'LL',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        value: item,
      );
    }).toList();

    itePlace = _selectedPackage.places.map((item) {
      return DropdownMenuItem<DestinationPlace>(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.title),
            ],
          ),
        ),
        value: item,
      );
    }).toList();
    clearData();
    getAddressData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true);

    Future<bool> onBackPressed() {
      return showDialog(
          context: context,
          builder: (context) => CustomAlertDialog(
              title: "Do you want to cancel your order?",
              content: "",
              cancelBtnFn: () => Navigator.pop(context, false),
              confrimBtnFn: () => Navigator.pop(context, true)));
    }

    final order = Provider.of<OrderProvider>(context);
//    final heightSize = MediaQuery.of(context).size.height;
//    final homePage = Provider.of<HomePageProvider>(context, listen: true);
    final address = Provider.of<AddressProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: onBackPressed,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: user.status == Status.isVerified
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return showAlertWithOption();
                        });
                  },
                )
              : Container(),
          backgroundColor: Colors.grey.shade100,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
              title: Text('Add order'),
              leading: IconButton(
                onPressed: () {
                  (user.status == Status.isVerified &&
                          order.selectedOrder.isNotEmpty)
                      ? showDialog(
                          context: context,
                          builder: (context) => CustomAlertDialog(
                              title: "Do you want to cancel your order?",
                              content: "",
                              cancelBtnFn: () => Navigator.pop(context, false),
                              confrimBtnFn: () {
                                order.selectedOrder.clear();
                                Navigator.pop(context);
                                Navigator.of(context).pop();
                              }))
                      : Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 41,
                  color: Color.fromRGBO(254, 212, 48, 1),
                ),
              )),
          body: user.status == Status.isVerified
              ? CustomScrollView(slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            order.selectedOrder.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 200),
                                      Center(
                                          child: Image.asset(
                                        'assets/images/add_order.png',
                                        height: 200,
                                      )),
                                      Center(
                                          child: Text(
                                        'Add new order',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ],
                                  )
                                : Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Your Destination',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ListView.builder(
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Card(
                                                elevation: 5,
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Name: ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(order
                                                                  .selectedOrder[
                                                                      index]
                                                                  .name),
                                                            ],
                                                          ),
                                                          InkWell(
                                                            child: Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                            ),
                                                            onTap: () {
                                                              totalFees = totalFees -
                                                                  order
                                                                      .selectedOrder[
                                                                          index]
                                                                      .price;
                                                              order
                                                                  .selectedOrder
                                                                  .removeAt(
                                                                      index);

                                                              setState(() {});
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                              (order
                                                  .selectedOrder[
                                              index]
                                                  .palceName.isNotEmpty ?    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:   Row(
                                                        children: [
                                                          Text(
                                                            'Place name: ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          Text(order
                                                              .selectedOrder[
                                                          index]
                                                              .palceName ?? ''),
                                                        ],
                                                      ),
                                                    ) : Container()),
                                                    order.selectedOrder[index]
                                                            .location.isEmpty
                                                        ? Container()
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Location: ',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Text(order
                                                                    .selectedOrder[
                                                                        index]
                                                                    .location),
                                                              ],
                                                            ),
                                                          ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Items: ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Expanded(
                                                              child: Text(order
                                                                  .selectedOrder[
                                                                      index]
                                                                  .description)),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Fees: ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Expanded(
                                                              child: Text(order
                                                                  .selectedOrder[
                                                                      index]
                                                                  .price
                                                                  .toString())),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: order.selectedOrder.length,
                                          shrinkWrap: true,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Total fees: ${totalFees}'
                                                  'L.L',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    if (address
                                                            .addresses.length ==
                                                        0) {
                                                      address.isCreateAddress =
                                                          true;
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  LocationP()));
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  CreateAddress()));
                                                    } else {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  LocationP()));
                                                    }

                                                    // order.clearFields();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        'Order',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Icon(Icons.arrow_forward,
                                                          color: Colors.white)
                                                    ],
                                                  ),
                                                  style: TextButton.styleFrom(
                                                      side: const BorderSide(
                                                          color: Colors.black,
                                                          width: 1),
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF333333)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Divider(
                                            thickness: 2,
                                            height: 2,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
//                            Container(
//                              decoration: BoxDecoration(
//                                  color: Colors.white,
//                                  boxShadow: [
//                                    BoxShadow(
//                                      color: Colors.grey.withOpacity(0.5),
//                                      spreadRadius: 5,
//                                      blurRadius: 7,
//                                      offset: Offset(
//                                          0, 3), // changes position of shadow
//                                    ),
//                                  ],
//                                  borderRadius: BorderRadius.circular(12)),
//                              child: Padding(
//                                padding: const EdgeInsets.all(12.0),
//                                child: Column(
//                                  mainAxisAlignment: MainAxisAlignment.start,
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: [
//                                    const Text(
//                                      'Order type:',
//                                      style: TextStyle(
//                                          fontSize: 16,
//                                          fontWeight: FontWeight.bold),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(12.0),
//                                      child: Container(
//                                        decoration: BoxDecoration(
//                                            borderRadius:
//                                                BorderRadius.circular(12),
//                                            color: Colors.grey.shade100,
//                                            shape: BoxShape.rectangle),
//                                        child: DropdownButton(
//                                          value: dropdownvalue,
//                                          borderRadius:
//                                              BorderRadius.circular(12),
//                                          dropdownColor: Colors.grey.shade100,
//                                          underline: Container(),
//                                          icon: const Icon(
//                                              Icons.keyboard_arrow_down),
//                                          isExpanded: true,
//                                          items: items.map((String items) {
//                                            return DropdownMenuItem(
//                                              value: items,
//                                              child: Padding(
//                                                padding:
//                                                    const EdgeInsets.all(10.0),
//                                                child: Text(items),
//                                              ),
//                                            );
//                                          }).toList(),
//                                          onChanged: (String newValue) {
//                                            setState(() {
//                                              dropdownvalue = newValue;
//                                            });
//                                          },
//                                        ),
//                                      ),
//                                    ),
//
//                                    const Text(
//                                      'Destination:',
//                                      style: TextStyle(
//                                          fontSize: 16,
//                                          fontWeight: FontWeight.bold),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(12.0),
//                                      child: Container(
//                                        decoration: BoxDecoration(
//                                            borderRadius:
//                                                BorderRadius.circular(12),
//                                            color: Colors.grey.shade100,
//                                            shape: BoxShape.rectangle),
//                                        child: DropdownButton<ItemTypes>(
//                                          items: itemsg,
//                                          isExpanded: true,
//                                          borderRadius:
//                                              BorderRadius.circular(12),
//                                          dropdownColor: Colors.grey.shade100,
//                                          underline: Container(),
//                                          onChanged: (newVal) => setState(
//                                              () => _selectedPackage = newVal),
//                                          value: _selectedPackage,
//                                        ),
//                                      ),
//                                    ),
//
////                                    AnimatedContainer(
////                                      padding: const EdgeInsets.all(8),
////                                      margin: EdgeInsets.only(bottom: 20),
////                                      // height: heightSize * 0.2,
////                                      decoration: const BoxDecoration(
////                                        color: Colors.white,
////                                        borderRadius:
////                                        BorderRadius.all(Radius.circular(15)),
////                                      ),
////                                      duration: const Duration(milliseconds: 500),
////                                      child: Column(
////                                        // mainAxisAlignment: MainAxisAlignment.start
////                                        children: [
////                                          SizedBox(
////                                            height: heightSize * 0.05,
////                                            width: double.maxFinite,
////                                            child: order.selectedItem.isEmpty
////                                                ? InkWell(
////                                              onTap: () {
////                                                setState(() {
////                                                  order.show = !order.show;
////                                                });
////                                              },
////                                              child: Row(
////                                                mainAxisAlignment:
////                                                MainAxisAlignment.spaceAround,
////                                                children: [
////                                                   Text(
////                                                    "Please choose one",
////                                                    style: TextStyle(
////                                                        decoration: TextDecoration
////                                                            .underline,
////                                                        fontFamily:
////                                                        'BerlinSansFB',
////                                                        fontSize: 15,
////                                                        fontWeight:
////                                                        FontWeight.bold),
////                                                  ),
////                                                  Icon(
////                                                      FontAwesomeIcons.caretDown),
////                                                ],
////                                              ),
////                                            )
////                                                : ListView.separated(
////                                                separatorBuilder:
////                                                    (context, index) =>
////                                                const SizedBox(
////                                                  width: 10,
////                                                ),
////                                                scrollDirection: Axis.horizontal,
////                                                itemCount:
////                                                order.selectedItem.length,
////                                                itemBuilder: (context, index) {
////                                                  return Chip(
////                                                    label: Text(order
////                                                        .selectedItem[index].title),
////                                                    backgroundColor: yellowColor,
////                                                  );
////                                                }),
////                                          ),
////                                          order.show
////                                              ? Column(
////                                            children: [
////                                              ListView.builder(
////                                                shrinkWrap: true,
////                                                physics:
////                                                NeverScrollableScrollPhysics(),
////                                                itemBuilder: (context, index) {
////                                                  return Column(
////                                                    children: [
////                                                      CheckboxListTile(
////                                                        side: BorderSide(
////                                                            color: Colors.black),
////                                                        controlAffinity:
////                                                        ListTileControlAffinity
////                                                            .leading,
////                                                        title: Text(
////                                                            "${homePage.itemTypes[index].title}"),
////                                                        value: order.selectedItem
////                                                            .contains(homePage
////                                                            .itemTypes[
////                                                        index]),
////                                                        onChanged: (value) {
////                                                          setState(() {
////                                                            if (value) {
////                                                              order.addItem(homePage
////                                                                  .itemTypes[
////                                                              index]);
////
////                                                              order.selectedTypeId
////                                                                  .add(homePage
////                                                                  .itemTypes[
////                                                              index]
////                                                                  .id);
////                                                            } else {
////                                                              order.removeItem(
////                                                                  homePage.itemTypes[
////                                                                  index]);
////                                                              order.selectedTypeId
////                                                                  .remove(homePage
////                                                                  .itemTypes[
////                                                              index]
////                                                                  .id);
////                                                            }
////                                                          });
////                                                        },
////                                                      ),
////                                                    ],
////                                                  );
////                                                },
////                                                itemCount:
////                                                homePage.itemTypes.length,
////                                              ),
////                                              InkWell(
////                                                onTap: () {
////                                                  _showDialog();
////                                                },
////                                                child: Container(
////                                                  color: Colors.yellow.shade100,
////                                                  child: Padding(
////                                                    padding:
////                                                    const EdgeInsets.all(8.0),
////                                                    child: Row(
////                                                      mainAxisAlignment:
////                                                      MainAxisAlignment
////                                                          .spaceAround,
////                                                      children: [
////                                                        Text('Other'),
////                                                        Icon(Icons.add_circle)
////                                                      ],
////                                                    ),
////                                                  ),
////                                                ),
////                                              )
//////                                            TextFormField(
//////                                              controller: order.otherType,
//////                                              decoration: const InputDecoration(
//////                                                  focusedErrorBorder: OutlineInputBorder(
//////                                                      borderSide: BorderSide(
//////                                                          color: redColor),
//////                                                      borderRadius: BorderRadius.all(
//////                                                          Radius.circular(15))),
//////                                                  errorBorder: OutlineInputBorder(
//////                                                      borderSide: BorderSide(
//////                                                          color: redColor),
//////                                                      borderRadius: BorderRadius.all(
//////                                                          Radius.circular(15))),
//////                                                  filled: true,
//////                                                  fillColor: Colors.white,
//////                                                  contentPadding:
//////                                                      EdgeInsets.all(25),
//////                                                  hintText: 'Other',
//////                                                  hintStyle: TextStyle(
//////                                                      fontFamily:
//////                                                          'BerlinSansFB',
//////                                                      fontSize: 15,
//////                                                      fontWeight:
//////                                                          FontWeight.bold),
//////                                                  border: OutlineInputBorder(),
//////                                                  enabledBorder: OutlineInputBorder(
//////                                                      borderRadius: BorderRadius.all(
//////                                                          Radius.circular(15)),
//////                                                      borderSide:
//////                                                          BorderSide(color: Colors.transparent)),
//////                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.all(Radius.circular(15)))),
//////                                            )
////                                            ],
////                                          )
////                                              : Container(),
////                                        ],
////                                      ),
////                                    ),
//
//                                    _selectedPackage.id == 1
//                                        ? Column(
//                                            mainAxisAlignment:
//                                                MainAxisAlignment.start,
//                                            crossAxisAlignment:
//                                                CrossAxisAlignment.start,
//                                            children: [
//                                              const Text(
//                                                'Name:',
//                                                style: TextStyle(
//                                                    fontSize: 16,
//                                                    fontWeight:
//                                                        FontWeight.bold),
//                                              ),
//                                              Padding(
//                                                padding:
//                                                    const EdgeInsetsDirectional
//                                                        .only(top: 8),
//                                                child: Container(
//                                                  decoration: BoxDecoration(
//                                                    borderRadius:
//                                                        BorderRadius.circular(
//                                                            12),
//                                                    color: Colors.grey.shade100,
//                                                  ),
//                                                  child: TextFormField(
//                                                    controller: _name,
//                                                    maxLines: 1,
//                                                    decoration:
//                                                        const InputDecoration(
//                                                      contentPadding:
//                                                          EdgeInsetsDirectional
//                                                              .only(start: 10),
//                                                      hintText: 'write name',
//                                                    ),
//                                                  ),
//                                                ),
//                                              ),
//                                              const Text(
//                                                'Location:',
//                                                style: TextStyle(
//                                                    fontSize: 16,
//                                                    fontWeight:
//                                                        FontWeight.bold),
//                                              ),
//                                              Padding(
//                                                padding:
//                                                    const EdgeInsetsDirectional
//                                                        .only(top: 8),
//                                                child: Container(
//                                                  decoration: BoxDecoration(
//                                                    borderRadius:
//                                                        BorderRadius.circular(
//                                                            12),
//                                                    color: Colors.grey.shade100,
//                                                  ),
//                                                  child: TextFormField(
//                                                    controller: _Location,
//                                                    maxLines: 1,
//                                                    decoration:
//                                                        const InputDecoration(
//                                                      hintText:
//                                                          'write location',
//                                                    ),
//                                                  ),
//                                                ),
//                                              ),
//                                            ],
//                                          )
//                                        : Container(),
//
//                                    SizedBox(
//                                      height: 10,
//                                    ),
//                                    const Text(
//                                      'Write Description:',
//                                      style: TextStyle(
//                                          fontSize: 16,
//                                          fontWeight: FontWeight.bold),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsetsDirectional.only(
//                                          top: 8),
//                                      child: Container(
//                                        decoration: BoxDecoration(
//                                          borderRadius:
//                                              BorderRadius.circular(12),
//                                          color: Colors.grey.shade100,
//                                        ),
//                                        child: TextFormField(
//                                          controller: order.orderDetails,
//                                          maxLines: 4,
//                                          decoration: const InputDecoration(
//                                            contentPadding: EdgeInsets.all(25),
//                                            hintText: 'Tell us what you need',
//                                          ),
//                                          // ignore: missing_return
//                                          // validator: (value) {
//                                          //   if (value.length < 5) {
//                                          //     return 'your order should be at least 5 characters';
//                                          //   } else if (value.isNotEmpty) {
//                                          //     return null;
//                                          //   }
//                                          // },
//                                        ),
//                                      ),
//                                    ),
//
//                                    SizedBox(
//                                      height: 10,
//                                    ),
//
//                                    Center(
//                                      child: TextButton(
//                                          onPressed: () {
//                                            order.selectedOrder.add(OtherOrder(
//                                                name: _name.text.isNotEmpty
//                                                    ? _name.text
//                                                    : _selectedPackage.title,
//                                                location: _Location.text,
//                                                description:
//                                                    order.orderDetails.text,
//                                                destinationId: 1,
//                                                price: _selectedPackage.price,
//                                                isDeliveryOnly:
//                                                    dropdownvalue == 'Delivery'
//                                                        ? true
//                                                        : false));
//                                            order.orderDetails.clear();
//                                            _Location.clear();
//                                            _name.clear();
//                                            totalFees += _selectedPackage.price;
//                                            setState(() {});
//                                          },
//                                          child: Row(
//                                            mainAxisAlignment:
//                                                MainAxisAlignment.center,
//                                            children: [
//                                              Icon(Icons.check),
//                                              Text('Add Destination'),
//                                            ],
//                                          )),
//                                    )
//                                  ],
//                                ),
//                              ),
//                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ])
              : Center(
                  child: TextButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                    },
                    child: const Text('Sign In',
                        style: TextStyle(
                          color: yellowColor,
                          fontFamily: 'BerlinSansFB',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.035,
                            horizontal: 30),
                        side: const BorderSide(color: Colors.black, width: 1),
                        backgroundColor: const Color(0xFF333333),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                ),
        ),
      ),
    );
  }

  showAlertWithOption() {
    final order = Provider.of<OrderProvider>(context);
    return StatefulBuilder(
        builder: (context, setStatdfe) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              insetPadding: EdgeInsets.all(8.0),
              content: Container(
                width: MediaQuery.of(context).size.width - 50,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Order type:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade100,
                              shape: BoxShape.rectangle),
                          child: DropdownButton(
                            value: dropdownvalue,
                            borderRadius: BorderRadius.circular(12),
                            dropdownColor: Colors.grey.shade100,
                            underline: Container(),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            isExpanded: true,
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(items),
                                ),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              setStatdfe(() {});
                              setState(() {
                                dropdownvalue = newValue;
                              });
                            },
                          ),
                        ),
                      ),

                      // destination

                      const Text(
                        'Destination:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade100,
                              shape: BoxShape.rectangle),
                          child: DropdownButton<ItemTypes>(
                            items: itemsg,
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(12),
                            dropdownColor: Colors.grey.shade100,
                            underline: Container(),
                            onChanged: (newVal) {
                              _selectedPackage = newVal;
                              if(_selectedPackage.id != 1) {
                                _selectedPlace = _selectedPackage.places.first;
                                itePlace = _selectedPackage.places.map((item) {
                                  return DropdownMenuItem<DestinationPlace>(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(item.title),
                                        ],
                                      ),
                                    ),
                                    value: item,
                                  );
                                }).toList();
                              }
                              setStatdfe(() {});

                              setState(() {
                              } );
                            },
                            value: _selectedPackage,
                          ),
                        ),
                      ),
                      _selectedPackage.id == 1
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Name:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsetsDirectional.only(top: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey.shade100,
                                    ),
                                    child: TextFormField(
                                      controller: _name,
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsetsDirectional.only(
                                                start: 10),
                                        hintText: 'write name',
                                      ),
                                    ),
                                  ),
                                ),
                                const Text(
                                  'Location:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsetsDirectional.only(top: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey.shade100,
                                    ),
                                    child: TextFormField(
                                      controller: _Location,
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        hintText: 'write location',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),

                      // places
                      _selectedPackage.id != 1 ?   Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const Text(
                          'Place:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade100,
                                shape: BoxShape.rectangle),
                            child: DropdownButton<DestinationPlace>(
                              items: itePlace ?? [],
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(12),
                              dropdownColor: Colors.grey.shade100,
                              underline: Container(),
                              onChanged: (newVal) {
                                setStatdfe(() {});
                                setState(() => _selectedPlace = newVal);
                              },
                              value: _selectedPlace,
                            ),
                          ),
                        ),

                      ],) : Container(),


                      (_selectedPlace != null && _selectedPlace.id == 12 )
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Name:',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding:
                            const EdgeInsetsDirectional.only(top: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade100,
                              ),
                              child: TextFormField(
                                controller: _name,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  contentPadding:
                                  EdgeInsetsDirectional.only(
                                      start: 10),
                                  hintText: 'write name',
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'Location:',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding:
                            const EdgeInsetsDirectional.only(top: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade100,
                              ),
                              child: TextFormField(
                                controller: _Location,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  hintText: 'write location',
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),

                      const Text(
                        'Write Description:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade100,
                          ),
                          child: TextFormField(
                            controller: order.orderDetails,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(25),
                              hintText: 'Tell us what you need',
                            ),
                            // ignore: missing_return
                            // validator: (value) {
                            //   if (value.length < 5) {
                            //     return 'your order should be at least 5 characters';
                            //   } else if (value.isNotEmpty) {
                            //     return null;
                            //   }
                            // },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      order.selectedOrder.add(OtherOrder(
                          name: _name.text.isNotEmpty
                              ? _name.text
                              : _selectedPackage.title,
                          location: _Location.text,
                          description: order.orderDetails.text,
                          destinationId: _selectedPackage.id,
                          price: _selectedPackage.price,
                          destinationPlaceId: _selectedPackage.id != 1 ?_selectedPlace.id : 12,
                          palceName:_selectedPackage.id != 1 ?  _selectedPlace.title : '',
                          isDeliveryOnly:
                              dropdownvalue == 'Delivery' ? true : false));
                      order.orderDetails.clear();
                      _Location.clear();
                      _name.clear();
                      totalFees += _selectedPackage.price;
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check),
                        Text('Add Destination'),
                      ],
                    ))
              ],
            ));
  }
}
