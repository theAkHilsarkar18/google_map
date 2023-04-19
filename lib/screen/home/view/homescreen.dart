import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_map/screen/home/controller/homecontroller.dart';
import 'package:google_map/screen/home/view/mapscreen.dart';
import 'package:permission_handler/permission_handler.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    Homecontroller homecontroller = Get.put(Homecontroller());

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      var status = await Permission.location.status;
                      if (await status.isDenied) {
                        status = await Permission.location.request();
                      } else if (status.isGranted) {
                        Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high);
                        homecontroller.lat.value = position.latitude;
                        homecontroller.lon.value = position.longitude;
                      }
                    },
                    child: Text("Permission")),
                Obx(() => Text("lat - ${homecontroller.lat}")),
                Obx(() => Text("lon - ${homecontroller.lon}")),
                ElevatedButton(
                    onPressed: () async {
                      List<Placemark> placemark =
                          await placemarkFromCoordinates(
                              homecontroller.lat.value,
                              homecontroller.lon.value);
                      print("${placemark[0]}");
                      homecontroller.placemarkList.value = placemark;
                    },
                    child: Text("Address")),
                Obx(
                  () => homecontroller.placemarkList.isEmpty
                      ? CircularProgressIndicator()
                      : Text(
                          "adress------${homecontroller.placemarkList[0]}",
                        ),
                ),
                ElevatedButton(onPressed: () => Get.to(Mapscreen()), child: Text("next"),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
