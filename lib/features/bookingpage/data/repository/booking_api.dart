import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../common/common.dart';
import '../../../../core/network/network.dart';
import '../../../home/domain/models/user_details_model.dart';
import '../../../home/domain/models/stop_address_model.dart';

class BookingApi {
  // Eta Details
  Future<dynamic> etaRequestApi({
    required String picklat,
    required String picklng,
    required String droplat,
    required String droplng,
    required int rideType,
    required String transportType,
    required String distance,
    required String duration,
    required String polyLine,
    required List<AddressModel> pickupAddressList,
    required List<AddressModel> dropAddressList,
    String? promoCode,
    String? vehicleType,
    required bool isOutstationRide,
    required bool isWithoutDestinationRide,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      List stopList = [];
      if (dropAddressList.length > 1) {
        for (var i = 0; i < dropAddressList.length; i++) {
          if (i != dropAddressList.length - 1) {
            stopList.add(dropAddressList[i].toJson());
          }
        }
      }
      Response response = await DioProviderImpl().post(ApiEndpoints.etaDetails,
          headers: {'Authorization': token},
          body: FormData.fromMap({
            'pick_lat': picklat,
            'pick_lng': picklng,
            if (droplat.isNotEmpty && !isWithoutDestinationRide) 'drop_lat': droplat,
            if (droplng.isNotEmpty && !isWithoutDestinationRide) 'drop_lng': droplng,
            'ride_type': rideType,
            if (promoCode != null) 'promo_code': promoCode,
            if (vehicleType != null) 'vehicle_type': vehicleType,
            'transport_type': transportType,
            'distance': distance,
            'duration': duration,
            'polyline': polyLine,
            'pick_address': pickupAddressList.first.address,
            'pick_short_address': pickupAddressList.first.address.split(',')[0],
            'drop_address': (dropAddressList.isNotEmpty)
                ? dropAddressList.last.address
                : '',
            'drop_short_address': (dropAddressList.isNotEmpty)
                ? dropAddressList.last.address.split(',')[0]
                : '',
            if (stopList.isNotEmpty) 'stops': jsonEncode(stopList),
           if(isOutstationRide) 'is_out_station': '1',
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Rental Eta Details
  Future<dynamic> rentalEtaRequestApi({
    required String picklat,
    required String picklng,
    required String transportType,
    String? promoCode,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.rentalEtaDetails,
          headers: {
            'Authorization': token,
          },
          body: FormData.fromMap({
            'pick_lat': picklat,
            'pick_lng': picklng,
            'transport_type': transportType
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future createRequestApi({
    required UserDetail userData,
    required dynamic vehicleData,
    required List<AddressModel> pickupAddressList,
    required List<AddressModel> dropAddressList,
    required String selectedTransportType,
    required String selectedPaymentType,
    required String scheduleDateTime,
    required bool isEtaRental,
    required bool isBidRide,
    required String goodsTypeId,
    required String goodsQuantity,
    required String offeredRideFare,
    required String polyLine,
    required bool isPetAvailable,
    required bool isLuggageAvailable,
    required String paidAt,
    required bool isOutstationRide,
    required bool isRoundTrip,
    required String scheduleDateTimeForReturn,
    bool? isAirport,
    bool? isParcel,
    String? packageId,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        (selectedTransportType == 'taxi')
            ? ApiEndpoints.createRequest
            : ApiEndpoints.deliveryCreateRequest,
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
        body: FormData.fromMap({
          if (isAirport != null && isAirport) 'is_airport': true,
          if (isParcel != null && isParcel) 'is_parcel': 1,
          'pick_lat': pickupAddressList[0].lat,
          'pick_lng': pickupAddressList[0].lng,
          'pick_address': pickupAddressList[0].address,
          if (dropAddressList.isNotEmpty) 'drop_lat': dropAddressList.last.lat,
          if (dropAddressList.isNotEmpty) 'drop_lng': dropAddressList.last.lng,
          if (dropAddressList.isNotEmpty)
            'drop_address': dropAddressList.first.address,
          'ride_type': 1,
          'vehicle_type': vehicleData.zoneTypeId,
          if (selectedTransportType != 'taxi') 'paid_at': paidAt,
          'payment_opt': (selectedPaymentType == 'cash')
              ? 1
              : (selectedPaymentType == 'wallet')
                  ? 2
                  : (selectedPaymentType == 'card' ||
                          selectedPaymentType == 'online')
                      ? 0
                      : '',
          'transport_type':
              (selectedTransportType == 'taxi') ? 'taxi' : 'delivery',
          'request_eta_amount':
              (!isEtaRental) ? vehicleData.total : vehicleData.fareAmount,
          if (offeredRideFare.isNotEmpty) 'offerred_ride_fare': offeredRideFare,
          if (scheduleDateTime.isNotEmpty) 'is_later': 1,
          // if (vehicleData.chooseRidelaterDriver == 1 &&
          //     vehicleData.choosenDriverId != '' &&
          //     vehicleData.laterDateTime != null)
          //   'driver_id': vehicleData.choosenDriverId,
          if (scheduleDateTime.isNotEmpty)
            'trip_start_time': scheduleDateTime.toString().substring(0, 19),
          'is_bid_ride': (scheduleDateTime.isNotEmpty)
              ? 0
              : (!isEtaRental && isBidRide)
                  ? 1
                  : 0,
          if (selectedTransportType != 'taxi')
            'pickup_poc_name': pickupAddressList[0].name,
          if (selectedTransportType != 'taxi')
            'pickup_poc_mobile': pickupAddressList[0].number,
          if (selectedTransportType != 'taxi')
            'pickup_poc_instruction': pickupAddressList[0].instructions,
          if (selectedTransportType != 'taxi' && !isEtaRental)
            'drop_poc_name': dropAddressList[dropAddressList.length - 1].name,
          if (selectedTransportType != 'taxi' && !isEtaRental)
            'drop_poc_mobile':
                dropAddressList[dropAddressList.length - 1].number,
          if (selectedTransportType != 'taxi' && !isEtaRental)
            'drop_poc_instruction':
                dropAddressList[dropAddressList.length - 1].instructions,
          if (selectedTransportType != 'taxi') 'goods_type_id': goodsTypeId,
          if (selectedTransportType != 'taxi')
            'goods_type_quantity': goodsQuantity,
          if (dropAddressList.length > 1) 'stops': jsonEncode(dropAddressList),
          if (isEtaRental && packageId != null) 'rental_pack_id': packageId,
           if (vehicleData.hasDiscount == true)
            'promocode_id': vehicleData.promocodeId,
          'poly_line': polyLine,
          'is_pet_available': isPetAvailable,
          'is_luggage_available': isLuggageAvailable,
          if (!isEtaRental) 'distance': vehicleData.distanceInMeters,
          if (!isEtaRental) 'duration': vehicleData.time.toString(),
          if(isOutstationRide) 'is_out_station' : '1',
          if (isOutstationRide&&isRoundTrip) 'is_round_trip':'1',
          if(isOutstationRide && isRoundTrip) 'return_time': scheduleDateTimeForReturn,
        }),
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future cancelRequestApi(
      {required String requestId, String? reason, bool? timerCancel}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.cancelRequest,
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: FormData.fromMap({
            'request_id': requestId,
            if (reason != null) 'reason': reason,
            if (timerCancel != null && timerCancel) 'cancel_method': 0
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // User Reviews
  Future<dynamic> userReviewApi(
      {required String requestId,
      required String ratings,
      required String feedBack}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(ApiEndpoints.userReview,
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: FormData.fromMap({
            'request_id': requestId,
            'rating': ratings,
            'comment': feedBack
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Goods Type
  Future<dynamic> goodsTypeApi() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(ApiEndpoints.goodsType,
      headers: {'Authorization': token, 'Content-Type': 'application/json'},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Bidding Accept
  Future<dynamic> biddingAcceptApi(
      {required String requestId,
      required String driverId,
      required String acceptRideFare,
      required String offeredRideFare}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.biddingAccept,
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: FormData.fromMap({
            'driver_id': driverId,
            'request_id': requestId,
            'accepted_ride_fare': acceptRideFare,
            'offerred_ride_fare': offeredRideFare,
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Cancel Reasons
  Future<dynamic> cancelReasonsApi(
      {required String beforeOrAfter, required String transportType}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        '${ApiEndpoints.cancelReasons}?arrived=$beforeOrAfter&transport_type=$transportType',
        headers: {'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // GetPolyline
  Future getPolylineApi({
    required double pickLat,
    required double pickLng,
    required double dropLat,
    required double dropLng,
    required List<AddressModel> stops,
    required bool isOpenStreet,
  }) async {
    try {
      PackageInfo buildKeys = await PackageInfo.fromPlatform();
      String signKey = buildKeys.buildSignature;
      String packageName = buildKeys.packageName;
      String wayPoints = '';
      List intermediates = [];

      // Construct waypoints if any
      if (isOpenStreet) {
        String wayPoints = '';
        String url = '';
        if (stops.isNotEmpty) {
          for (var stop in stops) {
            wayPoints += '${stop.lng},${stop.lat};'; // OSRM requires "lng,lat"
          }
          // Remove the last semicolon
          wayPoints = wayPoints.substring(0, wayPoints.length - 1);
        }

        // Construct the API request URL
        if (wayPoints.isNotEmpty) {
          url = 'https://routing.openstreetmap.de/routed-car/route/v1/driving/'
              '$pickLng,$pickLat;$wayPoints?overview=full';
        } else {
          url = 'https://routing.openstreetmap.de/routed-car/route/v1/driving/'
              '$pickLng,$pickLat;$dropLng,$dropLat?overview=full';
        }

        // Make the HTTP request
        Response response = await DioProviderImpl().getUri(Uri.parse(url));
        return response;
      } else {
        if (stops.isNotEmpty) {
          for (var stop in stops) {
            intermediates.add({
              "location": {
                "latLng": {"latitude": stop.lat, "longitude": stop.lng}
              }
            });
          }
        }
        printWrapped(ApiEndpoints.getPolyline
                .replaceAll('pickLat', '$pickLat')
                .replaceAll('pickLng', '$pickLng')
                .replaceAll('dropLat', '$dropLat')
                .replaceAll('dropLng', '$dropLng')
                .replaceAll('mapkey', AppConstants.mapKey) +
            wayPoints);
        Response response = await DioProviderImpl().post(
          ApiEndpoints.getPolyline,
          body: {
            "origin": {
              "location":{
                "latLng": {"latitude": pickLat, "longitude": pickLng}
              }
            },
            "destination": {
              "location":{
                "latLng": {"latitude": dropLat, "longitude": dropLng}
              }             
            },
            "intermediates": intermediates,
            "travelMode": "DRIVE",
            "routingPreference": "TRAFFIC_AWARE",
            "computeAlternativeRoutes": false,
            "routeModifiers": {
              "avoidTolls": false,
              "avoidHighways": false,
              "avoidFerries": false
            },
            "languageCode": "en-US",
            "units": "IMPERIAL"
          },
          headers: {
            'X-Goog-Api-Key': AppConstants.mapKey,
            'Content-Type': 'application/json',
            'X-Goog-FieldMask':
                'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
            if (Platform.isAndroid) 'X-Android-Package': packageName,
            if (Platform.isAndroid) 'X-Android-Cert': signKey,
            if (Platform.isIOS) 'X-IOS-Bundle-Identifier': packageName,
          },
        );
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getChatHistoryApi({required String requestId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        '${ApiEndpoints.chatHistory}/$requestId',
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> chatMessageSeenApi({required String requestId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.chatMessageSeen,
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: FormData.fromMap({'request_id': requestId}));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> sendChatMessageApi(
      {required String requestId, required String message}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.sendChatMessage,
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body:
              FormData.fromMap({'request_id': requestId, 'message': message}));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
