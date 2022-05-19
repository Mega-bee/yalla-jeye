import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';
import 'package:yallajeye/driver/navigation.dart';
import 'package:yallajeye/driver/tracking-cardNN.dart';
import 'package:yallajeye/providers/NotificationProvider.dart';
import 'package:yallajeye/providers/address.dart';
import 'package:yallajeye/providers/homePage.dart';
import 'package:yallajeye/providers/order.dart';
import 'package:yallajeye/providers/user.dart';
import 'package:yallajeye/screens/auth/phone_verification.dart';
import 'package:yallajeye/screens/auth/profile_screen.dart';
import 'package:yallajeye/screens/navigation%20bar/navigation_bar.dart';
import 'package:yallajeye/screens/order/chat/providers/chat_provider.dart';
import 'package:yallajeye/screens/order/tabbar_order.dart';
import 'package:yallajeye/screens/splash_screen.dart';
import 'dart:io' as plat ;
import 'Helpers/Constant.dart';
import 'Services/local_notifications.dart';
import 'screens/auth/signin_screen.dart';
//recieve message when app in background solution onMessage
 Future<void> backgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
 // return LocalNotificationService.display(message);
}

 void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
//  final FirebaseMessaging firebaseMessaging =FirebaseMessaging.instance;
//  Future<void> init() async{
//  if(plat.Platform.isIOS){
//    await FirebaseMessaging.instance.requestPermission();}
//  }

// await FirebaseMessaging.instance.getToken().then((value) => print("firebase token is $value"));

  ///TOPIC FCM
  await FirebaseMessaging.instance.subscribeToTopic('all');



  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );
  runApp(const MyApp());
}
class appstate extends StatefulWidget {
  const appstate({Key key}) : super(key: key);

  @override
  _appstateState createState() => _appstateState();
}

class _appstateState extends State<appstate> {




  @override
  Widget build(BuildContext context) {
    //build context ?
    final authProvider = Provider.of<UserProvider>(context, listen: true);

    return FutureBuilder(
        future: checkservers,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Server down ,, sryyyyy")],
              ),
            );
          }
          // bool a=snapshot.data as bool;

          if (!true) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("erver downnnnnnnnnnnnnnnn")],
              ),
            );
          } else {
            switch (authProvider.status) {
              case Status.isAnonymous:
                return Navigation();
              case Status.isVerified:
                return Navigation();
              case Status.isDriver:
                return NavigationScreen();
              default :
                return SignInScreen();
            }
            // return NavigationScreen();


          }
        });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: OrderProvider()),
        Provider<ChatProvider>(create: (_)=>ChatProvider(),),
        ChangeNotifierProvider.value(value: UserProvider.statusfunction()),
        ChangeNotifierProvider.value(value: AddressProvider()),
        ChangeNotifierProvider.value(value: HomePageProvider()),
        ChangeNotifierProvider.value(value: NotificationProvider()),
        // ChangeNotifierProvider.value(value: PersonalInfoProvider()),
                      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yalla Jeye',
        theme: ThemeData(
          primarySwatch: redColor,
            unselectedWidgetColor:yellowColor
        ),
        home: SplashScreen(),
      ),
    );
  }
}

// to dismiss keyboard
class DismissKeyboard extends StatelessWidget {
  final Widget child;

  DismissKeyboard({this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: child,
    );
  }
}
