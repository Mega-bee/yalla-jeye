import 'dart:async';
import 'dart:math';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../constants/colors_textStyle.dart';

class LocationMap extends StatefulWidget {
  @override
  LocationMapState createState() => LocationMapState();
}

class LocationMapState extends State<LocationMap> {
  GoogleMapController googleMapController;
  Set<Marker> _markers = {};
  LatLng _addresPotion;
  LatLng zahahLat = LatLng(33.8463,
      35.9020); //initial currentPosition values cannot assign null values
  // static const LatLng _center = const LatLng(45.521563, -122.677433);
  // Location currentLocation = Location();


  @override
  void initState() {
    // TODO: implement initState
    defaultLocation();
    // SchedulerBinding.instance?.addPostFrameCallback((Duration duration) async {
    //   await Future.delayed(Duration(seconds: 10)).whenComplete(() {
    //     FeatureDiscovery.discoverFeatures(
    //       context,
    //       const <String>{
    //         'myLocation',
    //         'selectedMenu',
    //       },
    //     );
    //   });
    // });
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {}
  MapType _currentMapType = MapType.normal;

  // LatLng _lastMapPosition = _center;

  // void _onCameraMove(CameraPosition position) {
  //   _lastMapPosition = position.target;
  // }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }



  bool loading = false;

  void defaultLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    var myLocation = await Location.instance.getLocation();
    LatLng myPos = LatLng(myLocation.latitude ?? 0, myLocation.longitude ?? 0);
    if(myPos != null){
      _addresPotion = myPos;
    }else{
      _addresPotion = zahahLat;
    }
    _markers.removeAll(_markers);
    _markers.add(Marker(markerId: MarkerId('Default'),
      position: _addresPotion,
      infoWindow: InfoWindow(
        title: 'Really cool place',
        snippet: '5 Star Rating',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));

setState(() {

});
  }

  // void _onAddMarkerButtonPressed() {
  //   setState(() {
  //     _markers.add(Marker(
  //       // This marker id can be anything that uniquely identifies each marker.
  //       markerId: MarkerId(myPos.toString()),
  //       position: myPos,
  //       infoWindow: InfoWindow(
  //         title: 'Really cool place',
  //         snippet: '5 Star Rating',
  //       ),
  //       icon: BitmapDescriptor.defaultMarker,
  //     ));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Map'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          backgroundColor: redColor,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              // onCameraMove: _onCameraMove,
              markers: _markers,
              onTap: (poti){
                _markers.removeAll(_markers);
                _markers.add(Marker(markerId: MarkerId('selected'),position: poti , icon: BitmapDescriptor.defaultMarker,));
                _addresPotion=poti;
                setState(() {

                });
              },
              myLocationEnabled: true,
              mapType: _currentMapType,
              buildingsEnabled: true,
              compassEnabled: true,
              mapToolbarEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: _onMapCreated,
              initialCameraPosition:
                  CameraPosition(target: zahahLat, zoom: 10.2),

            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(children: [
                  FloatingActionButton(
                    onPressed: () => _onMapTypeButtonPressed(),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: redColor,
                    child: const Icon(Icons.map, size: 30.0),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // FloatingActionButton(
                  //   onPressed: null,
                  //   materialTapTargetSize: MaterialTapTargetSize.padded,
                  //   backgroundColor: redColor,
                  //   child: const Icon(Icons.add_location, size: 30.0),
                  // ),
                  // SizedBox(
                  //   height: 12,
                  // ),
                  FloatingActionButton(
                    backgroundColor:redColor ,
                    onPressed: () async{
    defaultLocation();},
                    child: const Icon(Icons.location_searching, size: 30.0 ,)),


                  //         FloatingActionButton(
                  // child: Icon(Icons.location_searching,color: Colors.white,),
                  // onPressed: (){
                  //
                  // },)
                ]),
              ),
            ),
            // Align(
            //     alignment: Alignment.center,
            //     // child: !loadingconf?
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
                // child: Icon(
                //   Icons.dot,
                //   size: 20,
                //   color: redColor,
                // ))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: redColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(width: 1, color: yellowColor)),
          elevation: 2,
          label: Text(
            "Confirm Location",
            style: TextStyle(fontSize: 10),
          ),
          onPressed: () {

            Navigator.pop(context,_addresPotion);
          },
        ),
      ),
    );
  }
}
