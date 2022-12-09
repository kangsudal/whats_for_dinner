import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:whats_for_dinner/model/restaurant_model.dart';

class RestaurantScreen extends StatefulWidget {
  final Recipe recipe;
  const RestaurantScreen(this.recipe, {Key? key}) : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('식당찾기'),
      ),
      body: FutureBuilder(
        future: checkPermission(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == '위치 권한이 허가되었습니다.') {
            return Column(
              children: [
                SearchField(
                  recipe: widget.recipe,
                ),
                CustomGoogleMap(),
                RestaurantList(),
              ],
            );
          }

          //위치 권한이 허가되었습니다. 이외이면 그 메세지를 띄운다.
          return Center(
            child: Text(snapshot.data),
          );
        },
      ),
    );
  }

  Future<String> checkPermission() async {
    //권한설정
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return 'GPS를 켜주세요';
    }
    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator
          .requestPermission(); //유저에게 요청하는 다이얼로그를 띄우고, 유저가 누른 체크퍼미션이 변수에 다시 저장된다.
      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요.';
      }
    }
    if (checkedPermission == LocationPermission.denied) {
      //거절
      return '앱의 위치 권한을 세팅에서 허가해주세요.';
    }
    //위에 아무것도 안걸리고 모든게 통과되면
    return '위치 권한이 허가되었습니다.';
  }
}

class SearchField extends StatelessWidget {
  final Recipe recipe;
  const SearchField({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String keyword = recipe.rcpnm!;
    String hashTag = recipe.hashtag!;
    String ingredient1;
    String ingredient2;
    List<String> rcppartsdtls = recipe.rcppartsdtls!.split('\n');
    if (rcppartsdtls[0].contains(',')) {
      ingredient1 = rcppartsdtls[0].split(',')[0];
      ingredient2 = rcppartsdtls[0].split(',')[1];
    } else {
      ingredient1 = rcppartsdtls[0];
      ingredient2 = rcppartsdtls[1].split(',')[0];
    }

    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: keyword,
                ),
              ),
              TextButton(onPressed: () {}, child: Text('검색')),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue:
                      hashTag == "" ? '$ingredient1 $ingredient2' : hashTag,
                ),
              ),
              TextButton(onPressed: () {}, child: Text('검색')),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  GoogleMapController? _controller;

  List<Marker> allMarkers = [];

  Future<LatLng> getCenterLatLng() async {
    final _locationData = await Geolocator.getCurrentPosition();
    return LatLng(_locationData.latitude, _locationData.longitude);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<LatLng> fetchData() async {
    //https://developers.google.com/maps/documentation/places/web-service/search-text 텍스트검색
    LatLng currentLatLng = await getCenterLatLng();

    var url =
        Uri.https('maps.googleapis.com', 'maps/api/place/textsearch/json', {
      'key': dotenv.env['googleMapsAPIKey'],
      'query': '마제소바',
      'location': '${currentLatLng.latitude},${currentLatLng.longitude}',
    });
    final response = await http.get(url);
    String body = response.body;
    final decodedResponse = jsonDecode(body);

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
    print("==========================================$allMarkers");
    return currentLatLng;
  }

  @override
  Widget build(BuildContext context) {
    print('=======================================here too?: $allMarkers');
    return Expanded(
      child: FutureBuilder<LatLng>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: snapshot.data!,
                  zoom: 12,
                ),
                onMapCreated: mapCreated,
                markers: Set.from(allMarkers),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
}

class RestaurantList extends StatelessWidget {
  const RestaurantList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ListView.separated(
        itemBuilder: (context, idx) {
          return ListTile(
            title: Text('가게명'),
            subtitle: Text('주소'),
          );
        },
        itemCount: 5,
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }
}
