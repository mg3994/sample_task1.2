import 'package:dartz/dartz.dart';
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

class BookingUsecase {
  final BookingRepository _bookingRepository;

  const BookingUsecase(this._bookingRepository);

  // Eta Details
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
    return _bookingRepository.etaRequest(
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
  }

  // Rental Eta Details
  Future<Either<Failure, RentalPackagesModel>> rentalEtaRequest({
    required String picklat,
    required String picklng,
    required String transportType,
    String? promoCode,
  }) async {
    return _bookingRepository.rentalEtaRequest(
        picklat: picklat, picklng: picklng, transportType: transportType);
  }

  //  createRequest
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
    return _bookingRepository.createRequest(
      userData: userData,
      vehicleData: vehicleData,
      pickupAddressList: pickupAddressList,
      dropAddressList: dropAddressList,
      selectedTransportType: selectedTransportType,
      selectedPaymentType: selectedPaymentType,
      scheduleDateTime: scheduleDateTime,
      isEtaRental: isEtaRental,
      isBidRide : isBidRide,
      goodsTypeId: goodsTypeId,
      goodsQuantity: goodsQuantity,
      offeredRideFare: offeredRideFare,
      polyLine: polyLine,
      isPetAvailable: isPetAvailable,
      isLuggageAvailable: isLuggageAvailable,
      isAirport: isAirport,
      paidAt: paidAt,
      isParcel: isParcel,
      packageId: packageId,
      isOutstationRide :isOutstationRide,
      isRoundTrip: isRoundTrip,
      scheduleDateTimeForReturn: scheduleDateTimeForReturn,
    );
  }

  // cancelRequest
  Future<Either<Failure, dynamic>> cancelRequest({
    required String requestId,
    String? reason,
    bool? timerCancel,
  }) async {
    return _bookingRepository.cancelRequest(
        requestId: requestId, reason: reason, timerCancel: timerCancel);
  }

  // User Reviews
  Future<Either<Failure, dynamic>> userReview(
      {required String requestId,
      required String ratings,
      required String feedBack}) async {
    return _bookingRepository.userReview(
        requestId: requestId, ratings: ratings, feedBack: feedBack);
  }

  // Goods Types
  Future<Either<Failure, GoodsTypeModel>> getGoodsTypes() async {
    return _bookingRepository.getGoodsTypes();
  }

  // BiddingAccept
  Future<Either<Failure, dynamic>> biddingAccept(
      {required String requestId,
      required String driverId,
      required String acceptRideFare,
      required String offeredRideFare}) async {
    return _bookingRepository.biddingAccept(
        requestId: requestId,
        driverId: driverId,
        acceptRideFare: acceptRideFare,
        offeredRideFare: offeredRideFare);
  }

  // CancelReasons
  Future<Either<Failure, CancelReasonsModel>> cancelReasons(
      {required String beforeOrAfter, required String transportType}) async {
    return _bookingRepository.cancelReasons(
        beforeOrAfter: beforeOrAfter, transportType: transportType);
  }

  // Get Polyline
  Future<Either<Failure, PolylineModel>> getPolyline({
    required double pickLat,
    required double pickLng,
    required double dropLat,
    required double dropLng,
    required List<AddressModel> stops,
    required bool isOpenStreet,
  }) async {
    return _bookingRepository.getPolyline(
      pickLat: pickLat,
      pickLng: pickLng,
      dropLat: dropLat,
      dropLng: dropLng,
      stops: stops,
      isOpenStreet: isOpenStreet,
    );
  }

  // Chat History
  Future<Either<Failure, ChatHistoryModel>> getChatHistory(
      {required String requestId}) async {
    return _bookingRepository.getChatHistory(requestId: requestId);
  }

  // Chat Seen
  Future<dynamic> seenChatMessage({required String requestId}) async {
    return _bookingRepository.seenChatMessage(requestId: requestId);
  }

  // Chat Message Send
  Future<Either<Failure, dynamic>> sendChatMessage(
      {required String requestId, required String message}) async {
    return _bookingRepository.sendChatMessage(
        requestId: requestId, message: message);
  }
}
