import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yallajeye/screens/auth/signin_screen.dart';

import '../constants/colors_textStyle.dart';
import '../providers/NotificationProvider.dart';
import '../providers/order.dart';
import '../providers/user.dart';
import 'order/tabbar_order.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  getData() async {
    final noti = Provider.of<NotificationProvider>(context, listen: false);
    await noti.getNotifications();
  }

  @override
  void initState() {
    print("All Data");
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true);
    final noti = Provider.of<NotificationProvider>(context, listen: true);

    return Scaffold(
      body: noti.loading
          ? Center(child: CircularProgressIndicator())
          : user.status == Status.isVerified
              ? RefreshIndicator(
        onRefresh: ()async{
         await noti.getNotifications();
        },
                child: ListView.builder(
                    itemCount: noti.services.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          height: 100,
                          child: InkWell(
                            onTap: () {
                              print("ORDER  ID: ${noti.services[index].orderId}");
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => TabBarOrder(
                                     numTab: 0, id: noti.services[index].orderId),
                                ),
                              );
                            },
                            child: Card(
                                child: ListTile(
                              trailing: Text(
                                "${DateFormat.yMd().add_jm().format(
                                      DateTime.parse(
                                          noti.services[index].createdDate),
                                    )}",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black54),
                              ),
                              leading: CircleAvatar(
                                foregroundImage: AssetImage(
                                  "assets/images/motornew.png",
                                ),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red,
                                radius: 20,
                              ),
                              title: Text(
                                "${noti.services[index].title}",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: yellowColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${noti.services[index].description}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black87),
                              ),
                            )),
                          ),
                        ),
                      );
                    }),
              )
              : Center(
                  child: TextButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                    },
                    child: const Text('Sign In',
                        style: TextStyle(
                          color: yellowColor,
                          fontFamily: 'BerlinSansFB',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.035,
                          horizontal: 30),
                      side: const BorderSide(color: Colors.black, width: 1),
                      backgroundColor: const Color(0xFF333333),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
