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
    return Scaffold(
      appBar: AppBar(),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<EatNote>("eatNoteBox").listenable(),
          builder: (context, Box<EatNote> box, child) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                final item = box.getAt(index);
                if (item == null) {
                  return Container(
                    child: Text('기록이 존재하지 않습니다.'),
                  );
                } else {
                  var datetimeStr = DateFormat('yyyy-MM-dd\nHH:mm').format(item.eatDateTime);
                  return ListTile(
                    title: Text(item.rcpnm),
                    subtitle: Text(datetimeStr),
                    trailing: Icon(Icons.more_vert),
                  );
                }
              },
              separatorBuilder: separatorBuilder,
              itemCount: box.length,
            );
          }),
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
