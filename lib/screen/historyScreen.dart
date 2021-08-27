import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:whats_for_dinner/model/eatNote.dart';
import 'package:intl/intl.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:whats_for_dinner/screen/manualScreen.dart';
import 'dart:math' as math;
import 'moreFavoriteScreen.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
            //먹어본 음식 (이름:횟수) 리스트 가지고오기 많이 먹은 순서대로              : Box -> List
            final List favoriteFoods = getSortedFrequency(box);
            //TODO: 데이터가 많아지면 새로운 Box 만드는것 고려. (음식명:횟수)

            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    /*Navigator.push(context, MaterialPageRoute(builder: (builder)=>ManualScreen())) TODO: ManualScreen으로 넘겨줄 Recipe 객체 구하기*/
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
//                  color: Colors.grey,
                    height: 150,
                    child: Column(
                      children: [
                        Expanded(
                          child: buildTop3Cards(favoriteFoods),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) =>
                                      MoreFavoriteScreen(favoriteFoods),
                                ),
                              );
                            },
                            child: Text(
                              "더보기",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      final item = box.getAt(box.length - index - 1); //최신순
                      var datetimeStr = DateFormat('yyyy-MM-dd HH:mm')
                          .format(item!.eatDateTime);
                      return ListTile(
                        title: Text(item.recipe.rcpnm!),
                        subtitle: Text(datetimeStr),
                        trailing: Icon(Icons.more_vert),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => ManualScreen(item.recipe),
                            ),
                          );
                        },
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

  Row buildTop3Cards(List favoriteFoods) {
    return Row(
      children: List.generate(
        favoriteFoods.length < 3
            ? favoriteFoods.length
            : 3, //먹은 음식 종류가 3개 미만이면 그만큼, 그 이상이면 3개까지만
        (index) {
          Recipe food = favoriteFoods[index].key;
          int eatFreq = favoriteFoods[index].value;
          return Expanded(
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ManualScreen(food);
                      },
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(0.5),
                  ),
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(food.rcpnm!),
                      Text(
                        "${eatFreq.toString()}번 먹었어요",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                )),
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

  Map groupByRcpnm(Box<EatNote> box) {
    var elements = box.values;
    var map = Map(); //빈 map 생성
    elements.forEach((element) {
      if (!map.containsKey(element.recipe.rcpnm)) {
        //map에 key가 '가지말이샐러드'인 데이터가 없으면
        map[element.recipe.rcpnm] = 1; //1번 등장 체크
      } else {
        map[element.recipe.rcpnm] += 1; //2번째부턴 ++
      }
    });
    return map;
  }

  Map groupByRcpnm_test(Box<EatNote> box) {
    var elements = box.values;
//    print("elements출력: $elements");
//    print(elements.toList()[2]);
//    print(elements.toList()[3]);
//    print(elements.toList()[2].recipe==elements.toList()[3].recipe);
    var map = Map(); //빈 map 생성
    elements.forEach((element) {
      print(map.keys.toList().contains(element.recipe));
//      print(map.containsKey(element.recipe));
      if (!(map.keys.toList().contains(element.recipe))) {
        //map에 key가 '가지말이샐러드'인 데이터가 없으면
        map[element.recipe] = 1; //1번 등장 체크
      } else {
        map[element.recipe] += 1; //2번째부턴 ++
        print("${element.recipe.rcpnm} 하나 추가: ${map[element.recipe]}");
      }
    });
    return map;
  }

  List getSortedFrequency(Box<EatNote> box) {
    //group by rcpnm                      : Box -> Map
    //sort desc                           : Map -> List

    //음식명 기준으로 먹은 빈도 세기
    var countEatFrequencyMap = groupByRcpnm(box);
//    print(countEatFrequencyMap);
    //{가지말이샐러드: 2, 미나리버섯고기말이&산채소스: 1, 소안심 야채 호박잎쌈: 1, 호박 프리타타: 2}
    var countEatFrequencyMap_test = groupByRcpnm_test(box);
    print(countEatFrequencyMap_test);
    //{Instance of 'Recipe': 1, Instance of 'Recipe': 1, Instance of 'Recipe': 2}

    //정렬을 위해 map -> list로 변환
    final List favoriteFoods = countEatFrequencyMap.entries.toList();
//    print(favoriteFoods);
    //[MapEntry(가지말이샐러드: 2), MapEntry(미나리버섯고기말이&산채소스: 1), MapEntry(소안심 야채 호박잎쌈: 1), MapEntry(호박 프리타타: 2)]
    final List favoriteFoods_test = countEatFrequencyMap_test.entries.toList();
    print(favoriteFoods_test);
    //[MapEntry(Instance of 'Recipe': 1), MapEntry(Instance of 'Recipe': 1), MapEntry(Instance of 'Recipe': 2)]

    //value가 가장 큰 순서대로 내림차순 정렬
    favoriteFoods.sort((a, b) {
      MapEntry entryA = a;
      MapEntry entryB = b;
      return (entryB.value).compareTo((entryA.value));
    });
//    print(favoriteFoods);
    //[MapEntry(가지말이샐러드: 2), MapEntry(호박 프리타타: 2), MapEntry(미나리버섯고기말이&산채소스: 1), MapEntry(소안심 야채 호박잎쌈: 1)]

    favoriteFoods_test.sort((a, b) {
      MapEntry entryA = a;
      MapEntry entryB = b;
      return (entryB.value).compareTo((entryA.value));
    });
    print(favoriteFoods_test);
    //[MapEntry(Instance of 'Recipe': 2), MapEntry(Instance of 'Recipe': 1), MapEntry(Instance of 'Recipe': 1)]

    /*
    favoriteFoods.forEach((element) {
      final key = element.key; //음식 명
      final value = element.value; // 먹은 기록 횟수
      print("$key는 $value번 드셨어요.");
    });
     */
    return favoriteFoods_test;
  }
}
