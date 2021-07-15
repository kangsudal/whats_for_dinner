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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<MenuState>(
        builder: (context, menuState, _) {
          return ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: ValueKey(index),
                child: ListTile(
                  title: Text(menuState.items[index].rcpnm!),
                ),
              );
            },
            separatorBuilder: separatorBuilder,
            itemCount: menuState.items.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            //TODO: 메뉴추가다이얼로그 띄우기
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
