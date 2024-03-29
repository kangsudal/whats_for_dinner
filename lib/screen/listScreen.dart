import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/model/menuProvider.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:whats_for_dinner/screen/manualScreen.dart';

class ListScreen extends StatefulWidget {
  ListScreen({Key? key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  TextEditingController _controller = TextEditingController();

  Box<Recipe> recipeBox = Hive.box('recipeBox');
  List<Recipe> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            //이부분을 해줘야 검색할 부분이 잘보인다
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: IconButton(
                  color: Colors.black12,
                  icon: Icon(Icons.search),
                  onPressed: () {
                    print("search button is clicked");
                  },
                ),
                suffix: IconButton(
                  color: Colors.black12,
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    print("clear button is clicked");
                    _controller.clear();
                  },
                ),
              ),
            ),
          ),
        ), //Text("모든 음식 리스트",),
        // actions: [IconButton(icon: Icon(Icons.search), onPressed: (){})],
      ),
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

  @override
  void initState() {
    super.initState();

    //처음켰을때 리스트뷰 초기 데이터
    items = recipeBox.values.toList();

    //앱바 입력받은 값으로 검색
    _controller.addListener(() {
      print(_controller.text);
      String searchWords = _controller.text;
      // Box<Recipe> itemBox = Hive.box('recipeBox');
      List<Recipe> results = searchWords.isEmpty
          ? recipeBox.values.toList() // whole list
          : recipeBox.values
              .where((recipe) => recipe.rcpnm!.contains(searchWords))
              .toList();
      if (searchWords.isNotEmpty) {
        for (Recipe recipe in results) {
          log(recipe.rcpnm.toString());
        }
      }
      setState(() {
        items = results; //검색결과 데이터 리스트뷰에 반영
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
