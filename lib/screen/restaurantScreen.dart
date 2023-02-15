import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rive/rive.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:whats_for_dinner/model/restaurant_model.dart';
import 'package:whats_for_dinner/model/restaurant_provider.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  final Recipe recipe;
  const RestaurantScreen(this.recipe, {Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('식당찾기'),
        backgroundColor: Colors.black,
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
                CustomGoogleMap(
                  rcpnm: widget.recipe.rcpnm!,
                ),
                // RestaurantList(),
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
    ref.read(searchTextProvider.notifier).update((state) => widget
        .recipe.rcpnm!); //이 위치에 넣어줘야한다 중요 ★★★★★★ FutureBuilder가 위젯트리를 생성하기 전에!
    return '위치 권한이 허가되었습니다.';
  }
}

class SearchField extends ConsumerStatefulWidget {
  final Recipe recipe;

  SearchField({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  ConsumerState<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  late TextEditingController controller1;
  late TextEditingController controller2;

  @override
  void initState() {
    super.initState();
    String keyword = widget.recipe.rcpnm!;
    String hashTag = widget.recipe.hashtag!;
    String ingredient1;
    String ingredient2;
    List<String> rcppartsdtls = widget.recipe.rcppartsdtls!.split('\n');
    if (rcppartsdtls[0].contains(',')) {
      //"재료 가다랑어포(5g), 오이(5g), 깻잎(1g)\n육수 무(50g), 다시마(1g), 대파(10g), 물(500g)\n => ingredient1: 재료 가다랑어포, ingredient2: 오이
      ingredient1 = rcppartsdtls[0].split(',')[0];
      ingredient2 = rcppartsdtls[0].split(',')[1];
    } else {
      //"고추장전\n옥수수콘 50g(2큰술), 당근 5g(1/20개), 표고버섯 5g(1개)" => ingredient1: 고추장전, ingredient2: 옥수수콘
      ingredient1 = rcppartsdtls[0];
      ingredient2 = rcppartsdtls[1].split(',')[0];
    }
    hashTag = (hashTag == "")
        ? '$ingredient1 $ingredient2'
        : hashTag; //hashTag가 비어있으면 재료를 대신 넣는다.
    controller1 = TextEditingController(text: keyword);
    controller2 = TextEditingController(text: hashTag);
  }

  void submitData(String text) {
    ref.read(searchTextProvider.notifier).update((state) => text);
    print('=======UPDATED textfield: $text=======');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            autofocus: true,
            controller: controller1,
            onSubmitted: submitData,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            onPressed: () {
              submitData(controller1.text);
            },
            child: Text('검색'),
          ),
        ),
      ],
    );
  }
}

class CustomGoogleMap extends ConsumerStatefulWidget {
  final String rcpnm;
  CustomGoogleMap({
    required this.rcpnm,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends ConsumerState<CustomGoogleMap> {
  TextEditingController textEditingController = TextEditingController();
  GoogleMapController? _controller;
  late RiveAnimationController indicatorController;

  @override
  void initState() {
    super.initState();
    indicatorController = SimpleAnimation('active');
  }

  @override
  Widget build(BuildContext context) {
    final googleMapDataFuture = ref.watch(googleMapDataFutureProvider);
    return googleMapDataFuture.when(
      data: (data) {
        if (data!.markers.length == 0) {
          return Expanded(
            child: Center(
              child: Text('마땅한 식당이 없습니다. ㅠㅠ 검색어를 수정해서 찾아보실래요?'),
            ),
          );
        }
        return Expanded(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: data!.currentPosition,
              zoom: 12,
            ),
            // onMapCreated: mapCreated,
            markers: Set.from(data!.markers),
            myLocationEnabled: true,
          ),
        );
      },
      error: (error, stack) {
        return Expanded(
          child: Center(
            child: Text('마땅한 식당이 없습니다. ㅠㅠ 검색어를 수정해서 찾아보실래요?'),
          ),
        );
        return Expanded(
          child: Center(
            child: Text(error.toString()),
          ),
        );
      },
      loading: () => Expanded(
        child: Center(
          child: SizedBox(
            width: 500,
            height: 500,
            child: RiveAnimation.asset(
              'assets/riv/map_indicator.riv',
              controllers: [indicatorController],
              animations: [
                'idle',
                'active',
              ],
            ),
          ),
        ),
      ),
    );
  }
}
