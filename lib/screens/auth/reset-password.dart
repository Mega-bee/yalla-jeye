
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yallajeye/screens/auth/phone_verification.dart';
import 'package:yallajeye/screens/auth/reset-password-email.dart';
import 'package:yallajeye/screens/auth/signin_screen.dart';

import '../../providers/user.dart';


class ResetPasswordScreen extends StatefulWidget {
  static const String screenRoute = 'reset_password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  //cutom class
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController emailController = TextEditingController();
  void validate() {
    if (formkey.currentState.validate()) {
      // ignore: avoid_print
      print('Validated');
    } else {
      // ignore: avoid_print
      print('Not validated');
    }
  }

  //cutom class
  String validatePass(value) {
    if (value.isEmpty) {
      return 'Required *';
    } else if (value.length < 6) {
      return 'Should Se At Least 6 Characters';
    } else if (value.length > 15) {
      return 'Should Not Be More Than 15 characters';
    } else {
      return null;
    }
  }
  final _scaffold = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context, listen: true);
    var screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return SafeArea(
      child: Scaffold(
        key: _scaffold,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20, left: 27),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 41,
                      color: Color.fromRGBO(254, 212, 48, 1),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.08,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 37),
                  height: screenHeight * 0.06,
                  child: FittedBox(
                    child: Text(
                      'Reset Password ',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'BerlinSansFB',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 37),
                  height: screenHeight * 0.05,
                  child: FittedBox(
                    child: Text(
                      'In order to reset you password, please\nenter the phone number you used to sign in',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'BerlinSansFB',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 35.0, left: 37.0, right: 37.0),
                  child: Column(
                    children: [
                      Center(
                        child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: formkey,
                          child: Column(children: [
                            TextFormField(
                              controller: emailController,
                              maxLength: 8,
                              decoration: InputDecoration(
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
                                hintText: 'Phone',
                                 hintMaxLines: 8,
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
                              keyboardType: TextInputType.phone,
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.1,
                      ),
                    _isLoading?CircularProgressIndicator():
                    ElevatedButton(
                        onPressed: ()async {
                          setState(() {
                            _isLoading = true;
                          });
                          // final SharedPreferences sharedPreferences =
                          //     await SharedPreferences.getInstance();
                          // sharedPreferences.setString(
                          //     'email', emailController.text);

                          if (formkey.currentState.validate() == false) {
                            // ignore: avoid_print
                            print('Not Validated');
                            setState(() {
                              _isLoading = false;
                            });
                            // reset!=null?
                          } else {
                            if (await authProvider.forgetpasswordWithPhone(emailController.text)) {
                          print("logged");
                          setState(() {
                          _isLoading = false;
                          });
                          SharedPreferences sh =
                          await SharedPreferences.getInstance();
                          sh.setBool("logged", true);

                          Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                          builder: (context) =>
                              PhoneVerification(emailController.text,true)),
                          );
                          //authProvider.status=Status.Authenticated;
//                          setState(() {});
                          } else {
                          print("hello");
                          setState(() {
                          _isLoading = false;
                          });
                          _scaffold.currentState.showSnackBar(
                          SnackBar(
                          content: Text(
                          "error try again"),
                          ),
                          );
                          authProvider.forgetpass = "";
                          }
                        }
                        },
                        child: Text('Reset'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(25),
                          onPrimary: Color.fromRGBO(254, 212, 48, 1),
                          primary: Color.fromRGBO(51, 51, 51, 1),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                          ),
                        ),
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

  // doForgetPassword(BuildContext context,String email) async{
  //   try{
  //     setState(() {
  //       _isLoading=true;
  //     });
  //     String result =  await ApiCall().forgetPasswordMain(email);
  //     print("result in change password screen:$result");
  //     if(result!=null) {
  //       Navigator.pop(context);
  //       buildShowDialog(context, result.toString());
  //       setState(() {
  //         _isLoading=true;
  //       });
  //     } else {
  //       buildShowDialog(context, "Failed to reset password");
  //       setState(() {
  //         _isLoading=false;
  //       });
  //     }
  //   }on HttpException catch (e) {
  //     print('in http exception bl reset password screen');
  //     print("print e:$e");
  //     var errorMessage = "unable to reset your password";
  //     if(e.toString().contains("User doesn't exist")) {
  //       buildShowDialog(context, "user doesn't exist");
  //     }
  //       else  buildShowDialog(context, errorMessage);
  //       setState(() {
  //         _isLoading=false;
  //       });
  //   }
  //   catch(e){
  //     print("inside change password screen final catch");
  //     print(e);
  //     var errorMessage = "Failed to reset your password";
  //     buildShowDialog(context, errorMessage);
  //     setState(() {
  //       _isLoading=false;
  //     });
  //   }
  // }
}
