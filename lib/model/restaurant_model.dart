import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Restaurant {
  String name;
  String address;
  String thumbnail;
  LatLng locationCoords;
  String place_id;

  /*
  Restaurant({
    required this.name,
    required this.address,
    required this.thumbnail,
    required this.locationCoords,
  });

  final List<Restaurant> restaurants = [
    Restaurant( name: '어쩌고', address: '어쩌고', thumbnail: 'https://저쩌고', locationCoords: LatLng(37,127),),
    Restaurant( name: '어쩌고', address: '어쩌고', thumbnail: 'https://저쩌고', locationCoords: LatLng(37,127),),
    Restaurant( name: '어쩌고', address: '어쩌고', thumbnail: 'https://저쩌고', locationCoords: LatLng(37,127),),
  ];
   */

  //Named constructor, JSON으로부터 데이터를 받아온다.
  Restaurant.fromJson({required Map<String, dynamic> json})
      : name = json['name'],
        address = json['formatted_address'],
        thumbnail = parseThumbnail(
            json['photos'][0]['photo_reference']), //첫번째 사진을 썸네일로 받아온다
        locationCoords = LatLng(json['geometry']['location']['lat'],
            json['geometry']['location']['lng']),
        place_id = json['place_id'];

  static String parseThumbnail(String reference) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$reference&key=${dotenv.env['googleMapsAPIKey']}";
  }
}
