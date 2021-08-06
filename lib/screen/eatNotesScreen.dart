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
        title: Text("data"),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<EatNote>("eatNoteBox").listenable(),
        builder: (context, Box<EatNote> box, child) {
//            print(box.isOpen);
          if (box.isNotEmpty) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                final item = box.getAt(index);
                var datetimeStr =
                    DateFormat('yyyy-MM-dd\nHH:mm').format(item!.eatDateTime);
                return ListTile(
                  title: Text(item.rcpnm),
                  subtitle: Text(datetimeStr),
                  trailing: Icon(Icons.more_vert),
                );
              },
              separatorBuilder: separatorBuilder,
              itemCount: box.length,
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
