import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../common/common.dart';
import '../../../../core/network/network.dart';
import '../../domain/models/stop_address_model.dart';

class HomeApi {
  Future getUserDetailsApi({String? requestId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.userDetails,
        queryParams: (requestId != null) ? {"current_ride": requestId} : null,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future getAutocompletePlaces({
    required String input,
    required String mapType,
    required String? countryCode,
    required String enbleContryRestrictMap,
    required LatLng currentLatLng,
  }) async {
    try {
      PackageInfo buildKeys = await PackageInfo.fromPlatform();
      String signKey = buildKeys.buildSignature;
      String packageName = buildKeys.packageName;
      if (mapType == 'google_map') {
        var requestBody = {
          "input": input,
          "locationBias": {
            "circle": {
              "center": {
                "latitude": currentLatLng.latitude,
                "longitude": currentLatLng.longitude
              },
              "radius": 10000,
            }
          },
        };
        Response response = await DioProviderImpl().post(
          'https://places.googleapis.com/v1/places:autocomplete',
          body: jsonEncode(requestBody),
          headers: {
            'X-Goog-Api-Key': AppConstants.mapKey,
            'Content-Type': 'application/json',
            if (Platform.isAndroid) 'X-Android-Package': packageName,
            if (Platform.isAndroid) 'X-Android-Cert': signKey,
            if (Platform.isIOS) 'X-IOS-Bundle-Identifier': packageName,
          },
        );
        return response;
      } else {
        final url = Uri.parse('https://nominatim.openstreetmap.org/search?'
            'q=$input&'
            'lat=${currentLatLng.latitude}&'
            'lon=${currentLatLng.longitude}&'
            'format=json&'
            'addressdetails=1&'
            'limit=10' // Adjust the limit as needed
            '${(enbleContryRestrictMap == '1' && countryCode != null) ? '&countrycodes=$countryCode' : ''}' // Add country codes if provided
            );
        Response result = await DioProviderImpl().getUri(url);
        return result.data;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future getAutocompletePlaceLatLng({
    required String placeId,
  }) async {
    try {
      PackageInfo buildKeys = await PackageInfo.fromPlatform();
      String signKey = buildKeys.buildSignature;
      String packageName = buildKeys.packageName;
      dynamic latLng;
      Response response = await DioProviderImpl().get(
        'https://places.googleapis.com/v1/places/$placeId?fields=id,displayName,location&key=${AppConstants.mapKey}',
        headers: (Platform.isAndroid)
            ? {'X-Android-Package': packageName, 'X-Android-Cert': signKey}
            : {'X-IOS-Bundle-Identifier': packageName},
      );
      latLng = LatLng(response.data['location']['latitude'],
          response.data['location']['longitude']);

      return latLng;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future getAddressFromLatLng({
    required double lat,
    required double lng,
    required String mapType,
  }) async {
    try {
      PackageInfo buildKeys = await PackageInfo.fromPlatform();
      String signKey = buildKeys.buildSignature;
      String packageName = buildKeys.packageName;
      if (mapType == 'google_map') {
        Response response = await DioProviderImpl().get(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${AppConstants.mapKey}',
          headers: (Platform.isAndroid)
              ? {'X-Android-Package': packageName, 'X-Android-Cert': signKey}
              : {'X-IOS-Bundle-Identifier': packageName},
        );
        return response;
      } else {
        Response response = await DioProviderImpl().get(
          'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json',
        );
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //get history
  Future getOnGoingRidesApi({required String historyFilter}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.history,
        queryParams: {'on_trip': historyFilter},
        headers: {'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // get Recent Routes
  Future getRecentRoutesApi() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.recentRoutes,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Service Location Verify
  Future serviceLocationVerifyApi({
    required String rideType,
    required List<AddressModel> address,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.serviceVerify,
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: {
        'ride_type': rideType,
        'address': address,
      });
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
