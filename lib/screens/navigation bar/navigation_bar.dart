import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';
import 'package:yallajeye/providers/homePage.dart';
import 'package:yallajeye/screens/home/home_screen.dart';
import 'package:yallajeye/screens/notifications.dart';
import 'package:yallajeye/screens/order/custom_order.dart';
import 'package:yallajeye/screens/order/tabbar_order.dart';
import 'package:yallajeye/screens/settings/settings.dart';
import 'package:yallajeye/widgets/custom_alert_dialog.dart';

import '../../Services/local_notifications.dart';
import '../order/order_list.dart';
import '../restaurants/restaurants-screen.dart';
import 'dart:io' as p;

class Navigation extends StatefulWidget {
  const Navigation({Key key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  HomePageProvider homePage;
  String yourLocation = '';

  final screens = [
    HomeScreen(),
    RestaurantsScreen(),
    Notifications(),
    Settings()
  ];
  var appBarLeading = [];
  int screenNum = 0;
//
  var mediaQuery;
  double width ;
//  getData() async {
//    final homePage = Provider.of<HomePageProvider>(context, listen: false);
//    await homePage.getHomePage();
//  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    appBarLeading = [
      Padding(
        padding: const EdgeInsetsDirectional.only(top: 20) ,
        child: Text(yourLocation),
      ),
      Text(
        "Restaurants",
        style: appBarText,
      ),
      Text(
        "Notifications",
        style: appBarText,
      ),
      Text(
        "Settings",
        style: appBarText,
      )
    ];
   homePage = Provider.of<HomePageProvider>(context, listen: false);
    init();
    LocalNotificationService.initialize(context);
    homePage.currentLocStream.listen((event) {
      yourLocation = event;
      if(mounted)
    {
      setState(() {

      });
    }
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  Future<void> init() async {
    if (p.Platform.isIOS) {
      await _fcm.requestPermission();
    }
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // var isActive = _prefHelper.getIsActive();
    await _handleNotificationsListeners();
  }

  void _handleNotificationsListeners() async {
//to navigate when it is in background or terminated
//    FirebaseMessaging.onMessage((RemoteMessage message) {
//      if (message != null) {
//        print("First message${message}");
//        int id = int.parse(message.data["orderId"].toString());
//        // demo data
//        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>TabBarOrder(numTab: 0, id:id)));
//      }
//    }
//    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("second message${message.data}");

      // demo data
      int id = int.parse(message.data["orderId"].toString());
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => TabBarOrder(numTab: 0, id: id)));
      print('A new onMessageOpenedApp event was published!');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService.display(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context).size;
    width = mediaQuery.width;
    Future<bool> onBackPressed() {
      return showDialog(
          context: context,
          builder: (context) => CustomAlertDialog(
                title: "Want to exit Yalla Jeyi app ?",
                content: "",
                cancelBtnFn: () => Navigator.pop(context, false),
                confrimBtnFn: () => Navigator.pop(context, true),
              ));
    }

    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: appBarLeading[screenNum],
          elevation: 0,
          actions: [

            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => OrderList()));
              },
              icon: const Icon(FontAwesomeIcons.shoppingCart),
              color: yellowColor,
            ),

          ],
        ),
        body: screens[screenNum],
        bottomNavigationBar: BottomAppBar(
          color: redColor,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    screenNum = 0;
                  });
                },
                icon: SvgPicture.asset('assets/images/Home.svg',
                    color: screenNum == 0 ? Colors.white : yellowColor),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    screenNum = 1;
                  });
                },
                icon: SvgPicture.asset('assets/images/Restaurants.svg',
                    color: screenNum == 1 ? Colors.white : yellowColor),
              ),
              SizedBox(
                width: width * 0.03,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    screenNum = 2;
                  });
                },
                icon: Icon(
                  Icons.notifications,
                  color: screenNum == 2 ? Colors.white : yellowColor,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    screenNum = 3;
                  });
                },
                icon: SvgPicture.asset('assets/images/Settinga.svg',
                    color: screenNum == 3 ? Colors.white : yellowColor),
              ),
            ],
          ),
        ),
       floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => CustomOrder()));
            },
            child: Icon(Icons.add_shopping_cart_sharp,
                color: screenNum == 4 ? Colors.white : yellowColor)
            // SvgPicture.asset('assets/images/Custom Order.svg',)

            ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
