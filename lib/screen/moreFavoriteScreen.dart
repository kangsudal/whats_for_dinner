import 'package:flutter/material.dart';
import 'package:whats_for_dinner/screen/manualScreen.dart';

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
              onTap: (){
                //TODO: favoriteFoods 데이터 받아올때, ManualScreen 매개변수로 넘겨줄 수있는 Recipe 객체로 데이터 바꿔서 받아오기
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => ManualScreen(items[index]),
//                  ),
//                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
