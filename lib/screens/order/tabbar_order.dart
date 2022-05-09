import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';
import 'package:yallajeye/providers/order.dart';
import 'package:yallajeye/screens/order/Order_chat.dart';
import 'package:yallajeye/screens/order/chat/chat_page.dart';
import 'package:yallajeye/screens/order/chat/test_audio.dart';
import 'package:yallajeye/screens/order/order_info.dart';
import 'package:yallajeye/screens/order/order_tracking.dart';

class TabBarOrder extends StatefulWidget {
  final int numTab;
  final int id;

   const TabBarOrder({this.numTab,this.id});


  @override
  _TabBarOrderState createState() => _TabBarOrderState();
}

class _TabBarOrderState extends State<TabBarOrder> {
  getData()async{
    final order=Provider.of<OrderProvider>(context,listen: false);
    await order.getOrderByid(widget.id);

  }
  getPermission()async{
final status = await Permission.microphone.request();
if(status.isGranted){
  print("granted");
}else{
  print("denied");
}
  }
  @override
  void initState() {
    getData();
    // getPermission();
    super.initState();
  }
  bool trackingDriver=false;
  @override
  Widget build(BuildContext context) {
    final order=Provider.of<OrderProvider>(context,listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Image.asset(
        'assets/images/logo.png',
        height: 40,
      ),
        foregroundColor: yellowColor,
      ),
      body: SafeArea(child:
      order.loadingId ?
      Center(child: CircularProgressIndicator(),):

      order.orderByIdModel.orderStatusId==3?
      DefaultTabController(length: 1,
        initialIndex: widget.numTab, child: Column(
          children: [
            Container(
              height: (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom) *
                  0.08,
              child:const TabBar(
                indicatorColor: Colors.yellow,
                indicatorWeight:4,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(
                    text: 'Info',
                  ),
                  // Tab(
                  //   text: 'Tracking',
                  // ),
                  // Tab(
                  //   text: 'Chat',
                  // ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: [
                OrderInfo(),
                // OrderTracking(),
                // OrderChat(),
              ]),
            )
          ],
        ),

      ) : DefaultTabController(length: 3,
        initialIndex: widget.numTab, child: Column(
          children: [
            Container(
              height: (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom) *
                  0.08,
              child:const TabBar(
                indicatorColor: Colors.yellow,
                indicatorWeight:4,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(
                    text: 'Info',
                  ),
                  Tab(
                    text: 'Tracking',
                  ),
                  Tab(
                    text: 'Chat',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: [
                OrderInfo(),
                TrackingOrder(widget.id),
                ChatPage(
                  peerId: "admin",
                  peerAvatar: "",
                  peerNickname: "",
                ),
              ]),
            )
          ],
        ),

      ),),
    );
  }
}
