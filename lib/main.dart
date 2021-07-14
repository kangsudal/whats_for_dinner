//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/model/menuState.dart';
import 'package:whats_for_dinner/screen/homeScreen.dart';
//import 'package:http/http.dart' as http;
//
//import 'model/recipe.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MenuState(),
      child: MyApp(),
    ),
  );
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
