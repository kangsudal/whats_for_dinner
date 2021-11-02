import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/model/menuState.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:whats_for_dinner/screen/manualScreen.dart';

class ListScreen extends StatefulWidget {
  ListScreen({Key? key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    Box<Recipe> recipeBox = Hive.box('recipeBox');
    List<Recipe> items = recipeBox.values.toList();
    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(items[index].rcpnm!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManualScreen(items[index]),
                ),
              );
            },
          );
        },
        separatorBuilder: separatorBuilder,
        itemCount: items.length,
      ),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            //TODO: 메뉴추가다이얼로그 띄우기
          });
        },
        child: Icon(Icons.add),
      ),

       */
    );
  }

//  Widget itemBuilder(BuildContext context, int index) {
//    return Dismissible(
//      key: ValueKey(index),
//      child: ListTile(
//        title: Text("sample"),
//      ),
//    );
//  }

  Widget separatorBuilder(BuildContext context, int index) {
    return Divider();
  }
}
