import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../common/common.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/network.dart';
import '../../../home/domain/models/user_details_model.dart';
import '../../../home/domain/models/stop_address_model.dart';
import '../../domain/models/cancel_reason_model.dart';
import '../../domain/models/chat_history_model.dart';
import '../../domain/models/eta_details_model.dart';
import '../../domain/models/goods_type_model.dart';
import '../../domain/models/polyline_model.dart';
import '../../domain/models/rental_packages_model.dart';
import '../../domain/repositories/booking_repo.dart';
import '../repository/booking_api.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingApi _bookingApi;

  BookingRepositoryImpl(this._bookingApi);

  // Eta Details
  @override
  Future<Either<Failure, EtaDetailsListModel>> etaRequest({
    required String picklat,
    required String picklng,
    required String droplat,
    required String droplng,
    required int rideType,
    required String transportType,
    String? promoCode,
    String? vehicleType,
    required String distance,
    required String duration,
    required String polyLine,
    required List<AddressModel> pickupAddressList,
    required List<AddressModel> dropAddressList,
    required bool isOutstationRide,
    required bool isWithoutDestinationRide,
  }) async {
    EtaDetailsListModel etaResposeModel;
    try {
      Response response = await _bookingApi.etaRequestApi(
          picklat: picklat,
          picklng: picklng,
          droplat: droplat,
          droplng: droplng,
          rideType: rideType,
          transportType: transportType, 
          promoCode: promoCode,
          vehicleType: vehicleType,
          distance: distance,
          duration: duration,
          polyLine: polyLine,
          pickupAddressList: pickupAddressList,
          dropAddressList: dropAddressList,isOutstationRide:isOutstationRide,
          isWithoutDestinationRide: isWithoutDestinationRide);
      printWrapped('ETA RESPONSE : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(
            message:(response.data['errors']["promo_code"]!=null) 
            ? response.data['errors']["promo_code"][0].toString() 
            : response.data['message']));
      } else {
        if (response.statusCode == 400 || !response.data['success']) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else {
          etaResposeModel = EtaDetailsListModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(etaResposeModel);
  }

  // Rental Eta Request
  @override
  Future<Either<Failure, RentalPackagesModel>> rentalEtaRequest({
    required String picklat,
    required String picklng,
    required String transportType,
    String? promoCode,
  }) async {
    RentalPackagesModel etaResposeModel;
    try {
      Response response = await _bookingApi.rentalEtaRequestApi(
        picklat: picklat,
        picklng: picklng,
        transportType: transportType,
        promoCode: promoCode,
      );
      printWrapped('RENTAL ETA RESPONSE : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(
            message: response.data['errors']["promo_code"][0].toString()));
      } else {
        if (response.statusCode == 400 || !response.data['success']) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else {
          etaResposeModel = RentalPackagesModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(etaResposeModel);
  }

  @override
  Future<Either<Failure, dynamic>> createRequest({
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
    bool? isAirport,
    bool? isParcel,
    String? packageId,
    required bool isOutstationRide,
    required bool isRoundTrip,
    required String scheduleDateTimeForReturn,
  }) async {
    dynamic requestResponseModel;
    try {
      Response response = await _bookingApi.createRequestApi(
        userData: userData,
        vehicleData: vehicleData,
        pickupAddressList: pickupAddressList,
        dropAddressList: dropAddressList,
        selectedTransportType: selectedTransportType,
        paidAt: paidAt,
        selectedPaymentType: selectedPaymentType,
        scheduleDateTime: scheduleDateTime,
        isEtaRental: isEtaRental,
        isBidRide: isBidRide,
        goodsTypeId: goodsTypeId,
        goodsQuantity: goodsQuantity,
        offeredRideFare: offeredRideFare,
        polyLine: polyLine,
        isPetAvailable: isPetAvailable,
        isLuggageAvailable: isLuggageAvailable,
        isAirport: isAirport,
        isParcel: isParcel,
        packageId: packageId,
        isOutstationRide:isOutstationRide,
        isRoundTrip: isRoundTrip,
        scheduleDateTimeForReturn: scheduleDateTimeForReturn,
      );
      printWrapped('Create Request Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else {
          requestResponseModel = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(requestResponseModel);
  }

  @override
  Future<Either<Failure, dynamic>> cancelRequest({
    required String requestId,
    String? reason,
    bool? timerCancel,
  }) async {
    dynamic cancelResponse;
    try {
      Response response = await _bookingApi.cancelRequestApi(
          requestId: requestId, reason: reason, timerCancel: timerCancel);
      printWrapped('Cancel Request Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else {
          cancelResponse = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(cancelResponse);
  }

  @override
  Future<Either<Failure, dynamic>> userReview(
      {required String requestId,
      required String ratings,
      required String feedBack}) async {
    dynamic ratingsResponse;
    try {
      Response response = await _bookingApi.userReviewApi(
          requestId: requestId, ratings: ratings, feedBack: feedBack);
      printWrapped('Review Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else {
          ratingsResponse = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(ratingsResponse);
  }

  @override
  Future<Either<Failure, GoodsTypeModel>> getGoodsTypes() async {
    GoodsTypeModel goodTypeResponse;
    try {
      Response response = await _bookingApi.goodsTypeApi();
      printWrapped('Goods Type Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else {
          goodTypeResponse = GoodsTypeModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(goodTypeResponse);
  }

  @override
  Future<Either<Failure, dynamic>> biddingAccept(
      {required String requestId,
      required String driverId,
      required String acceptRideFare,
      required String offeredRideFare}) async {
    dynamic biddingAcceptResponse;
    try {
      Response response = await _bookingApi.biddingAcceptApi(
          requestId: requestId,
          driverId: driverId,
          acceptRideFare: acceptRideFare,
          offeredRideFare: offeredRideFare);
      printWrapped('Bidding accept Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else {
          biddingAcceptResponse = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(biddingAcceptResponse);
  }

  @override
  Future<Either<Failure, CancelReasonsModel>> cancelReasons(
      {required String beforeOrAfter, required String transportType}) async {
    CancelReasonsModel cancelReasonsResponse;
    try {
      Response response = await _bookingApi.cancelReasonsApi(
          beforeOrAfter: beforeOrAfter, transportType: transportType);
      printWrapped('Cancel Reasons Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else {
          cancelReasonsResponse = CancelReasonsModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(cancelReasonsResponse);
  }

  @override
  Future<Either<Failure, PolylineModel>> getPolyline({
    required double pickLat,
    required double pickLng,
    required double dropLat,
    required double dropLng,
    required List<AddressModel> stops,
    required bool isOpenStreet,
  }) async {
    PolylineModel polylineModel;
    try {
      Response response = await _bookingApi.getPolylineApi(
        pickLat: pickLat,
        dropLat: dropLat,
        pickLng: pickLng,
        dropLng: dropLng,
        stops: stops,
        isOpenStreet: isOpenStreet,
      );
      debugPrint('Polyline Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error_message']));
      } else {
        if (response.statusCode == 400 || response.statusCode == 401) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          if (isOpenStreet) {
            final List<dynamic> routes = response.data['routes'];

            polylineModel = PolylineModel.fromJson({
              'success': true,
              'polyString': routes[0]['geometry'],
              'distance': routes[0]['legs'][0]['distance'].toString(),
              'duration': (routes[0]['legs'][0]['duration'] / 60)
                  .roundToDouble()
                  .toString()
                  .split('.')[0]
            });
          } else {
            String duration = response.data['routes'][0]['duration']
                .toString()
                .replaceAll('s', '');
            polylineModel = PolylineModel.fromJson({
              'success': true,
              'polyString': response.data['routes'][0]['polyline']
                  ['encodedPolyline'],
              'distance': (response.data['routes'][0]['distanceMeters'])
                  .toString(),
              'duration':
                  (double.parse(duration) / 60).roundToDouble().toString().split('.')[0]
            });
          }
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(polylineModel);
  }

  @override
  Future<Either<Failure, ChatHistoryModel>> getChatHistory(
      {required String requestId}) async {
    ChatHistoryModel chatHistoryResponse;
    try {
      Response response =
          await _bookingApi.getChatHistoryApi(requestId: requestId);
      printWrapped('Chat History Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else {
          chatHistoryResponse = ChatHistoryModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(chatHistoryResponse);
  }

  @override
  Future<Either<Failure, dynamic>> seenChatMessage(
      {required String requestId}) async {
    dynamic seenResponse;
    try {
      Response response =
          await _bookingApi.chatMessageSeenApi(requestId: requestId);
      printWrapped('Chat Seen Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else {
          seenResponse = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(seenResponse);
  }

  @override
  Future<Either<Failure, dynamic>> sendChatMessage(
      {required String requestId, required String message}) async {
    dynamic seenResponse;
    try {
      Response response = await _bookingApi.sendChatMessageApi(
          requestId: requestId, message: message);
      printWrapped('Chat Send Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else {
          seenResponse = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(seenResponse);
  }
}
