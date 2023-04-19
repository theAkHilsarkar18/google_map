import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_map/screen/home/controller/homecontroller.dart';
import 'package:google_map/screen/home/view/homescreen.dart';
import 'package:google_map/screen/home/view/mapscreen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (p0) => Spleshscreen(),
        'map': (p0) => Mapscreen(),
      },
    ),
  );
}

class Spleshscreen extends StatefulWidget {
  const Spleshscreen({Key? key}) : super(key: key);

  @override
  State<Spleshscreen> createState() => _SpleshscreenState();
}

class _SpleshscreenState extends State<Spleshscreen> {
  @override
  Widget build(BuildContext context) {
    Homecontroller homecontroller = Get.put(Homecontroller());
    Timer(Duration(seconds: 5), () async {
      var status = await Permission.location.status;
      if (await status.isDenied) {
        status = await Permission.location.request();
      } else if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        homecontroller.lat.value = position.latitude;
        homecontroller.lon.value = position.longitude;
        Get.to(Mapscreen());
      }
    });

    return SafeArea(
      child: Scaffold(
        body: Center(child: Column(
          children: [
            Spacer(),
            Image.asset("assets/img/map.png",height: 100,),
            Spacer(),
            Image.asset("assets/img/gm.png",height: 100,),
          ],
        )),
      ),
    );
  }
}
