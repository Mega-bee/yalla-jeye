import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:yallajeye/providers/user.dart';
import 'package:yallajeye/screens/auth/set-new-password.dart';

import '../../constants/colors_textStyle.dart';

import '../navigation bar/navigation_bar.dart';

class PhoneVerification extends StatefulWidget {
  final String phoneNumber;
  final bool isResetPass;

  PhoneVerification(this.phoneNumber, this.isResetPass); // var _contact;

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  String phoneNo;
  String smsOTP = '';
  String verificationId;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String errorMessage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateOtp();
  }

  generateOtp() async {
    final auth = Provider.of<UserProvider>(context, listen: false);
    try {
      await auth.generateOtp(widget.phoneNumber);
    } catch (e) {
      handleError(e as PlatformException);
      Navigator.pop(context, (e as PlatformException).message);
    }
  }

  final _scaffKey = GlobalKey<ScaffoldState>();

//Method for handle the errors
  void handleError(PlatformException error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        showAlertDialog(context, 'Invalid Code');
        break;
      default:
        showAlertDialog(context, error.message);
        break;
    }
  }

//Basic alert dialogue for alert errors and confirmations
  void showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("'Ok "),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();

    final auth = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      //  key:_scaffKey,
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          'OTP Verification',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.normal,
              fontSize: 14),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [Colors.white, Colors.white, Colors.white],
                stops: [0.1, 0.3, 1])),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 20,
            vertical: MediaQuery.of(context).size.height / 20),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Please enter the 4-digit code you received via text message",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 15,
            ),
            Center(
                child: Container(
                  width:MediaQuery.of(context).size.height/3 ,
                  child: TextField(
                    maxLength: 4,
                    keyboardType:TextInputType.phone ,
                    decoration: new InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder:  const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    textDirection:TextDirection.ltr ,
                    onChanged: (value) async {
                      if(value.length==4) {
                        FocusScope.of(context).unfocus();
                        Fluttertoast.showToast(
                            msg: 'Loading',
                            fontSize: 15,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            textColor: Colors.white,
                            backgroundColor: redColor,
                            toastLength: Toast.LENGTH_SHORT
                        );
                      bool otpVerify=  await auth.confirmOtp(widget.phoneNumber,value);
                      if(otpVerify){
                        if(widget.isResetPass){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context)=> SetNewPassword(widget.phoneNumber)), (route) => false);
                        }
                       else {
                          bool confirmAccount = await auth.confirmAccountOtp(
                              widget.phoneNumber);
                          if (confirmAccount) {
                            // auth.status=Status.isVerified;
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Navigation()),
                                    (Route<dynamic> route) => false);
                          } else {
                            Fluttertoast.showToast(
                                msg: 'otp not valid',
                                fontSize: 15,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 2,
                                textColor: Colors.white,
                                backgroundColor: redColor,
                                toastLength: Toast.LENGTH_SHORT
                            );
                          }
                        }

                      }else{
                        Fluttertoast.showToast(
                                    msg: 'otp not valid',
                                    fontSize: 15,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 2,
                                    textColor: Colors.white,
                                    backgroundColor: redColor,
                                    toastLength: Toast.LENGTH_SHORT
                                );
                      }

                        // try {
                        //   if (await AuthModelSignUp.ConfirmOTPservice(widget._contact, smsOTP)) {
                        //     if (await authProvider.signUp(
                        //         widget.image,
                        //         address.evendatecontroller.text)) {
                        //       // setState(() {
                        //       //   _loading = false;
                        //       // });
                        //       Navigator.pushAndRemoveUntil(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => Navigation(),
                        //           ),
                        //               (Route<dynamic> route) => false
                        //       );
                        //     } else {
                        //
                        //       // MotionToast.error(
                        //       //   title: "Cater me",
                        //       //   titleStyle:
                        //       //   TextStyle(fontWeight: FontWeight.bold),
                        //       //   description:
                        //       //   '${authProvider.lg[authProvider
                        //       //       .language]["${authProvider
                        //       //       .messageSignUp.toString()}"]}',
                        //       //   //  animationType: ANIMATION.FROM_LEFT,
                        //       // ).show(context);
                        //       Fluttertoast.showToast(
                        //           msg: 'otp not valid',
                        //           fontSize: 15,
                        //           gravity: ToastGravity.BOTTOM,
                        //           timeInSecForIosWeb: 2,
                        //           textColor: Colors.white,
                        //           backgroundColor: redColor,
                        //           toastLength: Toast.LENGTH_SHORT
                        //       );
                        //       authProvider.messageSignUp = "";
                        //     }
                        //   }
                        //
                        //   else {
                        //     Fluttertoast.showToast(
                        //         msg: 'otp not valid',
                        //         fontSize: 15,
                        //         gravity: ToastGravity.BOTTOM,
                        //         timeInSecForIosWeb: 2,
                        //         textColor: Colors.white,
                        //         backgroundColor: redColor,
                        //         toastLength: Toast.LENGTH_SHORT
                        //     );
                        //   }
                        //
                        //
                        // } catch (e) {
                        //   {
                        //     // MotionToast.error(
                        //     //     title: "Cater me",
                        //     //     titleStyle:
                        //     //     TextStyle(fontWeight: FontWeight.bold),
                        //     //     description:
                        //     //     'otp not valid'
                        //     // ).show(context);
                        //     Fluttertoast.showToast(
                        //         msg: 'otp not valid',
                        //         fontSize: 15,
                        //         gravity: ToastGravity.BOTTOM,
                        //         timeInSecForIosWeb: 2,
                        //         textColor: Colors.white,
                        //         backgroundColor: redColor,
                        //         toastLength: Toast.LENGTH_SHORT
                        //     );
                        //
                        //     return;
                        //   }
                        // }
                        //  verifyOtp();
                      }                         },
                  ),
                )),
            TextButton(onPressed: ()async{
              try{
                await auth.resendOtp(widget.phoneNumber);
              }catch(e){
                handleError(e as PlatformException);
                Navigator.pop(context, (e as PlatformException).message);
              }

            },
              child:  Text(
                "Resend code",
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
