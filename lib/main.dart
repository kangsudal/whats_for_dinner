//import 'dart:convert';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/model/eatNote.dart';
import 'package:whats_for_dinner/model/menuState.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:whats_for_dinner/screen/homeScreen.dart';
import 'package:http/http.dart' as http;
//
//import 'model/recipe.dart';
final String tableName = 'eatNote_table';
void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(EatNoteAdapter());
  Hive.registerAdapter(RecipeAdapter());
  await Hive.openBox<EatNote>('eatNoteBox');
  Box<Recipe> recipeBox = await Hive.openBox<Recipe>('recipeBox');
  if(recipeBox.isEmpty){
    fetchData(recipeBox); // JSON -> recipeBox 저장
  }
  else{
    print("=========Box에 저장된 값:==========");
    var list = recipeBox.values;
    for (Recipe item in list){
      print(item.rcpnm);
    }
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => MenuState(),
      child: MyApp(),
    ),
  );
}

void fetchData(Box<Recipe> recipeBox) async{
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
  } catch(e) {
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


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    fetchAlbum();
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
