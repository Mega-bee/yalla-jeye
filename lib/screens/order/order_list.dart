import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';
import 'package:yallajeye/providers/order.dart';
import 'package:yallajeye/providers/user.dart';
import 'package:yallajeye/screens/auth/signin_screen.dart';
import 'package:yallajeye/screens/order/tabbar_order.dart';
import 'package:yallajeye/widgets/skeleton_card.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final items = ['All', 'Today', 'Last 7 Days', 'Last Month'];
  String dropdownvalue = 'All';

  // String getDate() {
  //   String date = 'All';
  //   if (dropdownvalue == "All") {
  //     date = 'All';
  //     return date;
  //   } else if (dropdownvalue == "Today") {
  //     date = 'Today';
  //     return date;
  //   } else if (dropdownvalue == "Last 7 Days") {
  //     date = 'Last7Days';
  //     return date;
  //   } else if (dropdownvalue == 'Last Month') {
  //     date = 'LastMonth';
  //     return date;
  //   }
  //   return date;
  // }
  int id = 0;

  getData() async {
    final order = Provider.of<OrderProvider>(context, listen: false);
    await order.getOrders(id);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true);
    final order = Provider.of<OrderProvider>(context, listen: true);
    final mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: user.status == Status.isVerified
          ? CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverAppBar(
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 50,
                      ),
                      child: Row(
                        children: [
                          const Text("History: ",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'BerlinSansFB',
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              )),
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              dropdownColor: Color.fromRGBO(189, 32, 46, 1),
                              value: dropdownvalue,
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (val) async {
                                setState(() {
                                  return this.dropdownvalue = val as String;
                                });
                                id = items
                                    .indexWhere((element) => element == val);
                                await order.getOrders(id);
                                // filterOrder(dropdownvalue);
                              },
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Berlin Sans',
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                              icon: const Icon(
                                FontAwesomeIcons.chevronDown,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  foregroundColor: yellowColor,
                  title: const Text(
                    "View with history",
                    style: appBarText,
                  ),
                ),
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    setState(() {
                      order.loading = true;
                    });
                    await order.getOrders(id);
                  },
                ),
                order.loading
                    ? SliverToBoxAdapter(
                        child: Skeleton(
                          shimmerGradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [redColor, Colors.red],
                          ),
                          isLoading: order.loading,
                          skeleton: SkeletonItem(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  CustomSkeletonCard(0.15),
                                  CustomSkeletonCard(0.15),
                                  CustomSkeletonCard(0.15),
                                  CustomSkeletonCard(0.15),
                                  CustomSkeletonCard(0.15),
                                  CustomSkeletonCard(0.15),
                                  CustomSkeletonCard(0.15),
                                ],
                              ),
                            ),
                          ),
                          child: Container(),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                        return Container(
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 4),
                          child: GestureDetector(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          1.0,
                                      child: FittedBox(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Order ${order.getOrder[index].orderNumber}',
                                              style: TextStyle(
                                                  fontSize:
                                                      mediaQuery.height * 0.006,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'Berlin Sans'),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                // text: 'Status:',
                                                // style: TextStyle(
                                                // decoration: TextDecoration
                                                //     .underline,
                                                // fontSize:
                                                //     mediaQuery.height *
                                                //         0.01,
                                                // fontWeight:
                                                //     FontWeight.normal,
                                                // fontFamily: 'Berlin Sans'),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: order.getOrder[index]
                                                        .orderStatus,
                                                    style: TextStyle(
                                                        color: order
                                                                    .getOrder[
                                                                        index]
                                                                    .orderStatusId ==
                                                                1
                                                            ? yellowColor
                                                            : order
                                                                        .getOrder[
                                                                            index]
                                                                        .orderStatusId ==
                                                                    2
                                                                ? Colors.green
                                                                : order.getOrder[index].orderStatusId ==
                                                                        3
                                                                    ? Colors
                                                                        .green
                                                                    : order.getOrder[index].orderStatusId ==
                                                                            4
                                                                        ? redColor
                                                                        : Colors
                                                                            .black,
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontSize:
                                                            mediaQuery.height *
                                                                0.005,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily:
                                                            'Berlin Sans'),
                                                  ),
                                                  // can add more TextSpans here...
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: mediaQuery.height * 0.02,
                                    ),
                                    Text(
                                      DateFormat.yMMMMEEEEd().add_jm().format(
                                            DateTime.parse(
                                              order.getOrder[index].createdAt
                                                  .toString(),
                                            ),
                                          ),
                                      
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(
                                      height: mediaQuery.height * 0.02,
                                    ),
                                   Column(children:  order.getOrder[index].
                                   destenation.map((e) =>
                                       Padding(
                                         padding: const EdgeInsets.all(8.0),
                                         child: Row(
                                           children: [
                                             Text(e.name +': ',
                                               style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold ),),
                                             Text(e.location,
                                              ),
                                           ],
                                         ),
                                       )).toList(),),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          1.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text.rich(
                                              TextSpan(
                                                text: 'Delivery fees:',
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize:
                                                        mediaQuery.height *
                                                            0.015,
                                                    fontWeight: FontWeight.w900,
                                                    fontFamily: 'Berlin Sans'),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    // text: _liststatus[index].price,
                                                    // text:'${orderList[index].orders[index].deliveryPrice}',
                                                    text: '${order.getOrder[index].deliveryPrice} L.L',
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontSize:
                                                            mediaQuery.height *
                                                                0.015,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontFamily:
                                                            'Berlin Sans'),
                                                  ),
                                                  // can add more TextSpans here...
                                                ],
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   width: MediaQuery.of(context).size.width * 0.1,
                                          // ),
                                          IconButton(
                                            onPressed: null,
                                            icon: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: mediaQuery.height * 0.025,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => TabBarOrder(
                                     numTab: 0, id:order.getOrder[index].id)));
                              // Navigator.of(context)
                              //     .push(MaterialPageRoute(
                              //   builder: (_) => TABBar(
                              //       orderId: value.map[index]
                              //       ['id'],
                              //       details: value.map[index]
                              //       ['orderDetails'],
                              //       status: value.map[index]
                              //       ['orderStatus'],
                              //       orderNumber: value.map[index]
                              //       ['orderNumber'],
                              //       description: value.map[index][
                              //       'orderDescription'] ??
                              //           'not set',
                              //       price: value.map[index]
                              //       ['deliveryPrice'] ??
                              //           0,
                              //       checkListItems: value.map[index]
                              //       ['checkListItems'],
                              //       address: value.map[index]["address"] ??
                              //           "address"),
                              // ))
                              //     .then((_) {
                              //   value.initialValues();
                              //   value.getOrders(dropdownvalue);
                              // });
                            },
                          ),
                        );
                      }, childCount: order.getOrder.length)),
              ],
            )
          : Center(
              child: TextButton(
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
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
                        vertical: MediaQuery.of(context).size.height * 0.035,
                        horizontal: 30),
                    side: const BorderSide(color: Colors.black, width: 1),
                    backgroundColor: const Color(0xFF333333),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
    ));
  }
}
