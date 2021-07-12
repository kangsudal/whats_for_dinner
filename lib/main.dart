import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whats_for_dinner/screen/homeScreen.dart';
import 'package:http/http.dart' as http;

import 'model/food.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    fetchAlbum();
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

void fetchAlbum() async {
  final response =
  await http.get(Uri.parse('http://openapi.foodsafetykorea.go.kr/api/sample/COOKRCP01/json/1/5'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var jsonList = jsonDecode(response.body)["COOKRCP01"]["row"];
    print(jsonList.map((json)=>Food.fromJson(json)).toList()[0].runtimeType);
    print(jsonList.map((json)=>Food.fromJson(json)).toList()[0].rcpnm);
//    return Food.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}