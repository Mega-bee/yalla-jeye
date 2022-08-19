import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';
import 'package:yallajeye/providers/order.dart';
import 'package:yallajeye/screens/order/order_list.dart';

import '../../models/Adresses.dart';
import '../../providers/address.dart';
import '../navigation bar/navigation_bar.dart';

class PromoCode extends StatefulWidget {
  const PromoCode({Key key}) : super(key: key);

  @override
  _PromoCodeState createState() => _PromoCodeState();
}

class _PromoCodeState extends State<PromoCode> {
  TextEditingController redeemController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _isloading = false;
  String message = "";
  bool loading = false;
  bool done = false;
  bool PlacedOrder = false;

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderProvider>(context, listen: true);
    final address = Provider.of<AddressProvider>(context, listen: true);

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Navigation()),
            (Route<dynamic> route) => false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Order Created",
            style: appBarText,
          ),
          foregroundColor: yellowColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Have a promo code from Yalla Jeye",
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'BerlinSansFB',
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Redeem it here and get a discount on your deliveries",
                  style: TextStyle(fontFamily: 'BerlinSansFB', fontSize: 17),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formkey,
                  child: TextFormField(
                    controller: order.redeemCodeController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "XXxxxxxxXXxxxxxXxx",
                        hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'BerlinSansFB',
                            color: Color(0xFF878787)),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.transparent))),
                  ),
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.3,
                // ),
                _isloading
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(),
                      ))
                    : !done
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextButton(
                                onPressed: () async {
                                  if (order.redeemCodeController.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Code cannot be empty",
                                        fontSize: 15,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 2,
                                        textColor: Colors.white,
                                        backgroundColor: redColor,
                                        toastLength: Toast.LENGTH_SHORT);
                                  } else {
                                    setState(() {
                                      _isloading = true;
                                    });
                                    loading = await order.redemCode();
                                    if (!loading) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  Text(order.messagePlaceOrder),
                                            );
                                          });
                                    } else {
                                      setState(() {
                                        done = true;
                                      });

                                    }
                                    setState(() {
                                      _isloading = false;
                                    });
                                    if(done){
                                      order.selectedOrder
                                          .clear();
                                      Navigator.of(context)
                                          .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                  Navigation()),
                                              (Route<dynamic>
                                          route) =>
                                          false)
                                          .then((value) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                    OrderList()));
                                      });
                                    }
                                  }
                                },
                                child: const Text('Redeem',
                                    style: TextStyle(
                                      color: yellowColor,
                                      fontFamily: 'BerlinSansFB',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    )),
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 40),
                                    side: const BorderSide(
                                        color: Colors.black, width: 1),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    backgroundColor: const Color(0xFF333333)),
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(Icons.done),
                          ),

              ],
            ),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
