import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (builder) => FoodListScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text("흔들어주세요"),
      ),
    );
  }
}

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
