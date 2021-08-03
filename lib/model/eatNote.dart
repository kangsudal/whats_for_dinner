import 'package:hive/hive.dart';

part 'eatNote.g.dart';

final String tableName = 'eatNote_table';

@HiveType(typeId: 1)
class EatNote {
  //데이터베이스 구조
  @HiveField(0)
  String rcpnm; //음식명
  @HiveField(1)
  DateTime eatDateTime; //먹은날짜

  EatNote({required this.rcpnm, required this.eatDateTime});

  @override
  String toString() {
    return 'EatNote{rcpnm: $rcpnm, eatDateTime: $eatDateTime}';
  }
}
