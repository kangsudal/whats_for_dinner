import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:sensors_plus/sensors_plus.dart';
// import 'package:shake/shake.dart';
import 'package:whats_for_dinner/model/menuProvider.dart';
import 'package:whats_for_dinner/model/persistStorage.dart';
import 'package:whats_for_dinner/screen/listScreen.dart';
import 'package:whats_for_dinner/screen/restaurantScreen.dart';

import 'historyScreen.dart';
import 'manualScreen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late RiveAnimationController indicatorController;
  StreamSubscription? _accelerometerSubscription;
  static const double shakeThreshold = 15.0;
  double lastX = 0, lastY = 0, lastZ = 0;
  int lastShakeTime = 0;

  @override
  void initState() {
    super.initState();

    // 가속도 센서 감지 시작
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final deltaX = (event.x - lastX).abs();
      final deltaY = (event.y - lastY).abs();
      final deltaZ = (event.z - lastZ).abs();

      if (deltaX > shakeThreshold || deltaY > shakeThreshold || deltaZ > shakeThreshold) {
        if (now - lastShakeTime > 1000) { // 1초 안에 중복 감지 방지
          lastShakeTime = now;
          ref.read(menuProvider.notifier).shuffle();
        }
      }

      lastX = event.x;
      lastY = event.y;
      lastZ = event.z;
    });

    indicatorController = SimpleAnimation('active');
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menu = ref.watch(menuProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.bookmark_border), //assessment icon도 괜찮은듯
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (builder) => HistoryScreen()),
              );
            },
          ),
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (builder) => ListScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: menu != null
            ? Column(
                children: [
                  Text(
                    menu.rcpnm!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: menu.attfilenomain!,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: RiveAnimation.asset(
                            'assets/riv/fork_indicator.riv',
                            controllers: [indicatorController],
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ), //attfilenomk
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManualScreen(menu),
                            ),
                          );
                        },
                        child: Text("레시피 보기"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantScreen(menu),
                            ),
                          );
                        },
                        child: Text('식당찾기'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 35,
                  ),
                ],
              )
            : Text("흔들어주세요!"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          // persistStorage.deleteAllRecipe(); //모든메뉴 삭제
          ref.read(menuProvider.notifier).shuffle();
        },
        backgroundColor: Colors.black,
      ),
    );
  }
}