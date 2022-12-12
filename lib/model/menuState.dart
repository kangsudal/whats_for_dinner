import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shake/shake.dart';
import 'package:whats_for_dinner/model/persistStorage.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final menuProvider =
    StateNotifierProvider<MenuNotifier, Recipe?>((ref) => MenuNotifier());

class MenuNotifier extends StateNotifier<Recipe?> {
  MenuNotifier() : super(null);
  void shuffle() {
    Box<Recipe> recipeBox = Hive.box('recipeBox');
    int _maxIdx = recipeBox.length;
    print("_maxIdx: $_maxIdx, ");
    if (_maxIdx != 0) {
      int _randomIdx = Random().nextInt(_maxIdx);
      print("_randomIdx: $_randomIdx, ");
      state = recipeBox.getAt(_randomIdx);
    } else if (_maxIdx == 0) {
      state = null;
    }
  }
}