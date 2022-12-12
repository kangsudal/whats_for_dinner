import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:whats_for_dinner/model/restaurant_model.dart';

final searchTextProvider = StateProvider<String>((ref) => '');

class MyData {
  List<Marker> markers;
  LatLng currentPosition;

  MyData({required this.markers, required this.currentPosition});
}

Future<MyData> fetchData(String keyword) async {
  //https://developers.google.com/maps/documentation/places/web-service/search-text 텍스트검색
  // LatLng currentLatLng = await getCenterLatLng();
  final _locationData = await Geolocator.getCurrentPosition();
  LatLng currentLatLng =
      LatLng(_locationData.latitude, _locationData.longitude);

  List<Marker> allMarkers = [];
  var url = Uri.https('maps.googleapis.com', 'maps/api/place/textsearch/json', {
    'key': dotenv.env['googleMapsAPIKey'],
    'query': keyword,//'마제소바',//widget.rcpnm, //'마제소바',
    'location': '${_locationData.latitude},${_locationData.longitude}',
    'language': 'kr',
  });
  print(url);
  final response = await http.get(url);
  String body = response.body;
  final decodedResponse = jsonDecode(body);
  try {
    List<Restaurant> restaurants = decodedResponse['results']
        .map<Restaurant>((item) => Restaurant.fromJson(json: item))
        .toList();
    restaurants.forEach((element) {
      allMarkers.add(
        Marker(
          markerId: MarkerId(element.place_id),
          draggable: false,
          infoWindow: InfoWindow(
            title: element.name,
            snippet: element.address,
          ),
          position: element.locationCoords,
        ),
      );
    });
  } catch (e) {
    print(e);
  }
  return MyData(markers: allMarkers, currentPosition: currentLatLng);
}

final googleMapDataFutureProvider = FutureProvider<MyData>((ref) async {
  final keyword = ref.watch(searchTextProvider);
  return await fetchData(keyword);
});
