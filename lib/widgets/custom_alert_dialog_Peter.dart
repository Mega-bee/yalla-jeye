import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors_textStyle.dart';

class CustomAlertDialogPeter extends StatefulWidget {
  final String title;
  final String content;
 final Function cancelBtnFn;
 final Function confrimBtnFn;

  CustomAlertDialogPeter({
 @required this.title,@required this.content,@required this.cancelBtnFn,@required this.confrimBtnFn});
  @override
  State<CustomAlertDialogPeter> createState() => _CustomAlertDialogPeter();
}

class _CustomAlertDialogPeter extends State<CustomAlertDialogPeter> {
  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
                15)),
        title: Text(
          widget.title,
          style:const TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.bold,
              fontFamily:
              "BerlinSansFB"),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Text(
              widget.content,
              style:const TextStyle(
                fontSize: 17,
                fontFamily:
                "BerlinSansFB",
              ),
              textAlign:
              TextAlign.center,
            ),
            // const SizedBox(
            //   height: 10,
            // ),
           Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: [
                TextButton(
                    onPressed: widget.cancelBtnFn,
                    child:const Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize:
                          15,
                          fontWeight:
                          FontWeight
                              .bold,
                          fontFamily:
                          "BerlinSansFB",
                          color: Colors
                              .black),
                    )),
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                      widget.confrimBtnFn;

                    },
                    child:const Text(
                        "Confirm",
                        style: TextStyle(
                            fontSize:
                            15,
                            fontWeight: FontWeight
                                .bold,
                            fontFamily:
                            "BerlinSansFB",
                            color:
                            yellowColor))),
              ],
            ),
          ],
        ),

      )
    ;
  }
}
