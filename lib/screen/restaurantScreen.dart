import 'package:flutter/material.dart';
import 'package:whats_for_dinner/model/recipe.dart';

class RestaurantScreen extends StatelessWidget {
  final Recipe recipe;
  const RestaurantScreen(this.recipe, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String keyword = recipe.rcpnm!;
    return Scaffold(
      appBar: AppBar(
        title: Text('식당찾기'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: keyword,
                ),
              ),
              TextButton(onPressed: () {}, child: Text('검색')),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: '${recipe.rcppartsdtls!.split(",")[0]} ${recipe.rcppartsdtls!.split(",")[1]}',
                ),
              ),
              TextButton(onPressed: () {}, child: Text('검색')),
            ],
          ),
        ],
      ),
    );
  }
}
