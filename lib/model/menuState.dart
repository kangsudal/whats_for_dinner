import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shake/shake.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MenuState extends ChangeNotifier {
  List<Recipe> _items = [];
  List<Recipe> get items => _items;
//  String _randomText = "흔들어주세요!";
//  String get randomText => _randomText;
  Recipe _randomRecipe=Recipe();
  Recipe get randomRecipe => _randomRecipe;
  int randomIdx = -1;

  MenuState() {
//    print("MenuState생성");
    fetchData();
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      if (_items.isNotEmpty) {
        randomIdx = Random().nextInt(_items.length);
//        print("randomIdx:$randomIdx");
//        print("_items[randomIdx].rcpnm:${_items[randomIdx].rcpnm}");
        _randomRecipe = _items[randomIdx];
        notifyListeners();
      }
    });
  }

  Future<void> fetchData() async {
//    fetchDataFromTheInternet();
    fetchDataFromLocal();
  }

  Future<void> fetchDataFromLocal() async {
    //HTTP로 SAMPLE 데이터 말고 JSON 파일을 로컬로 저장하여 모든 레시피를 불러옴
    try {
      String jsonString = await rootBundle.loadString('source/COOKRCP01.json');
      Map<String, dynamic> dataMap = jsonDecode(jsonString);
      Iterable jsonList = dataMap["COOKRCP01"]["row"];
      jsonList = jsonList.map((json) => Recipe.fromJson(json));
      jsonList = jsonList.toList(); //Iterable -> List<Recipe>
      print(jsonList.runtimeType);
      for (Recipe item in jsonList) _items.add(item);
    } catch(e) {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(e);
    }
  }

  Future<void> fetchDataFromTheInternet() async {
    //api를 통해 json 파일을 읽는다
    final response = await http.get(Uri.parse(
        'https://openapi.foodsafetykorea.go.kr/api/sample/COOKRCP01/json/1/5')); //sample에 apiKey 넣어줘야한다. 데이터는 1318개정도있고, 한번에 1000개만 불러올수있다. call제한회수 1000회/1일

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      String jsonString = response.body;
      Map<String, dynamic> dataMap = jsonDecode(jsonString);
      Iterable jsonList = dataMap["COOKRCP01"]["row"];
//      print(jsonList.map((json) => Recipe.fromJson(json)).toList()[0].rcpnm);
      //json 데이터를 변수(List<Recipe> 객체)에 저장
      jsonList = jsonList.map((json) => Recipe.fromJson(json));
      jsonList = jsonList.toList(); //Iterable -> List<Recipe>
      print(jsonList.runtimeType);
      for (Recipe item in jsonList) _items.add(item);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  void add(Recipe item) {
    _items.add(item);
    notifyListeners();
  }
}
