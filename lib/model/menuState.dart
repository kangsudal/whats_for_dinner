import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MenuState extends ChangeNotifier {
  List<Recipe> _items = [];
  List<Recipe> get items => _items;
  String _randomText = "흔들어주세요!";
  String get randomText => _randomText;

  MenuState() {
//    print("MenuState생성");
    fetchData();
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      if (_items.isNotEmpty) {
        int randomIdx = Random().nextInt(_items.length);
//        print("randomIdx:$randomIdx");
//        print("_items[randomIdx].rcpnm:${_items[randomIdx].rcpnm}");
        _randomText = _items[randomIdx].rcpnm!;
        notifyListeners();
      }
    });
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://openapi.foodsafetykorea.go.kr/api/sample/COOKRCP01/json/1/5'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonList = jsonDecode(response.body)["COOKRCP01"]["row"];
//      print(jsonList.map((json) => Recipe.fromJson(json)).toList()[0].rcpnm);
      jsonList = jsonList
          .map((json) => Recipe.fromJson(json))
          .toList(); //dynamic -> List<Recipe>
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
