import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whats_for_dinner/model/eatNote.dart';
import 'package:whats_for_dinner/model/recipe.dart';

/*
json으로 받아온 데이터는 어플리케이션을 껐다 키면 날아간다.
데이터를 persist storage(database)에 저장해놓고 필요할때마다 데이터를 읽어오는 클래스
local storage: hive box
cloud storage: firestore storage 사용 예정
external hard disk storage: ?
 */
class PersistStorage {
  // Box<Recipe>? allRecipeStorage; //recipeBox;
  // Box<EatNote>? ateRecordStorage; //eatNoteBox;

  // List<Recipe>? allRecipes;//이건 꼭필요한지 생각해보자
  // List<EatNote>? ateRecords;

  Future<void> init() async {
    await Hive.initFlutter();
  }

  //create and open local storage
  Future<Box<Recipe>> get _allRecipeStorage async {
    Hive.registerAdapter(
        RecipeAdapter()); //이건 왜 필요하지? hive에서 저장할수있는 기본 데이터 타입 이외에 custom Object를 저장하기위해. type 등록
    Box<Recipe> allRecipeStorage =
        await Hive.openBox<Recipe>('allRecipeStorage');
    return allRecipeStorage;
  }

  //read data from local storage
  //allRecipeStorage 박스에서 모든 Recipe를 얻는 메서드
  Future<List<Recipe>> loadAllRecipes() async {
    try {
      final Box<Recipe> localStorage =
          await _allRecipeStorage; //데이터베이스 reference를 얻음
      final List<Recipe> allRecipes = localStorage.values.toList(); //데이터 읽기

      return allRecipes;
    } catch (e) {
      log("loadAllRecipes()에서 에러가 발생했습니다.");
      //에러가 발생할 경우 비어있는 리스트 반환
      return [];
    }
  }

  //save data to local storage
  Future<void> insertRecipe(Recipe recipe) async {
    //hive box reference를 얻는다
    final Box<Recipe> localStorage = await _allRecipeStorage;
    await localStorage.add(recipe);
  }

  //update data in local storage
  Future<void> updateRecipe(int index, Recipe updatedRecipe) async {
    final Box<Recipe> localStorage = await _allRecipeStorage;
    try {
      await localStorage.putAt(index, updatedRecipe);
      log("수정된 결과:" + localStorage.getAt(index).toString());
    } catch (e) {
      log("레시피를 수정하는데 에러가 발생했습니다. persisStorage.dart/updateRecipe 메소드");
    }
  }

  //delete data in local storage
  Future<void> deleteRecipe(int index) async {
    final Box<Recipe> localStorage = await _allRecipeStorage;
    try {
      await localStorage.deleteAt(index);
    } catch (e) {
      log("레시피를 삭제하는데 에러가 발생했습니다. persisStorage.dart/deleteRecipe 메소드");
    }
  }

  Future<void> deleteAllRecipe() async {
    final Box<Recipe> localStorage = await _allRecipeStorage;
    try {
      await localStorage.clear();
    } catch (e) {
      log("모든 레시피를 삭제하는데 에러가 발생했습니다. persisStorage.dart/deleteAllRecipe 메소드");
    }
  }
}
