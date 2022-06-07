//import 'package:flutter/material.dart';
//
//class ResetPasswordEmailScreen extends StatefulWidget {
//  static const String screenRoute = 'reset_password-email';
//
//  @override
//  State<ResetPasswordEmailScreen> createState() => _ResetPasswordEmailScreen();
//}
//
//class _ResetPasswordEmailScreen extends State<ResetPasswordEmailScreen> {
//  @override
//  Widget build(BuildContext context) {
//    var screenHeight =
//        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
//    return Scaffold(
//      body: SingleChildScrollView(
//        child: Container(
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//              Container(
//                //height: constraints.maxHeight * 0.09,
//                padding: const EdgeInsets.only(top: 20, left: 27),
//                child: IconButton(
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                  },
//                  icon: const Icon(
//                    Icons.arrow_back,
//                    size: 41,
//                    color: Color.fromRGBO(254, 212, 48, 1),
//                  ),
//                ),
//              ),
//              Container(
//                padding: EdgeInsets.symmetric(horizontal: 37),
//                child: Stack(
//                  children: [
//                    Container(
//                      height: 102,
//                      margin: EdgeInsets.fromLTRB(37.0, 124.0, 0.0, 0.0),
//                      child: const Text(
//                        'Thank you ',
//                        style: TextStyle(
//                          fontSize: 40,
//                          fontWeight: FontWeight.w600,
//                          fontFamily: 'BerlinSansFB',
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//              Container(
//                padding: const EdgeInsets.symmetric(horizontal: 37),
//                child: const Text(
//                  'please check your mail and follow the instruction to reset your password ',
//                  // 'Details to reset your password have been\nsent to your email.',
//                  style: TextStyle(
//                    fontSize: 17,
//                    fontWeight: FontWeight.normal,
//                    fontFamily: 'BerlinSansFB',
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
