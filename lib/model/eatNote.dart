import 'package:hive/hive.dart';
import 'package:whats_for_dinner/model/recipe.dart';

part 'eatNote.g.dart';

final String tableName = 'eatNote_table';

@HiveType(typeId: 1)
class EatNote {
  //데이터베이스 구조
  @HiveField(0)
  Recipe recipe; //음식명
  @HiveField(1)
  DateTime eatDateTime; //먹은날짜

  EatNote({required this.recipe, required this.eatDateTime});

  @override
  String toString() {
    return 'EatNote{recipe: $recipe, eatDateTime: $eatDateTime}';
  }
}
