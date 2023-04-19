import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class Homecontroller extends GetxController
{
  RxDouble lat = 0.0.obs;
  RxDouble lon = 0.0.obs;
  RxList<Placemark> placemark = <Placemark>[].obs;
}