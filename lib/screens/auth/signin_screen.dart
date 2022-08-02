
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yallajeye/driver/navigation.dart';
import 'package:yallajeye/providers/user.dart';
import 'package:yallajeye/screens/auth/signup_screen.dart';
import 'package:yallajeye/screens/navigation%20bar/navigation_bar.dart';
import 'package:yallajeye/widgets/build_show_dialog.dart';

import '../../constants/colors_textStyle.dart';
import 'reset-password.dart';


class SignInScreen extends StatefulWidget {
  static const String screenRoute = 'signIn_screen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool confObscure = true;
  bool _hasInternet;
  String email = '', password = '';
  void validate() {
    if (formkey.currentState.validate()) {
      // ignore: avoid_print
      print('Validated');
    } else {
      // ignore: avoid_print
      print('Not validated');
    }
  }
  String validateMobile(String value) {
    if (value.length != 8)
      return 'Mobile Number must be of 8 digit';
    else
      return null;
  }

  //cutom class
  String validatePass(value) {
    if (value.isEmpty) {
      return 'Required *';
    }
    return null;
  }
  final loginkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context, listen: true);
    var screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return SafeArea(
      child: Scaffold(
        key: loginkey,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 37,
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(

                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        authProvider.clearAllTextController();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 41,
                        color: Color.fromRGBO(254, 212, 48, 1),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: screenHeight * 0.3,
                        padding: EdgeInsets.only(top: screenHeight * 0.05),
                        child: FittedBox(
                          child: Text(
                            'Welcome to\nYALLA JEYE!\n\nSign In',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              fontFamily: 'BerlinSansFB',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding:const EdgeInsets.only(
                      top: 35.0,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Form(
                            // autovalidateMode:
                            // AutovalidateMode.onUserInteraction,
                            key: formkey,
                            child: Column(children: [
                              TextFormField(
                                controller: authProvider.email,
                                maxLength: 8,
                                // onSaved: (value) => email = value,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: screenHeight * 0.03,
                                      bottom: screenHeight * 0.025,
                                      top: screenHeight * 0.025),
                                  hintText: 'Phone Number',
                                  hintStyle:const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'BerlinSansFB',
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(135, 135, 135, 1),
                                  ),
                                ),
                                validator: MultiValidator([
                                  RequiredValidator(errorText: 'Required *'),
                                ]),
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.phone,
                              ),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height * 0.02,
                              ),
                              TextFormField(
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                controller: authProvider.password,
                                // onSaved: (value) => password = value,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      confObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        confObscure = !confObscure;
                                      });
                                    },
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: screenHeight * 0.03,
                                      bottom: screenHeight * 0.03,
                                      top: screenHeight * 0.03),
                                  hintText: 'Password',
                                  hintStyle:const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'BerlinSansFB',
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(135, 135, 135, 1),
                                  ),
                                ),
                                validator: validatePass,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: confObscure ? true : false,
                              ),
                            ]),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Center(
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ResetPasswordScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FittedBox(
                                child: Text(
                                  'Forgot password ?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'BerlinSansFB',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.1,
                        ),
                        Container(
                          child: _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });

                              if (formkey.currentState.validate() == false) {
                                // ignore: avoid_print
                                print('Not Validated');
                                setState(() {
                                  _isLoading = false;
                                });
                                // reset!=null?
                              } else {
                                if (await authProvider.SignIn()) {
                                  print("logged");
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  SharedPreferences sh =
                                  await SharedPreferences.getInstance();
                                  sh.setBool("logged", true);
                                  if(authProvider.status==Status.isVerified){
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Navigation()),
                                            (Route<dynamic> route) => false);
                                  }
                                  if(authProvider.status==Status.isDriver){
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NavigationScreen()),
                                            (Route<dynamic> route) => false);
                                  }


                                  //authProvider.status=Status.Authenticated;
                                  setState(() {});
                                } else {
                                  print("hello");
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: "${authProvider.message}",
                                      fontSize: 15,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 2,
                                      textColor: Colors.white,
                                      backgroundColor: redColor,
                                      toastLength: Toast.LENGTH_SHORT
                                  );
                                  authProvider.messagelogin = "";
                                }
                              }
                            },
                            // onPressed: () => doSignIN(context),
                            child: Text('Sign in'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(
                                  screenHeight * 0.05,
                                  screenHeight * 0.025,
                                  screenHeight * 0.05,
                                  screenHeight * 0.025),
                              onPrimary: Color.fromRGBO(254, 212, 48, 1),
                              primary: Color.fromRGBO(51, 51, 51, 1),
                              shape: new RoundedRectangleBorder(
                                borderRadius:
                                new BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: FittedBox(
                                child: Text(
                                  'First time here?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'BerlinSansFB',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: InkWell(
                                child: FittedBox(
                                  child: Text(
                                    ' Sign up',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'BerlinSansFB',
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignUpScreen()));
                                  authProvider.clearAllTextController();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
