
import 'package:flutter/material.dart';
import 'package:whats_for_dinner/screen/foodListScreen.dart';

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