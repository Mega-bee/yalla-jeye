import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yallajeye/providers/user.dart';
import 'package:yallajeye/widgets/custom_alert_dialog.dart';

import '../constants/colors_textStyle.dart';
import '../widgets/build_show-Dialog_logout.dart';
import '../widgets/build_show_dialog.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // User _pefUser;
  bool _prefsLoaded;
  final appBar = AppBar(
    title: Text('Settings'),
    foregroundColor: yellowColor,
  );

  void initState() {
    _prefsLoaded = false;
    // getUser();
    getData();
    super.initState();

  }
  bool isActive=false;
  String email="";
getData()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    isActive= prefs.getBool("driverIsActive");
   email= prefs.get("email");
   setState(() {
   });
}
  // Future<void> getUser() async {
  //   _pefUser = await UserPreferences().getUser();
  //   print('email');
  //   print(_pefUser.email);
  //   setState(() {
  //     _prefsLoaded = true;
  //   });
  // }

  bool valueOn = false;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    var qPortrait = MediaQuery.of(context).orientation;
    final deliveryProv=Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: appBar,
      body: CustomScrollView(slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return LayoutBuilder(
              builder: (ctx, constraints) => Container(
                    // height: screenHeight * 0.9,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Color(0xFFE2E2E2),
                              radius: qPortrait == Orientation.portrait
                                  ? screenHeight * 0.055
                                  : screenHeight * 0.08,
                              // minRadius: 20,
                              // maxRadius: screenHeight * 0.04,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/user_icon.png",
                                    height: qPortrait == Orientation.portrait
                                        ? screenHeight * 0.045
                                        : screenHeight * 0.06,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(email,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'BerlinSansFB'),
                                      ),

                              ],
                            )
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text(
                                'Availability:',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'BerlinSansFB',
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 20),
                              Transform.scale(
                                scale: 1.2,
                                child: Switch.adaptive(
                                  activeColor: Colors.white,
                                  activeTrackColor: Colors.greenAccent,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: Colors.redAccent,
                                  value: isActive,
                                  onChanged:(value)
                                  async{
                                    showDialog(
                                    barrierDismissible: false,context: context, builder: (context){
                                      return AlertDialog(
                                        title: Center(child: CircularProgressIndicator()),
                                      );
                                    });
                                  bool success=  await deliveryProv.toggleActivity();
                                  Navigator.of(context).pop();
                                    if(success){
                                      SharedPreferences prefs=await SharedPreferences.getInstance();
                                      setState(() {
                                        isActive = value;
                                      });
                                      prefs.setBool("driverIsActive",value);
                                    }else{
                                    showDialog(context: context, builder: (context){
                                      return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                          15)),
                                      title:const Text(
                                      "Please try again later",
                                      style: TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                      FontWeight.bold,
                                      fontFamily:
                                      "BerlinSansFB"),
                                      textAlign: TextAlign.center,
                                      )
                                      ) ;})  ;
                                    }
                                  }
                                  ,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.5,
                                ),
                                Column(
                                  children: [
                                    TextButton(
                                      onPressed:() async {
                                        buildShowDialogLogout(context);
                                      },
                                      child: Text('Logout',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'BerlinSansFB',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          )),
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: screenHeight * 0.035,
                                              horizontal: 30),
                                          side: BorderSide(
                                              color: Colors.black, width: 1),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)))),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
        }, childCount: 1)),
      ]),
    );
  }

  dooToggleActivity(value) async{
    // try{
    //   var result = await ApiCall().toggleActivity();
    //   if(result=="Failed to toggle activity") {
    //     buildShowDialog(context, result);
    //     return;
    //   }
    //   buildShowDialog(context, result);
    //   setState(() {
    //     this.valueOn = value;
    //   });
    //
    // }on HttpException catch(e){
    //   buildShowDialog(context, e);
    // }
    // catch(e){
    //   print(e);
    //   buildShowDialog(context, "we couldn't change your status");
    // }



}
}
