import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_map/screen/home/controller/homecontroller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class Mapscreen extends StatefulWidget {
  const Mapscreen({Key? key}) : super(key: key);

  @override
  State<Mapscreen> createState() => _MapscreenState();
}

class _MapscreenState extends State<Mapscreen> {
  //------------------------------------------------------------------------------------------
  Homecontroller homecontroller = Get.put(Homecontroller());

  @override
  void initState() {
    // TODO: implement initState
    welcomeMethod();
    print(
        "${homecontroller.lon.value}--------------------------------------------");
    super.initState();
  }

  //------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    int t1 = TimeOfDay.now().hour;
    Homecontroller homecontroller = Get.put(Homecontroller());
    Completer<GoogleMapController> completer = Completer<GoogleMapController>();
    GoogleMapController _controller;

    // for night and day view of google map
    Future<void> onMapCreated(GoogleMapController controller) async {
      _controller = controller;
      String value = await DefaultAssetBundle.of(context).loadString(
          t1 > 6 && t1 < 17
              ? "assets/img/style.json"
              : "assets/img/night.json");
      _controller.setMapStyle(value);
    }

    // for animated zoom on my location click
    CameraPosition zoomLocation = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(homecontroller.lat.value, homecontroller.lon.value),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414,
    );

    Future<void> goToTheLocation() async {
      final GoogleMapController controller = await completer.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(zoomLocation));
    }

    //for bacak to the location
    CameraPosition backLocation = CameraPosition(
      target: LatLng(homecontroller.lat.value, homecontroller.lon.value),
      zoom: 14.4746,
    );
    Future<void> backToTheLocation() async {
      final GoogleMapController controller = await completer.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(backLocation));
    }

    // marker in the map

    Set<Marker> _createMarker() {
      return {
        Marker(
            markerId: MarkerId("marker_1"),
            position:
                LatLng(homecontroller.lat.value, homecontroller.lon.value),
            infoWindow: InfoWindow(title: 'Marker 1'),
            ),
        Marker(
          markerId: MarkerId("marker_2"),
          position: LatLng(18.997962200185533, 72.8379758747611),
        ),
      };
    }

    GoogleMapController? googleMapController;
    print(
        "${homecontroller.lon.value}--------------------------------------------");
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: homecontroller.currentBottomNavigationBarIndex.value,
            selectedItemColor: Colors.blue.shade700,
            onTap: (value) {
              homecontroller.changeBottomNavigationBarIndex(value);
            },
            items: [
              BottomNavigationBarItem(
                  icon: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            enableDrag: true,
                            context: context,
                            shape: RoundedRectangleBorder(
                              // <-- SEE HERE
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ),
                            builder: (context) {
                              return SizedBox(
                                height: 260,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(
                                            Icons.home_work_outlined,
                                            color: Colors.blue.shade500,
                                            size: 25,
                                          ),
                                          Icon(
                                            Icons.location_pin,
                                            color: Colors.grey.shade500,
                                            size: 25,
                                          ),
                                          Icon(
                                            Icons.bookmark_border_rounded,
                                            color: Colors.grey.shade500,
                                            size: 25,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                        color: Colors.grey.shade300,
                                        thickness: 5),
                                    Container(
                                      height: 140,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) =>
                                            Container(
                                          margin: EdgeInsetsDirectional.all(10),
                                          height: 120,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadiusDirectional.circular(20),
                                            color: Colors.grey.shade100,
                                          ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  homecontroller.iconList[index],
                                                  SizedBox(height:10,),
                                                  Text("${homecontroller.nameList[index]}",style: TextStyle(color: Colors.grey.shade700 ,fontSize: 12,fontWeight: FontWeight.w500),),
                                                ],
                                              ),
                                        ),
                                        itemCount: homecontroller.nameList.length,
                                      ),
                                    ),
                                    Divider(
                                        color: Colors.grey.shade300,
                                        thickness: 5),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Icon(Icons.home_work_outlined)),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.location_pin), label: "Location"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_border_outlined), label: "Save"),
            ],
          ),
        ),
        body: Stack(
          children: [
            Obx(
              () => GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  completer.complete(controller);
                  onMapCreated(controller);
                },
                markers: _createMarker(),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: homecontroller.isClick.isTrue
                    ? MapType.satellite
                    : MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      homecontroller.lat.value, homecontroller.lon.value),
                  zoom: 14.4746,
                  //  bearing: 192.8334901395799,
                  //  tilt: 59.440717697143555,
                  //  zoom: 19.151926040649414,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(4),
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.circular(30),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/img/p1.jpeg"),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.search, color: Colors.grey, size: 20),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Search here",
                    style: TextStyle(
                        color: Colors.grey, letterSpacing: 1, fontSize: 14),
                  ),
                  Spacer(),
                  Icon(Icons.mic, color: Colors.grey),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 500,
                // color: Colors.grey,
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(onTap: () {
                      openAppSettings();
                    },child: Icon(Icons.settings,color: t1 > 6 && t1 < 17 ? Colors.blue : Colors.white, size: 35,)),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        homecontroller.isClick.value =
                            !homecontroller.isClick.value;
                      },
                      child: Obx(
                        () => Column(
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(10),
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(10),
                                  child: Image.asset(
                                      homecontroller.isClick.isFalse
                                          ? "assets/img/def.jpg"
                                          : "assets/img/set.jpg",
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                homecontroller.isClick.isFalse
                                    ? "Default"
                                    : "Satellite",
                                style: TextStyle(
                                    color: t1 > 6 && t1 < 17
                                        ? Colors.blue
                                        : Colors.white,
                                    fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      // onTap: () {
                      //   homecontroller.isClickForGo.value = !homecontroller.isClickForGo.value;
                      //   goToTheLocation();
                      // },
                      onTap: () {
                        homecontroller.isClickForGo.value =
                            !homecontroller.isClickForGo.value;
                        homecontroller.isClickForGo.isFalse
                            ? backToTheLocation()
                            : goToTheLocation();
                      },
                      child: Icon(
                        Icons.my_location,
                        color: t1 > 6 && t1 < 17 ? Colors.blue : Colors.white,
                        size: 35,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> welcomeMethod() async {
    var status = await Permission.location.status;
    if (await status.isDenied) {
      status = await Permission.location.request();
    } else if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      homecontroller.lat.value = position.latitude;
      homecontroller.lon.value = position.longitude;
    }
  }
}

//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MapSample extends StatefulWidget {
//   const MapSample({Key? key}) : super(key: key);
//
//   @override
//   State<MapSample> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<MapSample> {
//   final Completer<GoogleMapController> _controller =
//   Completer<GoogleMapController>();
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   static const CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: const Text('To the lake!'),
//         icon: const Icon(Icons.directions_boat),
//       ),
//     );
//   }
//
//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }
