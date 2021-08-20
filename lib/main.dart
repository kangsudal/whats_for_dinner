//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/model/eatNote.dart';
import 'package:whats_for_dinner/model/menuState.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:whats_for_dinner/screen/homeScreen.dart';
//import 'package:http/http.dart' as http;
//
//import 'model/recipe.dart';
final String tableName = 'eatNote_table';
void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(EatNoteAdapter());
  Hive.registerAdapter(RecipeAdapter());
  await Hive.openBox<EatNote>('eatNoteBox');
  Box recipeBox = await Hive.openBox<Recipe>('recipeBox');
  if(recipeBox.isEmpty){
    fetchData(); // JSON -> recipeBox 저장
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => MenuState(),
      child: MyApp(),
    ),
  );
}

void fetchData() {
  print("This will parse data from json to Box");
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
