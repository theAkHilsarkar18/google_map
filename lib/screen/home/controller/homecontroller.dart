import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class Homecontroller extends GetxController
{
  RxDouble lat = 0.0.obs;
  RxDouble lon = 0.0.obs;
  RxList<Placemark> placemarkList = <Placemark>[].obs;
  RxInt currentBottomNavigationBarIndex = 1.obs;
  RxBool isClick = false.obs;
  RxBool isClickForGo = false.obs;

List<Icon> iconList = [
  Icon(Icons.hotel,color: Colors.grey.shade700,size: 30),
  Icon(Icons.dining,color: Colors.grey.shade700,size: 30),
  Icon(Icons.local_cafe,color: Colors.grey.shade700,size: 30),
  Icon(Icons.yard,color: Colors.grey.shade700,size: 30),
  Icon(Icons.school,color: Colors.grey.shade700,size: 30),
  Icon(Icons.temple_hindu,color: Colors.grey.shade700,size: 30),
];

List nameList = [
  "Hotel",
  "Restaurant",
  "Cafe",
  "Garden",
  "School",
  "Temple",
];


  void changeBottomNavigationBarIndex(int value)
  {
    currentBottomNavigationBarIndex.value = value;
  }
}