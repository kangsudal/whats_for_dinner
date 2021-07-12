
import 'package:flutter/material.dart';

class FoodListScreen extends StatefulWidget {
  FoodListScreen({Key? key}) : super(key: key);

  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  int itemCount = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
        itemBuilder: itemBuilder,
        separatorBuilder: separatorBuilder,
        itemCount: itemCount,
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

  Widget itemBuilder(BuildContext context, int index) {
    return Dismissible(
      key: ValueKey(index),
      child: ListTile(
        title: Text("sample"),
      ),
    );
  }

  Widget separatorBuilder(BuildContext context, int index) {
    return Divider();
  }
}