import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restart_tagxi/db/app_database.dart';

import '../features/language/domain/models/language_listing_model.dart';

class AppConstants {
  static const String title = 'product name';
  static const String baseUrl = 'your base url here';
  static String firbaseApiKey = (Platform.isAndroid)
      ? "android firebase api key"
      : "ios firebase api key";
  static String firebaseAppId =
      (Platform.isAndroid) ? "android firebase app id" : "ios firebase app id";
  static String firebasemessagingSenderId = (Platform.isAndroid)
      ? "android firebase sender id"
      : "ios firebase sender id";
  static String firebaseProjectId = (Platform.isAndroid)
      ? "android firebase project id"
      : "ios firebase project id";

  static String mapKey =
      (Platform.isAndroid) ? 'android map key' : 'ios map key';
  static const String privacyPolicy = 'your privacy policy url';
  static const String termsCondition = 'your terms and condition url';

  static List<LocaleLanguageList> languageList = [
    LocaleLanguageList(name: 'English', lang: 'en'),
    LocaleLanguageList(name: 'Arabic', lang: 'ar'),
    LocaleLanguageList(name: 'French', lang: 'fr'),
    LocaleLanguageList(name: 'Spanish', lang: 'es'),
  ];

  static LatLng currentLocations = const LatLng(0, 0);
  double headerSize = 18.0;
  double subHeaderSize = 16.0;
  double buttonTextSize = 20.0;
}

AppDatabase db = AppDatabase();
