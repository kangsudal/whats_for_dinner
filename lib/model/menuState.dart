import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shake/shake.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MenuState extends ChangeNotifier {
  Recipe? _randomRecipe;
  Recipe? get randomRecipe => _randomRecipe;
  int randomIdx = -1;

  MenuState() {
    Box<Recipe> recipeBox = Hive.box('recipeBox');
    List<Recipe> _items=recipeBox.values.toList();
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
}
