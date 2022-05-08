import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';
import 'package:yallajeye/driver/order/order_details.dart';

import '../providers/user.dart';

class TrackingCardNN extends StatefulWidget {
  const TrackingCardNN({Key key}) : super(key: key);

  @override
  State<TrackingCardNN> createState() => _TrackingCardNNState();
}

class _TrackingCardNNState extends State<TrackingCardNN> {
  bool button = true;
  final appBar = AppBar(
    title: Text('Orders'),
  );
  getData()async{
    final driver=Provider.of<UserProvider>(context,listen:false);
    await driver.getDriverOrders();
  }
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
     final driver=Provider.of<UserProvider>(context);
     final mediaQuery=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Image.asset(
        'assets/images/logo.png',
        height: 40,
      ),),
        body: driver.listOfDriverOrder.isEmpty
            ? Center(
                child: FittedBox(child: Text("No missions assigned!",style: TextStyle(fontFamily: "BerlinSansFB",fontSize: 40),)),
              )
            :
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.separated(
                separatorBuilder: (context,index){
                  return const SizedBox(height: 10,);
                },
                  itemCount: driver.listOfDriverOrder.length,
                  itemBuilder: (context, index) {
                return  InkWell(
                  onTap: () {
                   Navigator.of(context).push(MaterialPageRoute(builder: (_)=>OrderDetails(orderId:driver.listOfDriverOrder[index].id,)));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${driver.listOfDriverOrder[index].userName}",style: TextStyle(fontFamily: "BerlinSansFB",fontSize: 15)),
                              SizedBox(
                                height:
                                mediaQuery.height * 0.01,
                              ),
                              Text("${driver.listOfDriverOrder[index].city}",style: TextStyle(fontFamily: "BerlinSansFB",fontSize: 15)),
                            ],
                          ),
                          Text("${driver.listOfDriverOrder[index].orderStatus}",style: TextStyle(fontFamily: "BerlinSansFB",fontSize: 22,color: redColor))
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ));

  }
}
