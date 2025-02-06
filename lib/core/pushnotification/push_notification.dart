
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin fltNotification =
    FlutterLocalNotificationsPlugin();
FlutterLocalNotificationsPlugin rideNotification =
    FlutterLocalNotificationsPlugin();
var androiInit =
    const AndroidInitializationSettings('@mipmap/ic_launcher'); //for logo
var iosInit = const DarwinInitializationSettings(
  defaultPresentAlert: true,
  defaultPresentBadge: true,
  defaultPresentSound: true,
);

var androidDetails = const AndroidNotificationDetails(
  '54321',
  'normal_notification',
  enableVibration: true,
  enableLights: true,
  importance: Importance.high,
  playSound: true,
  priority: Priority.high,
  visibility: NotificationVisibility.private,
);

var iosDetails = const DarwinNotificationDetails(
    presentAlert: true, presentBadge: true, presentSound: true);

bool isGeneral = false;
String latestNotification = '';
int id = 0;
class PushNotification {
  void notificationTapBackground(NotificationResponse notificationResponse) {
    isGeneral = true;
  }

  var generalNotificationDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);

  var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final Response response = await Dio().get(url);
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    return filePath;
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final Response response = await Dio().get(url);
    return response.data;
  }

  Future<void> _showBigPictureNotificationURLGeneral(message) async {
    latestNotification = message['message'];
    if (Platform.isAndroid) {
      final ByteArrayAndroidBitmap bigPicture =
          ByteArrayAndroidBitmap(await _getByteArrayFromUrl(message['image']));
      final BigPictureStyleInformation bigPictureStyleInformation =
          BigPictureStyleInformation(bigPicture);
      final AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'notification_1',
        'general image notification',
        channelDescription: 'general notification with image',
        styleInformation: bigPictureStyleInformation,
        enableVibration: true,
        enableLights: true,
        importance: Importance.high,
        playSound: true,
        priority: Priority.high,
        visibility: NotificationVisibility.public,
      );
      final NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      fltNotification.initialize(initSetting,
          onDidReceiveNotificationResponse: notificationTapBackground,
          onDidReceiveBackgroundNotificationResponse:
              notificationTapBackground);
      await fltNotification.show(
          id++, message['title'], message['message'], notificationDetails);
    } else {
      final String bigPicturePath = await _downloadAndSaveFile(
          Uri.parse(message['image']).toString(), 'bigPicture.jpg');
      final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          attachments: <DarwinNotificationAttachment>[
            DarwinNotificationAttachment(
              bigPicturePath,
            )
          ]);

      final NotificationDetails notificationDetails =
          NotificationDetails(iOS: iosDetails);
      fltNotification.initialize(initSetting,
          onDidReceiveNotificationResponse: notificationTapBackground,
          onDidReceiveBackgroundNotificationResponse:
              notificationTapBackground);
      await fltNotification.show(
          id++, message['title'], message['message'], notificationDetails);
    }
    id = id++;
  }

  Future<void> showOtpNotification(message) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'notification_1',
    'ride notification',
    channelDescription: 'ride notification',
    enableVibration: true,
    enableLights: true,
    importance: Importance.high,
    playSound: true,
    priority: Priority.high,
    visibility: NotificationVisibility.public,
  );
  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails, iOS: iosDetails);
  rideNotification.initialize(initSetting);
  await rideNotification.show(id++, message.title.toString(),
      message.body.toString(), notificationDetails);
  id = id++;
}

  Future<void> _showGeneralNotification(message) async {
    latestNotification = message['message'];
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'notification_1',
      'general notification',
      channelDescription: 'general notification',
      enableVibration: true,
      enableLights: true,
      importance: Importance.high,
      playSound: true,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      fullScreenIntent: true
    );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosDetails);
    fltNotification.initialize(initSetting,
        onDidReceiveNotificationResponse: notificationTapBackground,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
    await fltNotification.show(
        id++, message['title'], message['message'], notificationDetails);
    id = id++;
  }

  Future<void> showRideNotification(message) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'notification_1',
      'ride notification',
      channelDescription: 'ride notification',
      enableVibration: true,
      enableLights: true,
      importance: Importance.high,
      playSound: true,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
    );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosDetails);
    rideNotification.initialize(initSetting);
    await rideNotification.show(id++, message.title.toString(),
        message.body.toString(), notificationDetails);
    id = id++;
  }

  initMessaging() async {
    
//     AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//   if (!isAllowed) {
//     // This is just a basic example. For real apps, you must show some
//     // friendly dialog box before call the request method.
//     // This is very important to not harm the user experience
//     AwesomeNotifications().requestPermissionToSendNotifications();
//   }
// });
//     AwesomeNotifications().initialize(
//   // set the icon to null if you want to use the default app icon
//   null,
//   [
//     NotificationChannel(
//         channelGroupKey: 'basic_channel_group',
//         channelKey: 'basic_channel',
//         channelName: 'Basic notifications',
//         channelDescription: 'Notification channel for basic tests',
//         defaultColor: themeColor,
//         ledColor: Colors.white),
//     NotificationChannel(
//         channelGroupKey: 'ride_channel_1',
//         channelKey: 'ride_channel_1',
//         channelName: 'ride screen notifications',
//         channelDescription: 'Notification channel for full screen intent',
//         defaultColor: themeColor,
//         ledColor: Colors.white,
//         criticalAlerts: true,
//         importance: NotificationImportance.High,
//         enableLights: true,
//         channelShowBadge: true,
//         defaultPrivacy: NotificationPrivacy.Public
        
//         ),
//   ],
//   // Channel groups are only visual and are not required
//   channelGroups: [
//     NotificationChannelGroup(
//         channelGroupKey: 'basic_channel_group',
//         channelGroupName: 'Basic group'),
//         NotificationChannelGroup(
//         channelGroupKey: 'ride_channel',
//         channelGroupName: 'ride screen notifications'),
//   ],
//   debug: true
// );
// FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await fltNotification.initialize(initSetting);

    await FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        if (message.data['push_type'].toString() == 'general') {
          // latestNotification = message.data['message'];
          if (message.data['image'].isNotEmpty) {
            _showBigPictureNotificationURLGeneral(message.data);
          } else {
            _showGeneralNotification(message.data);
          }
        } else {
          showRideNotification(message.notification);
        }
      }
    });
    

  }
}