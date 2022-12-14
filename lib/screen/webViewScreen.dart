import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:whats_for_dinner/model/restaurant_model.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;
    final name = restaurant.name;
    final address = restaurant.address;

    _launchURL(String url) async {//url의 값은 tel:02-958-9988
      print(url);
      String parsedUrl = 'tel:010-4941-0646';
      Uri uri = Uri.parse(parsedUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('운영중인지 확인해보세요!'),
      ),
      body: WebView(
        initialUrl:
        //    'https://www.google.com/search?q=$address $name',
        'https://search.naver.com/search.naver?where=nexearch&query=$address $name',
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          if (request.url.contains("tel:")) {
            _launchURL(request.url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
