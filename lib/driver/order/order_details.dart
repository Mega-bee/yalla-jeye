import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';
import 'package:yallajeye/providers/user.dart';
import 'package:yallajeye/widgets/custom_alert_dialog.dart';

enum orderStatus{
   progress,
   onTheWay,
   twoMinutesToDeliver,
}
class OrderDetails extends StatefulWidget {
  final int orderId;

  const OrderDetails({Key key, this.orderId}) : super(key: key);


  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  orderStatus status=orderStatus.progress;
  TextStyle textStyle15=const TextStyle(fontFamily: "BerlinSansFB",fontSize: 15);
  TextStyle textStyleTitle=const TextStyle(fontFamily: "BerlinSansFB",fontSize: 20,color: Color(0xffA2A2A2));


  getData()async{
    final driver=Provider.of<UserProvider>(context,listen: false);
   await driver.getDriverOrderDetails(widget.orderId);
   print("detailss");
   switch(driver.orderDetails.orderStatusId){
     case 6:
        status=orderStatus.onTheWay;
        break;
     case 7:
        status=orderStatus.twoMinutesToDeliver;
        break;
      default:
      status=orderStatus.progress;
      break;
   }
    setState(() {
      loading=false;
    });
  }
  @override
  void initState() {
    super.initState();
    getData();
  }
  bool loading=true;
  bool checkBox=false;
  @override
  Widget build(BuildContext context) {
    final mediaQuery=MediaQuery.of(context).size;
    final driver=Provider.of<UserProvider>(context);
    return SafeArea(child: Scaffold(
      appBar: AppBar(title: Image.asset(
        'assets/images/logo.png',
        height: 40,
      ),foregroundColor: yellowColor,),
    body:loading?Center(child: CircularProgressIndicator(),): SingleChildScrollView(
      child: Container(
        width: mediaQuery.width *1,
        padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(driver.orderDetails.userName,style: textStyle15,),
             const SizedBox(height: 20,),
                Text("Full Address:",style: textStyle15.copyWith(fontWeight: FontWeight.bold),),
                Text("Location: ${driver.orderDetails.address.title}",style: textStyle15,),
                Text("Building: ${driver.orderDetails.address.buildingName}",style: textStyle15,),
                Text("Floor: ${driver.orderDetails.address.floorNumber}",style: textStyle15,),
                Text("Contact: ${driver.orderDetails.phoneNumber}",style: textStyle15,),
                const SizedBox(height: 20,),
              Text("Details",style: textStyleTitle,),
              ListView.builder(
                padding:const EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                  physics:const NeverScrollableScrollPhysics(),
                  itemCount: driver.orderDetails.checkListItems.length,
                  itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text("${driver.orderDetails.checkListItems[index].item}",style: textStyle15,)),
                     Checkbox(value: driver.orderDetails.checkListItems[index].isDone, onChanged: (val)async{
                       bool success=true;
                       if(!driver.orderDetails.checkListItems[index].isDone){
                       showDialog(context: context, builder: (context){
                         return CustomAlertDialog(title: "Are you sure?", content: "This action cannot be undone", cancelBtnFn: (){
                           Navigator.of(context).pop();
                         }, confrimBtnFn: ()async{
                           setState(() {
                             loading=true;
                           });
                           Navigator.of(context).pop();
                           success= await driver.markItemAsDone(driver.orderDetails.checkListItems[index].id);
                           getData();
                           if(!success){
                             Fluttertoast.showToast(
                                 msg: "Something went wrong please try again later",
                                 fontSize: 15,
                                 gravity: ToastGravity.BOTTOM,
                                 timeInSecForIosWeb: 2,
                                 textColor: Colors.white,
                                 backgroundColor: redColor,
                                 toastLength: Toast.LENGTH_SHORT);
                           }
                         });

                       });
                       }
                     })
                    ],
                    ),
                    Divider(thickness: 2,)
                  ],
                );
              }),
              Text("Description",style: textStyleTitle,),
              Card(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("${driver.orderDetails.address.description}",style: textStyle15,),
                    ),
                  ],
                ),

              ),
              Center(
                child: ElevatedButton(onPressed: ()async{
                  int id;
                  if(status==orderStatus.progress){
                    id=6;
                  }
                  if(status==orderStatus.onTheWay){
                    id=7;
                  }
                  if(status==orderStatus.twoMinutesToDeliver){
                    id=5;
                  }
                  bool success=false;
                 await showDialog(context: context, builder: (context){
                    return CustomAlertDialog(title: "Are you sure?", content: "This action cannot be undone", cancelBtnFn: (){
                      Navigator.of(context).pop();
                    }, confrimBtnFn: ()async{
                      setState(() {
                        loading=true;
                      });
                      Navigator.of(context).pop();
                       success=await driver.setDriverOrderStatus(widget.orderId, id);
                       getData();
                      await driver.getDriverOrders();
                      if(!success){
                        Fluttertoast.showToast(
                            msg: "Something went wrong please try again later",
                            fontSize: 15,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            textColor: Colors.white,
                            backgroundColor: redColor,
                            toastLength: Toast.LENGTH_SHORT);
                      }

                    });
                  });
                }, child: Text(status==orderStatus.onTheWay?"Two minutes away":
                status==orderStatus.twoMinutesToDeliver?"Delivered":"On the way",
                  style: TextStyle(fontFamily: "BerlinSansFB",fontSize: 15),
                ),style:  ElevatedButton.styleFrom(
                  padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  onPrimary:const Color.fromRGBO(254, 212, 48, 1),
                  primary:const Color.fromRGBO(51, 51, 51, 1),
                  shape:  RoundedRectangleBorder(
                    borderRadius:
                     BorderRadius.circular(15.0),
                  ),
                ),),
              ),
              ],
            ),
          ),
        ),
      ),
    ),));
  }
}
