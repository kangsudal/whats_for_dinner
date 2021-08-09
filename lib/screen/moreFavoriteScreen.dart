import 'package:flutter/material.dart';

class MoreFavoriteScreen extends StatelessWidget {
  List favoriteFoods;
  MoreFavoriteScreen(this.favoriteFoods);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("제일 자주먹은 음식 리스트"),
      ),
      body: Container(
        child: ListView(
          children: List.generate(
            favoriteFoods.length,
            (index) => ListTile(
              title: Text(favoriteFoods[index].key),
              trailing: Text("${favoriteFoods[index].value.toString()}번 먹음"),
            ),
          ),
        ),
      ),
    );
  }
}
