import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';
import 'package:yallajeye/providers/address.dart';
import 'package:yallajeye/providers/homePage.dart';
import 'package:yallajeye/providers/order.dart';
import 'package:yallajeye/providers/user.dart';
import 'package:yallajeye/screens/auth/signin_screen.dart';

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
    final heightSize = MediaQuery.of(context).size.height;
    final homePage = Provider.of<HomePageProvider>(context, listen: true);
    final address = Provider.of<AddressProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: onBackPressed,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          // appBar: AppBar(
          //   title: const Text(
          //     "Custom Order",
          //     style: appBarText,
          //   ),
          //   actions: [
          //     IconButton(
          //       onPressed: () {
          //
          //         Navigator.of(context)
          //             .push(MaterialPageRoute(builder: (_) => OrderList()));
          //         order.clearFields();
          //       },
          //       icon: Icon(FontAwesomeIcons.shoppingCart),
          //       color: yellowColor,
          //     )
          //   ],
          // ),
          appBar: AppBar(
              leading: IconButton(
            onPressed: () {
              user.status==Status.isVerified?
              showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                      title: "Do you want to cancel your order?",
                      content: "",
                      cancelBtnFn: () => Navigator.pop(context, false),
                      confrimBtnFn: () {
                        Navigator.pop(context);
                        Navigator.of(context).pop();
                      })):
              Navigator.pop(context);
              ;
            },
            icon: Icon(
              Icons.arrow_back,
              size: 41,
              color: Color.fromRGBO(254, 212, 48, 1),
            ),
          )),
          body: user.status == Status.isVerified
              ? CustomScrollView(slivers: [
                  SliverAppBar(
                    shadowColor: Colors.transparent,
                    pinned: true,
                    floating: false,
                    backgroundColor: Colors.transparent,
                    leading: Center(
                        // child: IconButton(
                        //   onPressed:  (){
                        //     showDialog(
                        //     context: context,
                        //     builder: (context) =>
                        //         CustomAlertDialog(title: "Do you want to cancel your order?", content: "", cancelBtnFn: () => Navigator.pop(context, false), confrimBtnFn: (){
                        //           Navigator.pop(context);
                        //           Navigator.of(context).pop();
                        //         }));
                        //        },
                        //   icon: Icon(
                        //     Icons.clear,
                        //     color: yellowColor,
                        //     size: 30,
                        //   ),
                        // ),
                        ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      child: Form(
                        key: _formKey,
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            Container(
                              height: (MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).padding.top) *
                                  0.15,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Please Enter\nYour Order:',
                                style: TextStyle(
                                  fontSize: heightSize * 0.055,
                                  fontFamily: 'BerlinSansFB',
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              height: (MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).padding.top) *
                                  0.04,
                            ),
                            AnimatedContainer(
                              padding: const EdgeInsets.all(8),
                              margin: EdgeInsets.only(bottom: 20),
                              // height: heightSize * 0.2,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              duration: const Duration(milliseconds: 500),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start
                                children: [
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: const [
                                  //     Text(
                                  //       "Please Enter your need",
                                  //       style: TextStyle(
                                  //           decoration:
                                  //               TextDecoration.underline,
                                  //           fontFamily: 'BerlinSansFB',
                                  //           fontSize: 15,
                                  //           fontWeight: FontWeight.bold),
                                  //     ),
                                  //     Icon(FontAwesomeIcons.caretDown),
                                  //   ],
                                  // ),
                                  SizedBox(
                                    height: heightSize * 0.05,
                                    width: double.maxFinite,
                                    child: order.selectedItem.isEmpty
                                        ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                order.show = !order.show;
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                const Text(
                                                  "Please choose one or more",
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontFamily:
                                                          'BerlinSansFB',
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                    FontAwesomeIcons.caretDown),
                                              ],
                                            ),
                                          )
                                        : ListView.separated(
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                order.selectedItem.length,
                                            itemBuilder: (context, index) {
                                              return Chip(
                                                label: Text(order
                                                    .selectedItem[index].title),
                                                backgroundColor: yellowColor,
                                              );
                                            }),
                                  ),
                                  order.show
                                      ? Column(
                                          children: [
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return CheckboxListTile(
                                                  side: BorderSide(
                                                      color: Colors.black),
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading,
                                                  title: Text(
                                                      "${homePage.itemTypes[index].title}"),
                                                  value: order.selectedItem
                                                      .contains(homePage
                                                          .itemTypes[index]),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      if (value) {
                                                        order.addItem(homePage
                                                            .itemTypes[index]);

                                                        order.selectedTypeId
                                                            .add(homePage
                                                                .itemTypes[
                                                                    index]
                                                                .id);
                                                      } else {
                                                        order.removeItem(
                                                            homePage.itemTypes[
                                                                index]);
                                                        order.selectedTypeId
                                                            .remove(homePage
                                                                .itemTypes[
                                                                    index]
                                                                .id);
                                                      }
                                                    });
                                                  },
                                                );
                                              },
                                              itemCount:
                                                  homePage.itemTypes.length,
                                            ),
                                            TextFormField(
                                              controller: order.otherType,
                                              decoration: const InputDecoration(
                                                  focusedErrorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: redColor),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(15))),
                                                  errorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: redColor),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(15))),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding:
                                                      EdgeInsets.all(25),
                                                  hintText: 'Other',
                                                  hintStyle: TextStyle(
                                                      fontFamily:
                                                          'BerlinSansFB',
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  border: OutlineInputBorder(),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(15)),
                                                      borderSide:
                                                          BorderSide(color: Colors.transparent)),
                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.all(Radius.circular(15)))),
                                            )
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            TextFormField(
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: order.orderDetails,
                              maxLines: 10,
                              decoration: const InputDecoration(
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: redColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: redColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(25),
                                  hintText: 'Tell us what you need',
                                  hintStyle: TextStyle(
                                      fontFamily: 'BerlinSansFB',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)))),
                              // ignore: missing_return
                              // validator: (value) {
                              //   if (value.length < 5) {
                              //     return 'your order should be at least 5 characters';
                              //   } else if (value.isNotEmpty) {
                              //     return null;
                              //   }
                              // },
                            ),
                            SizedBox(
                              height: (MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).padding.top) *
                                  0.03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    order.clearFields();

                                    // setState(() {
                                    //   order.selectedItem = [];
                                    //   order.selectedTypeId=[];
                                    //   order.orderDetails.clear();
                                    // });
                                  },
                                  child: const Text('Clear All',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'BerlinSansFB',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      )),
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 30),
                                      side: const BorderSide(
                                          color: Colors.black, width: 1),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if ((order.selectedTypeId.isEmpty &&
                                            order.otherType.text.isEmpty) ||
                                        order.orderDetails.text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Please fill empty fields",
                                          fontSize: 15,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 2,
                                          textColor: Colors.white,
                                          backgroundColor: redColor,
                                          toastLength: Toast.LENGTH_SHORT);
                                      return;
                                    } else {
                                      if (address.addresses.length == 0) {
                                        address.isCreateAddress = true;
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) => LocationP()));
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    CreateAddress()));
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) => LocationP()));
                                      }

                                      // order.clearFields();
                                    }
                                  },
                                  child: const Text('Order',
                                      style: TextStyle(
                                        color: yellowColor,
                                        fontFamily: 'BerlinSansFB',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      )),
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 40),
                                      side: const BorderSide(
                                          color: Colors.black, width: 1),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      backgroundColor: const Color(0xFF333333)),
                                ),
                              ],
                            )
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
}
