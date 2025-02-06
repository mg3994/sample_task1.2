import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

//calculate distance
calculateDistance(
    {required double lat1,
    required double lon1,
    required double lat2,
    required double lon2}) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  var val = (12742 * asin(sqrt(a))) * 1000;
  return val;
}

// launchUrl
openUrl(String url) async {
  if (await launchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}
