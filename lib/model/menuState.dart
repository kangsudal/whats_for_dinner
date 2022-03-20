import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shake/shake.dart';
import 'package:whats_for_dinner/model/persistStorage.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MenuState extends ChangeNotifier {
  Recipe? randomRecipe;

  MenuState() {
    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        shuffle();
      },
    );
  }

  Future<void> shuffle() async {
    PersistStorage persistStorage = PersistStorage();
    int _maxIdx = await persistStorage.allRecipesLength;
    print("_maxIdx: $_maxIdx, ");
    if (_maxIdx != 0) {
      int _randomIdx = Random().nextInt(_maxIdx);
      print("_randomIdx: $_randomIdx, ");
      randomRecipe = await persistStorage.loadRecipeAt(_randomIdx);
    }else if(_maxIdx ==0){
      randomRecipe = null;
    }
    notifyListeners();
  }
}
