import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whats_for_dinner/model/eatNote.dart';
import 'package:whats_for_dinner/model/recipe.dart';

class PersistStorage {
  Box<Recipe>? allRecipeStorage;//recipeBox;
  Box<EatNote>? ateRecordStorage;//eatNoteBox;

  List<Recipe>? allRecipes;//이건 꼭필요한지 생각해보자
  List<EatNote>? ateRecords;

  Future<void> init() async{
    await Hive.initFlutter();
  }

  //open box(persis data storage/database)
  Future<Box> get _allRecipeStorage async{

    Hive.registerAdapter(RecipeAdapter());//이건 왜 필요하지?
    Box<Recipe> allRecipeStorage = await Hive.openBox<Recipe>('allRecipeStorage');
    this.allRecipeStorage = allRecipeStorage;
    return allRecipeStorage;
  }

  //box에 데이터 읽어오기


  //hive box에 데이터 영구적으로 저장하기
}
