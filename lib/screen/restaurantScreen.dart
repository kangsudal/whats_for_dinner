import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:whats_for_dinner/model/recipe.dart';

class RestaurantScreen extends StatefulWidget {
  final Recipe recipe;
  const RestaurantScreen(this.recipe, {Key? key}) : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  static final currentLatLng = LatLng(37.602055440487284, 127.06435651945264);
  static final CameraPosition initialPosition = CameraPosition(
    target: currentLatLng,
    zoom: 15,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('식당찾기'),
      ),
      body: Column(
        children: [
          SearchField(
            recipe: widget.recipe,
          ),
          CustomGoogleMap(
            initialPosition: initialPosition,
          ),
          RestaurantList(),
        ],
      ),
    );
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
  final CameraPosition initialPosition;
  const CustomGoogleMap({
    Key? key,
    required this.initialPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: GoogleMap(
        initialCameraPosition: initialPosition,
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
