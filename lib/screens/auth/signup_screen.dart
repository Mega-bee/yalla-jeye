import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';
import 'package:yallajeye/providers/user.dart';
import 'package:yallajeye/screens/auth/phone_verification.dart';
import 'package:yallajeye/screens/auth/signin_screen.dart';

import '../../widgets/custom_gender.dart';
import 'profile_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String screenRoute = 'signup_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String email = '', password = '', confirmPassword = '';
  bool passObscure = true;
  bool confObscure = true;

  String validateMobile(String value) {
    if (value.length != 8)
      return 'Mobile Number must be of 8 digit';
    else
      return null;
  }

  bool validate() {
    if (formkey.currentState != null) {
      if (formkey.currentState.validate()) {
        if (password == confirmPassword) {
          // ignore: avoid_print

          print('Validated');
          return true;
        }
      } else {
        // ignore: avoid_print
        print('Not validated');
        return false;
      }
    }
    return false;
  }

  String validatePass(value) {
    if (value.trim().isEmpty) {
      return "this field is required";
    }
    // if (value.trim().length < 6) {
    //   return "this field should be at least 6 character";
    // }
    // if (!RegExp(r"[A-Z]").hasMatch(value) == true ||
    //     !RegExp(r"[a-z]").hasMatch(value) == true ||
    //     !RegExp(r"[!@#$%^&*(),.?:{}|<>]").hasMatch(value) ||
    //     !RegExp(r"[0-9]").hasMatch(value) == true) {
    //   return "Must have Upper,LowerCase,Special Character & Number";
    // }
    return null;
  }

  bool isLoading = false;
  bool agree = false;

  String message = "";

  File image;
  FocusNode _focusNode = FocusNode();

  Future PickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
      // ignore: nullable_type_in_catch_clause
    } on PlatformException catch (e) {
      print('Failed : $e');
    }
  }

  // void _showToast() {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     fontSize: 18,
  //     gravity: ToastGravity.TOP,
  //       toastLength: Toast.LENGTH_SHORT
  //   );
  // final scaffold = ScaffoldMessenger.of(context);
  // scaffold.showSnackBar(
  //   SnackBar(
  //     content:  Text(message),
  //     action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
  //   ),
  // );
  // }
  final _signupkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context, listen: true);
    var screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return SafeArea(
      child: Scaffold(
        key: _signupkey,
        body: SingleChildScrollView(
          child: Container(
            //  alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  //height: constraints.maxHeight * 0.09,
                  padding: EdgeInsets.only(top: 20, left: 27),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 37),
                  child: Container(
                    height: screenHeight * 0.06,
                    margin:
                        EdgeInsets.fromLTRB(0.0, screenHeight * 0.01, 0.0, 0.0),
                    child: FittedBox(
                      child: Text(
                        'Sign Up ',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'BerlinSansFB',
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
                  height: screenHeight * 0.20,
                  child: GestureDetector(
                    onTap: () => _buildShowBottomSheet(),
                    // child: CircleAvatar(
                    //   backgroundColor: Color(0xFFE2E2E2),
                    //   minRadius: 16,
                    //   maxRadius: screenHeight * 0.2,
                    //   backgroundImage: image == null ? null : FileImage(image),
                    //   child: image == null
                    //       ? Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Image.asset(
                    //               "assets/images/profile.png",
                    //               height: screenHeight * 0.15,
                    //             ),
                    //             SizedBox(
                    //               height: 5,
                    //             ),
                    //             Text(
                    //               'Add Profile',
                    //               style: TextStyle(
                    //                   fontSize: 9,
                    //                   color: Color(0xFF878787),
                    //                   fontWeight: FontWeight.bold,
                    //                   decoration: TextDecoration.underline),
                    //             ),
                    //           ],
                    //         )
                    //       : Container(),
                    // ),
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFE2E2E2),
                      minRadius: 10,
                      maxRadius: screenHeight * 0.2,
                      backgroundImage: image == null ? null : FileImage(image),
                      child: image == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/profile.png",
                                  height: screenHeight * 0.10,
                                ),
                                Text(
                                  'Choose picture',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 20.0, left: 37.0, right: 37.0),
                  child: Column(
                    children: [
                      Center(
                        child: Form(
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: formkey,
                          child: Column(children: [
                            TextFormField(
                              controller: authProvider.phoneNumber,
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
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'BerlinSansFB',
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(135, 135, 135, 1),
                                ),
                              ),
                              validator: validateMobile,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(
                              height: screenHeight * 0.015,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // onChanged: (value) => password = value,
                              controller: authProvider.password,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(fontSize: 10),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      passObscure = !passObscure;
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
                                    bottom: screenHeight * 0.025,
                                    top: screenHeight * 0.025),
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'BerlinSansFB',
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(135, 135, 135, 1),
                                ),
                              ),
                              validator: validatePass,

                              keyboardType: TextInputType.visiblePassword,
                              obscureText: passObscure,
                            ),
                            SizedBox(
                              height: screenHeight * 0.015,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // onChanged: (value) => confirmPassword = value,
                              controller: authProvider.confirmpassword,
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
                                    bottom: screenHeight * 0.025,
                                    top: screenHeight * 0.025),
                                hintText: 'Confirm Password',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'BerlinSansFB',
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(135, 135, 135, 1),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "this field is required";
                                }
                                if (value != authProvider.password.text) {
                                  print(value);
                                  return "Confirmation password does not match the entered password";
                                }
                                return null;
                              },
                              obscureText: confObscure,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                              //height: constraints.maxHeight * 0.02,
                            ),
                            TextFormField(
                              // onSaved: (value) => name = value,
                              controller: authProvider.name,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                contentPadding: EdgeInsets.all(15),
                                hintText: 'Name',
                                hintStyle: TextStyle(
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
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                              //height: constraints.maxHeight * 0.02,
                            ),
                            CustomCupertinoPicker(
                              label: "Gender",

                              items: authProvider.genderIdList.map((value) {
                                return value.name;
                              }).toList(),

                              // events: address.regular.events,
                              selectedValue: 0,
                              inputType: TextInputType.text,
                              controller: authProvider.gender,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                              // height: constraints.maxHeight * 0.02,
                            ),
                            TextFormField(
                              // onSaved: (value) => phoneNumber = value,
                              controller: authProvider.email,
                              validator: MultiValidator([
                                EmailValidator(errorText: "Not a valid email")
                              ]),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                contentPadding: EdgeInsets.all(15),
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'BerlinSansFB',
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(135, 135, 135, 1),
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                              //height: constraints.maxHeight * 0.04,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 11,
                              // margin: EdgeInsets.only(bottom: 5),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white, //white
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(17))),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(
                                        fontFamily: 'BerlinSansFB',
                                        fontSize:
                                            _focusNode.hasFocus ? 20 : 18.0,
                                        //I believe the size difference here is 6.0 to account padding
                                        color: _focusNode.hasFocus
                                            ? Color(0xFF3F5521)
                                            : Colors.grey),
                                    labelText: "birthdate",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      borderSide: BorderSide.none,
                                      // const BorderSide(
                                      //   color: Colors.grey,
                                      // ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF3F5521),
                                        ))),
                                style: TextStyle(color: Colors.black),
                                focusNode: _focusNode,
                                controller: authProvider.birthday,
                                onTap: () {
                                  _focusNode.unfocus();
                                  showPicker(context);
                                },
                                readOnly: true,
                              ),
                            )
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            child: Checkbox(
                                value: agree,
                                onChanged: (value) {
                                  setState(() {
                                    agree = value;
                                  });
                                }),
                          ),
                          Column(children: [
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: 'Agree to terms & condition ',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'BerlinSansFB',
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      !isLoading
                          ? ElevatedButton(
                              onPressed: () async {
                                if (!formkey.currentState.validate() || authProvider.name.text.isEmpty||authProvider.phoneNumber.text.isEmpty||authProvider.gender.text.isEmpty||authProvider.birthday.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Please fill all the fields",
                                      fontSize: 15,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 2,
                                      textColor: Colors.white,
                                      backgroundColor: redColor,
                                      toastLength: Toast.LENGTH_SHORT);
                                }else {
                                  print("test");
                                  if (agree) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    bool signup;
                                   signup = await authProvider.signUp(image);
                                   print("bool is ${signup}");
                                    if (signup) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              PhoneVerification(
                                                  authProvider.phoneNumber
                                                      .text),
                                        ),
                                      );

                                    }else{
                                      Fluttertoast.showToast(
                                          msg: authProvider.message,
                                          fontSize: 15,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 2,
                                          textColor: Colors.white,
                                          backgroundColor: redColor,
                                          toastLength: Toast.LENGTH_SHORT);
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Please agree our terms",
                                        fontSize: 15,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 2,
                                        textColor: Colors.white,
                                        backgroundColor: redColor,
                                        toastLength: Toast.LENGTH_SHORT);
                                  }

                                } },
                              child: Text('Next'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(
                                    screenHeight * 0.05,
                                    screenHeight * 0.025,
                                    screenHeight * 0.05,
                                    screenHeight * 0.025),
                                onPrimary: Color.fromRGBO(254, 212, 48, 1),
                                primary: Color.fromRGBO(51, 51, 51, 1),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                              ),
                            )
                          : Center(child: CircularProgressIndicator()),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: FittedBox(
                              child: Text(
                                'Already a user?',
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
                                  ' Sign in',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'BerlinSansFB',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignInScreen()));
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
    );
  }

  DateTime _chosenDate = DateTime.now();
  DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
  DateFormat _monthFormat = DateFormat('MMMM');
  DateFormat _yearFormat = DateFormat('yyyy');
  DateFormat _dayFormat = DateFormat('dd');
  String _chosenMonth = "";
  String _chosenYear = "";
  String _chosenDay = "";

  void showPicker(ctx) {
    final auth = Provider.of<UserProvider>(context, listen: false);
    DatePicker.showDatePicker(
      ctx,
      onMonthChangeStartWithFirstDate: true,
      pickerTheme: DateTimePickerTheme(
        showTitle: false,
        // backgroundColor: LightColors.kLightYellow2,
        itemTextStyle: TextStyle(
          color: redColor,
        ),
      ),
      initialDateTime: _chosenDate,
      maxDateTime: DateTime.now(),
      minDateTime: DateTime(1950),
      dateFormat: 'MMMM-yyyy-dd',
      onClose: () {},
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(
          () {
            _chosenDate = dateTime;
            _chosenDay = _dayFormat.format(dateTime);
            _chosenMonth = _monthFormat.format(dateTime);
            _chosenYear = _yearFormat.format(dateTime);
            auth.birthday.text = _dateFormat.format(dateTime);
          },
        );
      },
    );
  }

  _buildShowBottomSheet() {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera,
                  color: Color.fromRGBO(
                    232,
                    47,
                    28,
                    1,
                  ),
                ),
                title: Text(
                  'Camera',
                  style: TextStyle(
                    fontFamily: 'BerlinSansFB',
                    fontSize: 16,
                    color: Color.fromRGBO(232, 47, 28, 1),
                  ),
                ),
                onTap: () {
                  PickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.image,
                  color: Color.fromRGBO(
                    232,
                    47,
                    28,
                    1,
                  ),
                ),
                title: Text(
                  'Gallery',
                  style: TextStyle(
                    fontFamily: 'BerlinSansFB',
                    fontSize: 16,
                    color: Color.fromRGBO(232, 47, 28, 1),
                  ),
                ),
                onTap: () {
                  PickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
