import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whats_for_dinner/model/eatNote.dart';
import 'package:whats_for_dinner/model/recipe.dart';
import 'package:share_files_and_screenshot_widgets_plus/share_files_and_screenshot_widgets_plus.dart';
import 'package:whats_for_dinner/screen/restaurantScreen.dart';

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
                        child: CachedNetworkImage(
                            errorWidget: (context, url, error) {
                              // log("error:$error");
                              return Icon(Icons.error);
                            },
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl: widget.recipe.attfilenomain!),
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
                          Padding(
                            padding: const EdgeInsets.only(top:30,bottom:15),
                            child: Text(widget.recipe.manual01!),
                          ),
                    if (widget.recipe.manualimg01 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg01!),
                    if (widget.recipe.manual02 != '')
                          Padding(
                            padding: const EdgeInsets.only(top:30,bottom:15),
                            child: Text(widget.recipe.manual02!),
                          ),
                    if (widget.recipe.manualimg02 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg02!),
                    if (widget.recipe.manual03 != '')
                          Padding(
                            padding: const EdgeInsets.only(top:30,bottom:15),
                            child: Text(widget.recipe.manual03!),
                          ),

                    if (widget.recipe.manualimg03 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg03!),
                    if (widget.recipe.manual04 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual04!),
                      ),
                    if (widget.recipe.manualimg04 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg04!),
                    if (widget.recipe.manual05 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual05!),
                      ),
                    if (widget.recipe.manualimg05 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg05!),
                    if (widget.recipe.manual06 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual06!),
                      ),
                    if (widget.recipe.manualimg06 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg06!),
                    if (widget.recipe.manual07 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual07!),
                      ),
                    if (widget.recipe.manualimg07 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg07!),
                    if (widget.recipe.manual08 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual08!),
                      ),
                    if (widget.recipe.manualimg08 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg08!),
                    if (widget.recipe.manual09 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual09!),
                      ),
                    if (widget.recipe.manualimg09 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg09!),
                    if (widget.recipe.manual10 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual10!),
                      ),
                    if (widget.recipe.manualimg10 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg10!),
                    if (widget.recipe.manual11 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual11!),
                      ),
                    if (widget.recipe.manualimg11 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg11!),
                    if (widget.recipe.manual12 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual12!),
                      ),
                    if (widget.recipe.manualimg12 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg12!),
                    if (widget.recipe.manual13 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual13!),
                      ),
                    if (widget.recipe.manualimg13 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg13!),
                    if (widget.recipe.manual14 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual14!),
                      ),
                    if (widget.recipe.manualimg14 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg14!),
                    if (widget.recipe.manual15 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual15!),
                      ),
                    if (widget.recipe.manualimg15 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg15!),
                    if (widget.recipe.manual16 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual16!),
                      ),
                    if (widget.recipe.manualimg16 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg16!),
                    if (widget.recipe.manual17 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual17!),
                      ),
                    if (widget.recipe.manualimg17 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg17!),
                    if (widget.recipe.manual18 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual18!),
                      ),
                    if (widget.recipe.manualimg18 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg18!),
                    if (widget.recipe.manual19 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual19!),
                      ),
                    if (widget.recipe.manualimg19 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg19!),
                    if (widget.recipe.manual20 != '')
                      Padding(
                        padding: const EdgeInsets.only(top:30,bottom:15),
                        child: Text(widget.recipe.manual20!),
                      ),
                    if (widget.recipe.manualimg20 != '')
                      CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            // log("error:$error");
                            return Icon(Icons.error);
                          },
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: widget.recipe.manualimg20!),
                    SizedBox(height: 30,),
                    ElevatedButton(
                      child: Text("오늘은 이 메뉴로 확정!"),
                      onPressed: () {
                        bookmarkRecipe(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantScreen(widget.recipe),
            ),
          );
        },
        child: Text('식당'),
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
    //RepaintBoundary 위젯으로 감싸진 위젯 스샷을 외부 위젯으로 공유
    ShareFilesAndScreenshotWidgets().shareScreenshot(
        previewContainer, originalSize, "title", "namename.png", "image/png",
        text: "오늘 이거 먹을래?");
  }

  void bookmarkRecipe(BuildContext context) {
    //print("똑똑 열리셨나요?${Hive.isBoxOpen('eatNoteBox')}");
    final Box box = Hive.box<EatNote>('eatNoteBox');
    box.add(EatNote(recipe: widget.recipe, eatDateTime: DateTime.now()));
    Navigator.of(context).pop();
  }
}
