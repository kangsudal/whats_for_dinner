import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/model/menuState.dart';
import 'package:whats_for_dinner/model/recipe.dart';

class ListScreen extends StatefulWidget {
  ListScreen({Key? key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  int itemCount = 0;
  List<Recipe> recipes = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<MenuState>(
        builder: (context, menuState, _) {
          recipes = menuState.items;
          itemCount = menuState.items.length;
          return ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: ValueKey(index),
                child: ListTile(
                  title: Text(recipes[index].rcpnm!),
                ),
              );
            },
            separatorBuilder: separatorBuilder,
            itemCount: itemCount,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            itemCount++;
          });
        },
        child: Icon(Icons.add),
      ),
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
