import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/model/menuState.dart';
import 'package:whats_for_dinner/screen/listScreen.dart';

import 'manualScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                MaterialPageRoute(builder: (builder) => ListScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Consumer<MenuState>(
          builder: (context, menuState, child) {
            if (menuState.items.length == 0) {
              return Text("흔들어주세요!");
            } else {
              String src = menuState.randomRecipe.attfilenomk!;
//              src = src.replaceFirst("http", "https");
              return Column(
                children: [
                  Text(
                    menuState.randomRecipe.rcpnm!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Image.network(src),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ManualScreen(menuState.randomRecipe),
                        ),
                      );
                    },
                    child: Text("레시피 보기"),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
