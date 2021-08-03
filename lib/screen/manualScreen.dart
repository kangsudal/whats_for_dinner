import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whats_for_dinner/model/eatNote.dart';
import 'package:whats_for_dinner/model/recipe.dart';

class ManualScreen extends StatelessWidget {
  final Recipe recipe;
  ManualScreen(this.recipe); //생성자 매개변수로 Recipe를 받는다
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.rcpnm!),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text("재료: ${recipe.rcppartsdtls!}"),
            SizedBox(
              height: 10,
            ),
            if (recipe.manual01 != '') Text(recipe.manual01!),
            if (recipe.manualimg01 != '') Image.network(recipe.manualimg01!),
            if (recipe.manual02 != '') Text(recipe.manual02!),
            if (recipe.manualimg02 != '') Image.network(recipe.manualimg02!),
            if (recipe.manual03 != '') Text(recipe.manual03!),
            if (recipe.manualimg03 != '') Image.network(recipe.manualimg03!),
            if (recipe.manual04 != '') Text(recipe.manual04!),
            if (recipe.manualimg04 != '') Image.network(recipe.manualimg04!),
            if (recipe.manual05 != '') Text(recipe.manual05!),
            if (recipe.manualimg05 != '') Image.network(recipe.manualimg05!),
            if (recipe.manual06 != '') Text(recipe.manual06!),
            if (recipe.manualimg06 != '') Image.network(recipe.manualimg06!),
            if (recipe.manual07 != '') Text(recipe.manual07!),
            if (recipe.manualimg07 != '') Image.network(recipe.manualimg07!),
            if (recipe.manual08 != '') Text(recipe.manual08!),
            if (recipe.manualimg08 != '') Image.network(recipe.manualimg08!),
            if (recipe.manual09 != '') Text(recipe.manual09!),
            if (recipe.manualimg09 != '') Image.network(recipe.manualimg09!),
            if (recipe.manual10 != '') Text(recipe.manual10!),
            if (recipe.manualimg10 != '') Image.network(recipe.manualimg10!),
            if (recipe.manual11 != '') Text(recipe.manual11!),
            if (recipe.manualimg11 != '') Image.network(recipe.manualimg11!),
            if (recipe.manual12 != '') Text(recipe.manual12!),
            if (recipe.manualimg12 != '') Image.network(recipe.manualimg12!),
            if (recipe.manual13 != '') Text(recipe.manual13!),
            if (recipe.manualimg13 != '') Image.network(recipe.manualimg13!),
            if (recipe.manual14 != '') Text(recipe.manual14!),
            if (recipe.manualimg14 != '') Image.network(recipe.manualimg14!),
            if (recipe.manual15 != '') Text(recipe.manual15!),
            if (recipe.manualimg15 != '') Image.network(recipe.manualimg15!),
            if (recipe.manual16 != '') Text(recipe.manual16!),
            if (recipe.manualimg16 != '') Image.network(recipe.manualimg16!),
            if (recipe.manual17 != '') Text(recipe.manual17!),
            if (recipe.manualimg17 != '') Image.network(recipe.manualimg17!),
            if (recipe.manual18 != '') Text(recipe.manual18!),
            if (recipe.manualimg18 != '') Image.network(recipe.manualimg18!),
            if (recipe.manual19 != '') Text(recipe.manual19!),
            if (recipe.manualimg19 != '') Image.network(recipe.manualimg19!),
            if (recipe.manual20 != '') Text(recipe.manual20!),
            if (recipe.manualimg20 != '') Image.network(recipe.manualimg20!),
            ElevatedButton(
              child: Text("오늘은 이 메뉴로 확정!"),
              onPressed: () {
//                print("똑똑 열리셨나요?${Hive.isBoxOpen('eatNoteBox')}");
                final Box box = Hive.box<EatNote>('eatNoteBox');
                box.add(EatNote(rcpnm: recipe.rcpnm!, eatDateTime: DateTime.now()));
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
