//import 'dart:convert';

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/model/eatNote.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:whats_for_dinner/screen/homeScreen.dart';
import 'package:http/http.dart' as http;

//
//import 'model/recipe.dart';
final String tableName = 'eatNote_table';
Future main() async {
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(EatNoteAdapter());
  Hive.registerAdapter(RecipeAdapter());
  await Hive.openBox<EatNote>('eatNoteBox');
  Box<Recipe> recipeBox = await Hive.openBox<Recipe>('recipeBox');
  if (recipeBox.isEmpty) {
    fetchData(recipeBox); // JSON -> recipeBox 저장
  } else {
//    print("=========Box에 저장된 값:==========");
//    var list = recipeBox.values;
//    for (Recipe item in list){
//      print(item.rcpnm);
//    }
  }
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

void fetchData(Box<Recipe> recipeBox) async {
  //This will parse data from json to Box
  fetchDataFromLocal(recipeBox);
}

//from_http_to_file.dart를 실행시켜 COOKRCP01.json을 만들고, source/에 COOKRCP01.json을 복사하였음
Future<void> fetchDataFromLocal(Box<Recipe> recipeBox) async {
  //로컬 파일 COOKRCP01.json으로부터 모든 레시피를 불러옴
  try {
    //COOKRCP01.json 파일을 읽어와 List<Recipe>로 변환시킨다.
    String jsonString = await rootBundle.loadString('source/COOKRCP01.json');
    Map<String, dynamic> dataMap = jsonDecode(jsonString);
    List<dynamic> dataList = dataMap["COOKRCP01"]["row"];
    List<Recipe> recipes =
        dataList.map((json) => Recipe.fromJson(json)).toList();

    //List<Recipe>데이터를 데이터베이스(Hive Box)에 추가한다
    for (Recipe recipe in recipes) {
      recipeBox.add(recipe);
    }
  } catch (e) {
    // source/COOKRCP01.json을 읽어오지못하면
    throw Exception(e);
  }
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    fetchAlbum();
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.grey,
          // selectionColor: Colors.grey,
          selectionHandleColor: Colors.grey,
        ),
      ),
      home: HomeScreen(),
      navigatorKey: navigatorKey,
    );
  }
}
