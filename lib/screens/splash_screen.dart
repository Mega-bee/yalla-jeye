import 'dart:async';

import 'package:flutter/material.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  // static const String screenRoute = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  // User pefUser;
  // Future getUser() async {
  //   pefUser = await UserPreferences().getUser();
  // }
   @override
  void initState() {
  //   getUser();
    super.initState();
    navToHome();

  }

  navToHome(){
    Timer(
        Duration(milliseconds: 3300),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => appstate())));
  }



  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    var screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: screenHeight * 1,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromRGBO(189, 32, 46, 1),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                top: screenHeight>=500? MediaQuery.of(context).size.height*0.2: MediaQuery.of(context).size.height*0.06,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Container(
                        height: screenHeight*0.28,
                        child: Image.asset(
                          'assets/images/yallajeyeCharacter.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height:screenHeight*0.025 ,),
                    Container(
                      height: screenHeight*0.2,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              // if (islandscape)
              //   Container(
              //     height: screenHeight * 0.370,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.only(
              //           topRight: Radius.circular(15),
              //           topLeft: Radius.circular(15)),
              //     ),
              //     alignment: Alignment.center,
              //     child: Column(
              //       children: [
              //         if (islandscape)
              //           Container(
              //             height: screenHeight * 0.07,
              //             child: FittedBox(
              //               child: Text(
              //                 'Yalla Jeye is a local\ndelivering company.',
              //                 style: TextStyle(
              //                   fontSize: 20,
              //                   fontWeight: FontWeight.w600,
              //                   fontFamily: 'BerlinSansFB',
              //                 ),
              //                 textAlign: TextAlign.center,
              //               ),
              //             ),
              //           ),
              //         // if (!islandscape)
              //         //   Container(
              //         //     height: screenHeight * 0.05,
              //         //     child: FittedBox(
              //         //       child: Text(
              //         //         'Yalla Jeye is a local\ndelivering company.',
              //         //         style: TextStyle(
              //         //           fontSize: 20,
              //         //           fontWeight: FontWeight.w600,
              //         //           fontFamily: 'BerlinSansFB',
              //         //         ),
              //         //         textAlign: TextAlign.center,
              //         //       ),
              //         //     ),
              //         //   ),
              //         // SizedBox(
              //         //   height: screenHeight * 0.02,
              //         // ),
              //         // Container(
              //         //   height: screenHeight * 0.05,
              //         //   child: FittedBox(
              //         //     child: Text(
              //         //       'Want things delivered?\nYou’re in the right place!',
              //         //       style: TextStyle(
              //         //         fontSize: 16,
              //         //         fontWeight: FontWeight.normal,
              //         //         fontFamily: 'BerlinSansFB',
              //         //       ),
              //         //     ),
              //         //   ),
              //         // ),
              //
              //         // Expanded(
              //         //   child: Container(
              //         //     padding: EdgeInsets.only(bottom: 2, top: 2),
              //         //     child: Text(
              //         //       'Powered by mega-bee.com',
              //         //       style: TextStyle(
              //         //           fontSize: 8,
              //         //           fontWeight: FontWeight.normal,
              //         //           fontFamily: 'BerlinSansFB',
              //         //           color: yellowColor),
              //         //     ),
              //         //   ),
              //         // ),//megabee
              //         // Container(
              //         //   width: MediaQuery.of(context).size.width * 0.8,
              //         //   child: ElevatedButton(
              //         //     onPressed: () {
              //         //       // Navigator.push(
              //         //       //     context,
              //         //       //     MaterialPageRoute(
              //         //       //         builder: (context) => SignInScreen()));
              //         //       Navigator.of(context).pushReplacement(
              //         //           MaterialPageRoute(
              //         //               builder: (context) => MainScreen()));
              //         //     },
              //         //     child: Text(
              //         //       'Continue',
              //         //       style: TextStyle(
              //         //         fontSize: 16,
              //         //         fontWeight: FontWeight.w600,
              //         //       ),
              //         //     ),
              //         //     style: ElevatedButton.styleFrom(
              //         //       padding: EdgeInsets.fromLTRB(
              //         //           screenHeight * 0.1,
              //         //           screenHeight * 0.03,
              //         //           screenHeight * 0.1,
              //         //           screenHeight * 0.03),
              //         //       onPrimary: Color.fromRGBO(254, 212, 48, 1),
              //         //       primary: Color.fromRGBO(51, 51, 51, 1),
              //         //       shape: new RoundedRectangleBorder(
              //         //         borderRadius: new BorderRadius.circular(15.0),
              //         //       ),
              //         //     ),
              //         //   ),
              //         // ),
              //       ],
              //     ),
              //     padding: EdgeInsets.only(
              //       top: 8.0,
              //       bottom: 4.0
              //     ),
              //   ),
             // if (!islandscape)
             //    Container(
             //      height: screenHeight>=500?screenHeight * 0.3:screenHeight*0.32,
             //      width: double.infinity,
             //      decoration: BoxDecoration(
             //        color: Colors.white,
             //        borderRadius: BorderRadius.only(
             //            topRight: Radius.circular(15),
             //            topLeft: Radius.circular(15)),
             //      ),
             //      alignment: Alignment.center,
             //      child: Column(
             //        children: [
             //          Container(
             //            height: screenHeight * 0.06,
             //            child: FittedBox(
             //              child: Text(
             //                'Yalla Jeye is a local\ndelivering company.',
             //                style: TextStyle(
             //                  fontSize: 20,
             //                  fontWeight: FontWeight.w600,
             //                  fontFamily: 'BerlinSansFB',
             //                ),
             //                textAlign: TextAlign.center,
             //              ),
             //            ),
             //          ),//yalla
             //          SizedBox(
             //            height: screenHeight * 0.02,
             //          ),
             //
             //            Container(
             //              height:screenHeight<=500? screenHeight * 0.07:screenHeight * 0.05,
             //              child: FittedBox(
             //                child: Text(
             //                  'Want things delivered?\nYou’re in the right place!',
             //                  style: TextStyle(
             //                    fontSize: 16,
             //                    fontWeight: FontWeight.normal,
             //                    fontFamily: 'BerlinSansFB',
             //                  ),
             //                ),
             //              ),
             //            ),//want
             //          //SizedBox(height: screenHeight * 0.01),
             //          Expanded(
             //            child: Container(
             //              padding: EdgeInsets.only(bottom: 8, top: 8),
             //              child: Text(
             //                'Powered by mega-bee.com',
             //                style: TextStyle(
             //                    fontSize: 10,
             //                    fontWeight: FontWeight.normal,
             //                    fontFamily: 'BerlinSansFB',
             //                    color: yellowColor),
             //              ),
             //            ),
             //          ),//megaBee
             //          Container(
             //            //padding: EdgeInsets.only(bottom: 10),
             //            width: MediaQuery.of(context).size.width * 0.8,
             //            child: !_isLoading
             //                ? ElevatedButton(
             //                    onPressed: () async {
             //                      setState(() {
             //                        _isLoading = true;
             //                      });
             //
             //                    //   var token = pefUser.token;
             //                    //   print('Token:$token');
             //                    //   print('User Role: ${pefUser.role}');
             //                    //   if (pefUser.role == "User") {
             //                    //     Navigator.of(context).pushReplacement(
             //                    //         MaterialPageRoute(
             //                    //             builder: (context) => token != null
             //                    //                 ? MainScreen()
             //                    //                 : SignInScreen()));
             //                    //   } else if (pefUser.role == "Driver") {
             //                    //     Navigator.of(context).pushReplacement(
             //                    //         MaterialPageRoute(
             //                    //             builder: (context) => token != null
             //                    //                 ? NavigationScreen()
             //                    //                 : SignInScreen()));
             //                    //   } else
             //                    //     Navigator.of(context).pushReplacement(
             //                    //         MaterialPageRoute(
             //                    //             builder: (context) => token != null
             //                    //                 ? MainScreen()
             //                    //                 : SignInScreen()));
             //                    },
             //                    child: Text(
             //                      'Continue',
             //                      style: TextStyle(
             //                        fontSize: 16,
             //                        fontWeight: FontWeight.w600,
             //                      ),
             //                    ),
             //                    style: ElevatedButton.styleFrom(
             //                      padding: EdgeInsets.fromLTRB(
             //                          screenHeight * 0.1,
             //                          screenHeight * 0.025,
             //                          screenHeight * 0.1,
             //                          screenHeight * 0.025),
             //                      onPrimary: Color.fromRGBO(254, 212, 48, 1),
             //                      primary: Color.fromRGBO(51, 51, 51, 1),
             //                      shape: new RoundedRectangleBorder(
             //                        borderRadius:
             //                            new BorderRadius.circular(15.0),
             //                      ),
             //                    ),
             //                  )
             //                : Center(child: CircularProgressIndicator()),
             //          ),//continue
             //        ],
             //      ),
             //      padding: EdgeInsets.only(
             //        top: 20.0,
             //        bottom: 10,
             //      ),
             //    ),
            ],
          ),
        ),
      ),
    );
  }
}
