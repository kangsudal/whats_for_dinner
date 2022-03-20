import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whats_for_dinner/model/eatNote.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:http/http.dart' as http;

/*
json으로 받아온 데이터는 어플리케이션을 껐다 키면 날아간다.
데이터를 persist storage(database)에 저장해놓고 필요할때마다 데이터를 읽어오는 클래스
local storage: hive box
cloud storage: firestore storage 사용 예정
external hard disk storage: ?
 */
class PersistStorage {
  // Box<Recipe>? allRecipeStorage; //recipeBox;
  // Box<EatNote>? ateRecordStorage; //eatNoteBox;

  // List<Recipe>? allRecipes;//이건 꼭필요한지 생각해보자
  // List<EatNote>? ateRecords;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(
        RecipeAdapter()); //이건 왜 필요하지? hive에서 저장할수있는 기본 데이터 타입 이외에 custom Object를 저장하기위해. type 등록
    final Box<Recipe> localStorage = await _allRecipeStorage;
    if (localStorage.isEmpty) {
      await fetchData(localStorage); // JSON -> localStorage에 저장
    }
  }

  //create and open local storage
  Future<Box<Recipe>> get _allRecipeStorage async {
    Box<Recipe> allRecipeStorage = await Hive.openBox<Recipe>(
        'recipeBox'); //old name: recipeBox -> new box name: allRecipeStorage
    return allRecipeStorage;
  }

  //read data from local storage
  //allRecipeStorage 박스에서 모든 Recipe를 얻는 메서드
  Future<List<Recipe>> loadAllRecipes() async {
    try {
      final Box<Recipe> localStorage =
          await _allRecipeStorage; //데이터베이스 reference를 얻음
      final List<Recipe> allRecipes = localStorage.values.toList(); //데이터 읽기

      return allRecipes;
    } catch (e) {
      log("loadAllRecipes()에서 에러가 발생했습니다.");
      //에러가 발생할 경우 비어있는 리스트 반환
      return [];
    }
  }

  Future<int> get allRecipesLength async {
    try {
      final Box<Recipe> localStorage =
          await _allRecipeStorage; //데이터베이스 reference를 얻음
      final List<Recipe> allRecipes = localStorage.values.toList(); //데이터 읽기

      return allRecipes.length;
    } catch (e) {
      log("allRecipesLength()에서 에러가 발생했습니다.");
      return 0;
    }
    return 0;
  }

  Future<Recipe?> loadRecipeAt(int index) async {
    try {
      final Box<Recipe> localStorage =
          await _allRecipeStorage; //데이터베이스 reference를 얻음
      final Recipe? recipe = localStorage.getAt(index); //데이터 읽기

      return recipe;
    } catch (e) {
      log("loadRecipeAt()에서 에러가 발생했습니다.");
      //에러가 발생할 경우 비어있는 리스트 반환
      return null;
    }
  }

  //save data to local storage
  Future<void> insertRecipe(Recipe recipe) async {
    //hive box reference를 얻는다
    final Box<Recipe> localStorage = await _allRecipeStorage;
    await localStorage.add(recipe);
  }

  //update data in local storage
  Future<void> updateRecipe(int index, Recipe updatedRecipe) async {
    final Box<Recipe> localStorage = await _allRecipeStorage;
    try {
      await localStorage.putAt(index, updatedRecipe);
      log("수정된 결과:" + localStorage.getAt(index).toString());
    } catch (e) {
      log("레시피를 수정하는데 에러가 발생했습니다. persisStorage.dart/updateRecipe 메소드");
    }
  }

  //delete data in local storage
  Future<void> deleteRecipe(int index) async {
    final Box<Recipe> localStorage = await _allRecipeStorage;
    try {
      await localStorage.deleteAt(index);
    } catch (e) {
      log("레시피를 삭제하는데 에러가 발생했습니다. persisStorage.dart/deleteRecipe 메소드");
    }
  }

  Future<void> deleteAllRecipe() async {
    final Box<Recipe> localStorage = await _allRecipeStorage;
    try {
      await localStorage.clear();
    } catch (e) {
      log("모든 레시피를 삭제하는데 에러가 발생했습니다. persisStorage.dart/deleteAllRecipe 메소드");
    }
  }
}

Future<void> fetchData(Box<Recipe> recipeBox) async {
  //This will parse data from json to Box
//    fetchDataFromTheInternet();
  fetchDataFromLocal(recipeBox);
}

Future<void> fetchDataFromLocal(Box<Recipe> recipeBox) async {
  //HTTP로 SAMPLE 데이터 말고 JSON 파일을 로컬로 저장하여 모든 레시피를 불러옴
  try {
    String jsonString = await rootBundle.loadString('source/COOKRCP01.json');
    Map<String, dynamic> dataMap = jsonDecode(jsonString);
    Iterable jsonList = dataMap["COOKRCP01"]["row"];
    jsonList = jsonList.map((json) => Recipe.fromJson(json));
    jsonList = jsonList.toList(); //Iterable -> List<Recipe>
//      print(jsonList.runtimeType);
    for (Recipe item in jsonList) recipeBox.add(item);
    print(recipeBox);
  } catch (e) {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(e);
  }
}

void fetchDataFromTheInternet(Box<Recipe> recipeBox) async {
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
//      print(jsonList.runtimeType);
    for (Recipe item in jsonList) recipeBox.add(item);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}
