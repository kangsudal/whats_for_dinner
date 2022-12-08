import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:whats_for_dinner/model/recipe.dart';

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

class CustomGoogleMap extends StatelessWidget {
  const CustomGoogleMap({
    Key? key,
  }) : super(key: key);

  Future<LatLng> getLatLng() async {
    final _locationData = await Geolocator.getCurrentPosition();
    return LatLng(_locationData.latitude, _locationData.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: FutureBuilder<LatLng>(
        future: getLatLng(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            final locationModel = snapshot.data!;
            final latitude = locationModel.latitude;
            final longitude = locationModel.longitude;

            return GoogleMap(
              onCameraMove: (CameraPosition cameraPosition) {
                print(cameraPosition.zoom);
              },
              initialCameraPosition:
                  CameraPosition(target: locationModel, zoom: 15.0),
              myLocationEnabled: true, //현위치 표시
            );
          }
          return Center(
            child: Text('현위치의 지도를 불러오지 못했습니다.'),
          );
        },
      ),
    );
  }
}

class RestaurantList extends StatelessWidget {
  const RestaurantList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        child: Text('리스트 1,2,3'),
      ),
    );
  }
}
