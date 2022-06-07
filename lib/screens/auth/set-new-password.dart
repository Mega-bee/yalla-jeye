import 'dart:io';


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';
import 'package:yallajeye/screens/auth/reset-password.dart';
import 'package:yallajeye/screens/auth/signin_screen.dart';

import '../../providers/user.dart';


class SetNewPassword extends StatefulWidget {
  final String phoneNumber;

  SetNewPassword(this.phoneNumber);

  @override
  _SetNewPasswordState createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  bool _isLoading = false;
   TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var _newpassword = "";
  bool obscure1 = true;
  bool obscure2 = true;
  bool obscure3 = true;

  var border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(color: Colors.transparent));

  bool validateText() {
    if (_formkey.currentState != null) {
      if (newPassController.text != confirmPassController.text) {
        print("passwords don't match");
        return false;
      }
      if (_formkey.currentState.validate()) {
        // ignore: avoid_print

        print('Validated');
        return true;
      } else {
        // ignore: avoid_print
        print('Not validated');
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Set new Password",
          style: st20Bold,
        ),
        iconTheme: IconThemeData(color: yellowColor),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 25),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: newPassController,
                  obscuringCharacter: "*",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 10),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure2 ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscure2 = !obscure2;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                      hintText: "Enter New Password",
                      hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'BerlinSansFB',
                          color: Color(0xFF878787)),
                      errorBorder: border,
                      focusedErrorBorder: border,
                      border: OutlineInputBorder(),
                      enabledBorder: border,
                      focusedBorder: border),
                  obscureText: obscure2,
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return "this field is required";
                    }
                    if (value.trim().length < 6) {
                      return "this field should be at least 4 character";
                    }
                    if (!RegExp(r"[A-Z]").hasMatch(value) == true ||
                        !RegExp(r"[a-z]").hasMatch(value) == true ||
                        !RegExp(r"[!@#$%^&*(),.?:{}|<>]").hasMatch(value) ||
                        !RegExp(r"[0-9]").hasMatch(value) == true) {
                      return "Must have Upper,LowerCase,Special Character & Number";
                    }
                    return null;
                  },
                  onChanged: (value) => _newpassword = value,
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: confirmPassController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure3 ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscure3 = !obscure3;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                      hintText: "Confirm Password",
                      hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'BerlinSansFB',
                          color: Color(0xFF878787)),
                      errorBorder: border,
                      focusedErrorBorder: border,
                      border: OutlineInputBorder(),
                      enabledBorder: border,
                      focusedBorder: border),
                  obscureText: obscure3,
                  obscuringCharacter: "*",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "this field is required";
                    }
                    if (value != _newpassword) {
                      return "Confirmation password does not match the entered password";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 25,
                ),

                Container(
                  alignment: Alignment.bottomCenter,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _isLoading
                          ? CircularProgressIndicator()
                          : TextButton(
                              onPressed: () async{

                              if (!_formkey.currentState.validate()) {
                              return;
                              } else {
                              setState(() {
                                _isLoading = true;
                              });
                              validateText();
                              var resetPassword =
                              await authProvider.SetNewPasswordWithPhone(widget.phoneNumber,newPassController.text,confirmPassController.text);
                              print(resetPassword);
                              if (resetPassword) {
                              print("Reset succeed");
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>SignInScreen()),(Route<dynamic> route) => false);
                              } else {
                              setState(() {
                                _isLoading = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                              content: Text('Cannot update! Old password is wrong'),
                              ));
                              }

                              }
                              authProvider.clearControllers();
                              },
                              child: const Text('Save',
                                  style: TextStyle(
                                    color: yellowColor,
                                    fontFamily: 'BerlinSansFB',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )),
                              style: TextButton.styleFrom(
                                  padding:const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 40),
                                  side: const BorderSide(
                                      color: Colors.black, width: 1),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  backgroundColor: const Color(0xFF333333)),
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

  // void doChangePassword(context) async {
    // setState(() {
    //   _isLoading = true;
    // });
    // try {
    //   String message = await ApiCall().changePassword(
    //       oldPassword: oldPassController.text,
    //       newPassword: newPassController.text,
    //       confirmPassword: confirmPassController.text);
    //   Navigator.pop(context);
    //   buildShowDialog(context, message);
    //   setState(() {
    //     _isLoading = false;
    //   });
    // } on HttpException catch (e) {
    //   print('in http exception');
    //   var errorMessage = 'change password failed';
    //   if (e.toString().contains("Passwords don't match")) {
    //     errorMessage = "Passwords don't match";
    //     buildShowDialog(context, errorMessage);
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   } else if (e.toString().contains("Wrong password")) {
    //     errorMessage = "wrong password";
    //     buildShowDialog(context, errorMessage);
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   } else if (e.toString().contains("Old password is invalid")) {
    //     print('helooooo');
    //     errorMessage = "Old password is invalid";
    //     buildShowDialog(context, errorMessage);
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   }
    //   else if (e.toString().contains("New password can't be the same as old password")) {
    //     errorMessage = "New password can't be the same as old password";
    //     buildShowDialog(context, errorMessage);
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   }
    // } catch (e) {
    //   var errorMessage='could not change your password, please retry later';
    //   buildShowDialog(context, errorMessage);
    //   print(e.toString());
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  // }

  // doResetPassword(BuildContext context) async {
    //   try{
    //     var result = await buildShowDialogResetPassword(context);
    //     print("result in change password screen:$result");
    //     if(result!=null) {
    //       Navigator.pop(context);
    //       buildShowDialog(context, result.toString());
    //     }
    //     //else buildShowDialog(context, "Failed to reset password");
    //   }on HttpException catch (e) {
    //     print('in http exception bl change password screen');
    //     var errorMessage = "unable to reset your password";
    //     buildShowDialog(context, errorMessage);
    //   }
    //   catch(e){
    //     print("inside change password screen final catch");
    //     print(e);
    //     var errorMessage = "Failed to reset your password";
    //     buildShowDialog(context, errorMessage);
    //   }
    // }
  }
// }
