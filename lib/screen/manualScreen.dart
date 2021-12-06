import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whats_for_dinner/model/eatNote.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:share_files_and_screenshot_widgets_plus/share_files_and_screenshot_widgets_plus.dart';

class ManualScreen extends StatefulWidget {
  final Recipe recipe;
  ManualScreen(this.recipe);
  @override
  _ManualScreenState createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  Widget? _image;
  GlobalKey previewContainer = GlobalKey();
  int originalSize = 800;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.recipe.rcpnm!),
        actions: [
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                shareScreenshot();
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: RepaintBoundary(
          //캡쳐하고싶은 위젯 범위
          key: previewContainer,
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  color: Colors.white,
                ),
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      child: ClipRRect(
                        child: Image.network(widget.recipe.attfilenomain!),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(45),
                            bottomRight: Radius.circular(45),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.recipe.rcpnm!,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("재료: ${widget.recipe.rcppartsdtls!}"),
                    SizedBox(
                      height: 10,
                    ),
                    if (widget.recipe.manual01 != '')
                      Text(widget.recipe.manual01!),
                    if (widget.recipe.manualimg01 != '')
                      Image.network(widget.recipe.manualimg01!),
                    if (widget.recipe.manual02 != '')
                      Text(widget.recipe.manual02!),
                    if (widget.recipe.manualimg02 != '')
                      Image.network(widget.recipe.manualimg02!),
                    if (widget.recipe.manual03 != '')
                      Text(widget.recipe.manual03!),
                    if (widget.recipe.manualimg03 != '')
                      Image.network(widget.recipe.manualimg03!),
                    if (widget.recipe.manual04 != '')
                      Text(widget.recipe.manual04!),
                    if (widget.recipe.manualimg04 != '')
                      Image.network(widget.recipe.manualimg04!),
                    if (widget.recipe.manual05 != '')
                      Text(widget.recipe.manual05!),
                    if (widget.recipe.manualimg05 != '')
                      Image.network(widget.recipe.manualimg05!),
                    if (widget.recipe.manual06 != '')
                      Text(widget.recipe.manual06!),
                    if (widget.recipe.manualimg06 != '')
                      Image.network(widget.recipe.manualimg06!),
                    if (widget.recipe.manual07 != '')
                      Text(widget.recipe.manual07!),
                    if (widget.recipe.manualimg07 != '')
                      Image.network(widget.recipe.manualimg07!),
                    if (widget.recipe.manual08 != '')
                      Text(widget.recipe.manual08!),
                    if (widget.recipe.manualimg08 != '')
                      Image.network(widget.recipe.manualimg08!),
                    if (widget.recipe.manual09 != '')
                      Text(widget.recipe.manual09!),
                    if (widget.recipe.manualimg09 != '')
                      Image.network(widget.recipe.manualimg09!),
                    if (widget.recipe.manual10 != '')
                      Text(widget.recipe.manual10!),
                    if (widget.recipe.manualimg10 != '')
                      Image.network(widget.recipe.manualimg10!),
                    if (widget.recipe.manual11 != '')
                      Text(widget.recipe.manual11!),
                    if (widget.recipe.manualimg11 != '')
                      Image.network(widget.recipe.manualimg11!),
                    if (widget.recipe.manual12 != '')
                      Text(widget.recipe.manual12!),
                    if (widget.recipe.manualimg12 != '')
                      Image.network(widget.recipe.manualimg12!),
                    if (widget.recipe.manual13 != '')
                      Text(widget.recipe.manual13!),
                    if (widget.recipe.manualimg13 != '')
                      Image.network(widget.recipe.manualimg13!),
                    if (widget.recipe.manual14 != '')
                      Text(widget.recipe.manual14!),
                    if (widget.recipe.manualimg14 != '')
                      Image.network(widget.recipe.manualimg14!),
                    if (widget.recipe.manual15 != '')
                      Text(widget.recipe.manual15!),
                    if (widget.recipe.manualimg15 != '')
                      Image.network(widget.recipe.manualimg15!),
                    if (widget.recipe.manual16 != '')
                      Text(widget.recipe.manual16!),
                    if (widget.recipe.manualimg16 != '')
                      Image.network(widget.recipe.manualimg16!),
                    if (widget.recipe.manual17 != '')
                      Text(widget.recipe.manual17!),
                    if (widget.recipe.manualimg17 != '')
                      Image.network(widget.recipe.manualimg17!),
                    if (widget.recipe.manual18 != '')
                      Text(widget.recipe.manual18!),
                    if (widget.recipe.manualimg18 != '')
                      Image.network(widget.recipe.manualimg18!),
                    if (widget.recipe.manual19 != '')
                      Text(widget.recipe.manual19!),
                    if (widget.recipe.manualimg19 != '')
                      Image.network(widget.recipe.manualimg19!),
                    if (widget.recipe.manual20 != '')
                      Text(widget.recipe.manual20!),
                    if (widget.recipe.manualimg20 != '')
                      Image.network(widget.recipe.manualimg20!),
                    ElevatedButton(
                      child: Text("오늘은 이 메뉴로 확정!"),
                      onPressed: () {
//                print("똑똑 열리셨나요?${Hive.isBoxOpen('eatNoteBox')}");
                        final Box box = Hive.box<EatNote>('eatNoteBox');
                        box.add(EatNote(
                            recipe: widget.recipe,
                            eatDateTime: DateTime.now()));
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void takingScreenshot() {
    //RepaintBoundary 위젯으로 감싸진 위젯들을 Image로 저장
    ShareFilesAndScreenshotWidgets()
        .takeScreenshot(previewContainer, originalSize)
        .then(
      (Image value) {
        setState(
          () {
            _image = value;
          },
        );
      },
    );
  }

  void shareScreenshot() {
    //Image로 저장한 스샷을 외부 위젯으로 공유
    ShareFilesAndScreenshotWidgets().shareScreenshot(
        previewContainer,
        originalSize,
        "title",
        "namename.png",
        "image/png",
        text: "오늘 이거 먹을래?");
  }
}
