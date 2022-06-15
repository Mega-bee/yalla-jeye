import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';
import 'package:yallajeye/models/home_page.dart';
import 'package:yallajeye/providers/homePage.dart';
import 'package:yallajeye/screens/home/ads_details.dart';
import 'package:yallajeye/screens/order/order_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeIndex1;
  int activeIndex2;
  HomePageProvider homePage;
  var mediaQueryHeight;
  var mediaQueryWidth;

  getData() async {
    await homePage.getHomePage();
    await homePage.defaultLocation();

  }
  @override
  void initState() {
    super.initState();
    homePage = Provider.of<HomePageProvider>(context, listen: false);
    activeIndex1 = 0;
    activeIndex2 = 0;
    getData();
  }


  @override
  Widget build(BuildContext context) {
    mediaQueryHeight = MediaQuery.of(context).size.height;
    mediaQueryWidth = MediaQuery.of(context).size.width;
    homePage = Provider.of<HomePageProvider>(context, listen: true);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child:
            homePage.loading ?
            const  Center(child: CircularProgressIndicator(),):
            RefreshIndicator(
                    onRefresh: () async {
                      await homePage.getHomePage();
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          homePage.services.isEmpty ?
                          Image.asset(
                            'assets/images/logo.png',
                            height: MediaQuery.of(context).size.height * 0.25,
                          ):
                          CarouselSlider.builder(
                            itemCount: homePage.services.length,
                            itemBuilder: (context, index, reaIndex) {
                              final list = homePage.services[index];
                              return buildAdsService(list);
                            },
                            options: CarouselOptions(
                              onPageChanged: (index, reason) => setState(() {
                                activeIndex1 = index;
                              }),
                              autoPlay: true,
                              height: mediaQueryHeight * 0.32,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              viewportFraction: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: mediaQueryHeight * 0.02,
                                horizontal: mediaQueryWidth * 0.05),
                            child: buildIndicator1(),
                          ),
                          CarouselSlider.builder(
                            itemCount: homePage.other.length,
                            itemBuilder: (context, index, reaIndex) {
                              final list = homePage.other[index];
                              return buildAdsService(list);
                            },
                            options: CarouselOptions(
                              onPageChanged: (index, reason) => setState(() {
                                this.activeIndex2 = index;
                              }),
                              autoPlay: true,
                              height: mediaQueryHeight * 0.32,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              viewportFraction: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: mediaQueryHeight * 0.02,
                                horizontal: mediaQueryWidth * 0.05),
                            child: buildIndicator2(),
                          )
                        ],
                      ),
                    ),
                  ),
          ),
        ));
  }

  Widget buildAdsService(Ads ads) => InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) =>
              AdsDetails(ads.title, ads.description, ads.imageUrl)));
    },
    child: Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: mediaQueryHeight * 0.25,
            child: Image.network(

              ads.imageUrl,
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
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.infinity,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace stackTrace) {
                return Image.asset(
                  'assets/images/logo.png',
                  height: MediaQuery.of(context).size.height * 0.25,
                );
              },
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: mediaQueryHeight * 0.005,
                  left: mediaQueryWidth * 0.03),
              child: Text(
                ads.title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'BerlinSansFB',
                ),
              ))
        ],
      ),
    ),
  );

  Widget buildIndicator1() => AnimatedSmoothIndicator(
    activeIndex: activeIndex1,
    count: homePage.services.length,
    effect: const ScrollingDotsEffect(
      activeDotColor: redColor,
      dotColor: yellowColor,
      dotHeight: 5,
      dotWidth: 5,
    ),
  );
  Widget buildIndicator2() => AnimatedSmoothIndicator(
    activeIndex: activeIndex2,
    count: homePage.other.length,
    effect: const ScrollingDotsEffect(
      activeDotColor: redColor,
      dotColor: yellowColor,
      dotHeight: 5,
      dotWidth: 5,
    ),
  );
}
