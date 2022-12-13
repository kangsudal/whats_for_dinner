import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:whats_for_dinner/model/restaurant_model.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;
    final name = restaurant.name;
    final address = restaurant.address;

    return Scaffold(
      appBar: AppBar(
        title: Text('운영중인지 확인해보세요!'),
      ),
      body: WebView(
        initialUrl:
        //    'https://www.google.com/search?q=$address $name',
        'https://search.naver.com/search.naver?where=nexearch&query=$address $name',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
