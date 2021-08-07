import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:whats_for_dinner/model/eatNote.dart';
import 'package:intl/intl.dart';

class EatNotesScreen extends StatefulWidget {
  EatNotesScreen({Key? key}) : super(key: key);

  @override
  _EatNotesScreenState createState() => _EatNotesScreenState();
}

class _EatNotesScreenState extends State<EatNotesScreen> {
  @override
  Widget build(BuildContext context) {
//    print("enter");
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<EatNote>("eatNoteBox").listenable(),
        builder: (context, Box<EatNote> box, child) {
//            print(box.isOpen);
          if (box.isNotEmpty) {
            var map = countOccurrences(box);
            print(
                map); //{가지말이샐러드: 2, 미나리버섯고기말이&산채소스: 1, 소안심 야채 호박잎쌈: 1, 호박 프리타타: 2}
            //todo: map의 value가 가장 큰 1,2,3위 element 구하기.
//            var keyList = map.keys.toList();
//            var valueList = map.values.toList();
//            valueList.sort();
//            print("1위:${valueList[0]}, 2위:${valueList[1]}, 3위:${valueList[2]}");
//            print(map.entries.where((element) => element.value==valueList[0]));

            final List fruits = map.entries.toList();
            print(fruits);
            fruits.sort((a, b) {
              MapEntry entryA = a;
              MapEntry entryB = b;
              return (entryB.value).compareTo((entryA.value));
            });
            print(fruits);
            fruits.forEach((element) {
              final key = element.key;
              final value = element.value;
              print("$key는 $value번 드셨어요.");
            });

            return Column(
              children: [
                Container(
                  height: 150,
                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(child: Text("1")),
                      ),
                      Expanded(
                        child: Center(child: Text("2")),
                      ),
                      Expanded(
                        child: Center(child: Text("3")),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      final item = box.getAt(index);
                      var datetimeStr = DateFormat('yyyy-MM-dd\nHH:mm')
                          .format(item!.eatDateTime);
                      return ListTile(
                        title: Text(item.rcpnm),
                        subtitle: Text(datetimeStr),
                        trailing: Icon(Icons.more_vert),
                      );
                    },
                    separatorBuilder: separatorBuilder,
                    itemCount: box.length,
                  ),
                ),
              ],
            );
          }
          return Center(
            child: Text('아직 기록된 음식이 없습니다.'),
          );
        },
      ),
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
}

Map countOccurrences(Box<EatNote> box) {
  var elements = box.values;
  var map = Map();
  elements.forEach((element) {
    if (!map.containsKey(element.rcpnm)) {
      map[element.rcpnm] = 1;
    } else {
      map[element.rcpnm] += 1;
    }
  });
  return map;
}
