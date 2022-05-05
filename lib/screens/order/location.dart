import 'dart:async';import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../constants/colors_textStyle.dart';


class LocationMap extends StatefulWidget {


  @override

  LocationMapState createState() => LocationMapState();
}

class LocationMapState extends State<LocationMap> {

    GoogleMapController googleMapController;

  static const LatLng _center = const LatLng(45.521563, -122.677433);
  Location currentLocation = Location();

  // void getLocation() async{
  //   final c = await _controller.future;
  //   var location = await currentLocation.getLocation();
  //   currentLocation.onLocationChanged.listen((LocationData loc){
  //
  //     c.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
  //       target: LatLng(loc.latitude ?? 0.0,loc.longitude?? 0.0),
  //       zoom: 12.0,
  //     )));
  //     print(loc.latitude);
  //     print(loc.longitude);
  //     setState(() {
  //       _markers.add(Marker(markerId: MarkerId('Home'),
  //           position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)
  //       ));
  //     });
  //   });
  // }

  void _onMapCreated(GoogleMapController controller) {

  }
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapTypeButtonPressed() {

    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
  LatLng currentLatLng = LatLng(
      33.8463, 35.9020); //initial currentPosition values cannot assign null values

  bool loading = false;


Future<Position> _determinePosition() async {
    bool serviceEnable;
    LocationPermission permission;
    serviceEnable = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnable) {
      return Future.error('Location Are Disable');
    }
    permission =await Geolocator.checkPermission();
    if(permission ==LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if (permission ==LocationPermission.denied){
        return Future.error('Location Permission Denied');
      }
    }
   if (permission ==LocationPermission.deniedForever){
     return Future.error('Location Permission Are Permanently Denied');
   }
   Position position = await Geolocator.getCurrentPosition();
   return position;
    }


  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }
  @override

  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(

        appBar: AppBar(
          title: Text('Map'),
          leading: IconButton(
            onPressed: (){Navigator.pop(context);},
            icon: Icon(Icons.arrow_back),

          ),
          backgroundColor:redColor,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onCameraMove: _onCameraMove,
              markers: _markers,
              myLocationEnabled: true,
              mapType: _currentMapType,
              buildingsEnabled: true,
              compassEnabled: true,
              mapToolbarEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: _onMapCreated,
              initialCameraPosition:

              CameraPosition(target: currentLatLng,zoom: 10.2),


              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children:[
                    FloatingActionButton(
                    onPressed: () => _onMapTypeButtonPressed(),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor:redColor,
                    child: const Icon(Icons.map, size: 30.0),
                  ),
                    SizedBox(height: 12,),
                    FloatingActionButton(
                      onPressed: _onAddMarkerButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor:redColor,
                      child: const Icon(Icons.add_location, size: 30.0),
                    ),
                    SizedBox(height: 12,),
                    // FloatingActionButton(
                    //   onPressed: () async{
                    //     Position position = await _determinePosition();
                    //     googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                    //       position.latitude,position.longitude,
                    //     ),zoom: 10,
                    //     )));
                    //     _markers.clear();
                    //     _markers.add(Marker(markerId: MarkerId('Current Location'),position:LatLng(position.latitude,position.longitude,),
                    //     ));
                    //     setState(() {
                    //
                    //     });
                    //   },
                    //   materialTapTargetSize: MaterialTapTargetSize.padded,
                    //   backgroundColor:redColor,
                    //   child: const Icon(Icons.add, size: 30.0),
                    // ),

            //         FloatingActionButton(
            // child: Icon(Icons.location_searching,color: Colors.white,),
            // onPressed: (){
            //   getLocation();
            // },)
                ]),
              ),
            ),
            Align(
                alignment: Alignment.center,
                // child: !loadingconf?
                // InkWell(
                //
                //     onTap: () async {
                //       setState(() {
                //         loadingconf==true;
                //       });
                //       await getCurrentLocation();
                //       setState(() {
                //         loadingconf==false;
                //       });
                //     },
                    child: Icon(
                      Icons.place,
                      size: 20,
                      color: redColor,
                    ))

          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(

          backgroundColor: redColor,
          

          shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(width: 1,color: yellowColor)),
          elevation: 2,
           label:Text("Confirm Location",style: TextStyle(fontSize: 10),),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
    );

  }
}
