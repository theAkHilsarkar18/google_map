import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/screen/home/view/homescreen.dart';

void main()
{
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/' :(p0) => Homescreen(),
      },
    ),
  );
}