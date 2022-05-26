import 'package:flutter/material.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';

import 'package:yallajeye/models/home_page.dart';
import 'package:yallajeye/models/restaurant.dart';
import 'package:yallajeye/providers/homePage.dart';
import 'package:yallajeye/providers/user.dart';
import 'package:yallajeye/screens/auth/signin_screen.dart';
import 'package:yallajeye/screens/restaurants/MenuDetails2.dart';

class RestaurantsScreen extends StatefulWidget {
  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  // RestaurantListProvider provider;
  TextEditingController _textEditingController = TextEditingController();
  List<Restaurant> listRes = [];
  List<Restaurants> searchedRestaurant;
  bool _hasInternet;
  HomePageProvider homePage ;
  @override
  void initState() {
    checkConnection();
     homePage = Provider.of<HomePageProvider>(context, listen: false);
//     homePage.getHomePage();
    searchedRestaurant = homePage.restaurants;
    super.initState();
  }

  filter(String value) {
    final homePage = Provider.of<HomePageProvider>(context, listen: false);
    List<Restaurants> results = [];

    if (value.isEmpty) {
      results = homePage.restaurants;
    } else {
      results = homePage.restaurants
          .where((element) => element.restaurantName
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    }
    setState(() {
      searchedRestaurant = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true);
    var _width = MediaQuery.of(context).size.width;
    final qPortrait = MediaQuery.of(context).orientation;

    final mediaQuery = MediaQuery.of(context);
//     homePage = Provider.of<HomePageProvider>(context);
//    final restaurant = homePage.restaurants;

    return SafeArea(
        child: RefreshIndicator(
      onRefresh: () async {
        await homePage.getHomePage();
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            floating: false,
            expandedHeight: MediaQuery.of(context).size.height * 0.05,
            // backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
                background: PreferredSize(
              preferredSize: Size(50, 70),
              child: Container(
                padding: EdgeInsets.only(
                  left: 20,
                  // top: 10,
                  // bottom: 20,
                  right: 20,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (value) => filter(value),
                        controller: _textEditingController,
                        cursorColor: Colors.yellow,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: 'Search your restaurants'),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),
          searchedRestaurant.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Text("No restaurants"),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((con, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => MenuDetails(
                                    restaurantName: searchedRestaurant[index]
                                        .restaurantName,
                                    restaurantLink:
                                        searchedRestaurant[index].pdfUrl,
                                  )),
                        );
                      },
                      child: Container(
                        child: Card(
                          elevation: 3,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.network(
                                  searchedRestaurant[index].imageUrl,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace stackTrace) {
                                    return Image.asset('assets/images/logo.png',
                                    );
                                  },
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null)
                                      return child;
                                    return Padding(
                                      padding:
                                      const EdgeInsets.all(25.0),
                                      child: Center(
                                        child:
                                        CircularProgressIndicator(
                                          color: Colors.red,
                                          value: loadingProgress
                                              .expectedTotalBytes !=
                                              null
                                              ? loadingProgress
                                              .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                  fit: BoxFit.fill,
                                  width: 100,
                                  height: 100,
                                ),
                              ),

                              // SizedBox(
                              //   width: mediaQuery.size.width * 0.1,),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                // text: 'Restaurant Name: ',
                                                // style: TextStyle(
                                                //     fontWeight: FontWeight.bold,
                                                //     color: Colors.black)),
                                                ),
                                            TextSpan(
                                                text: searchedRestaurant[index]
                                                    .restaurantName,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: mediaQuery.size.height * 0.01,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                // text: 'Location: ',
                                                // style: TextStyle(
                                                //     fontWeight: FontWeight.bold,
                                                //     color: Colors.black)
                                                ),
                                            TextSpan(
                                                text: searchedRestaurant[index]
                                                    .location,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: mediaQuery.size.height * 0.01,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Specialty: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: searchedRestaurant[index]
                                                    .speciality,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: mediaQuery.size.height * 0.01,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Opens From:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: searchedRestaurant[index]
                                                    .opensAt,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: mediaQuery.size.height * 0.01,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Rating:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: searchedRestaurant[index]
                                                    .rating
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },childCount: searchedRestaurant.length),
                )
        ],
      ),
    ));
  }

  checkConnection() async {
    _hasInternet = await InternetConnectionChecker().hasConnection;
    if (_hasInternet == false) {
      // showSimpleNotification(Text('No internet Connection',textAlign: TextAlign.center,));
      return;
    }
  }
}
