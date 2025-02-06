part of 'booking_bloc.dart';

abstract class BookingEvent {}

class UpdateEvent extends BookingEvent {}

class BookingGetEvent extends BookingEvent {}

class BookingInitEvent extends BookingEvent {
  final BookingPageArguments arg;
  final dynamic vsync;

  BookingInitEvent({required this.arg, required this.vsync});
}

class GetDirectionEvent extends BookingEvent {}

// Get eta request
class BookingEtaRequestEvent extends BookingEvent {
  final String picklat;
  final String picklng;
  final String droplat;
  final String droplng;
  final int ridetype;
  final String transporttype;
  final String? promocode;
  final String? vehicleId;
  final String distance;
  final String duration;
  final String polyLine;
  final List<AddressModel> pickupAddressList;
  final List<AddressModel> dropAddressList;
  final bool isOutstationRide;
  final bool isWithoutDestinationRide;
  BookingEtaRequestEvent(
      {required this.picklat,
      required this.picklng,
      required this.droplat,
      required this.droplng,
      required this.ridetype,
      required this.transporttype,
      this.promocode,
      this.vehicleId,
      required this.distance,
      required this.duration,
      required this.polyLine,
      required this.pickupAddressList,
      required this.dropAddressList,
      required this.isOutstationRide,
      required this.isWithoutDestinationRide});
}

class BookingRentalEtaRequestEvent extends BookingEvent {
  final String picklat;
  final String picklng;
  final String transporttype;
  final String? promocode;

  BookingRentalEtaRequestEvent({
    required this.picklat,
    required this.picklng,
    required this.transporttype,
    this.promocode,
  });
}

class BookingEtaSelectEvent extends BookingEvent {
  final int selectedVehicleIndex;
  final bool isOutstationRide;

  BookingEtaSelectEvent(
      {required this.selectedVehicleIndex, required this.isOutstationRide});
}

class BookingRentalPackageSelectEvent extends BookingEvent {
  final int selectedPackageIndex;

  BookingRentalPackageSelectEvent({required this.selectedPackageIndex});
}

class ShowRentalPackageListEvent extends BookingEvent {}

class RentalPackageConfirmEvent extends BookingEvent {
  final String picklat;
  final String picklng;

  RentalPackageConfirmEvent({required this.picklat, required this.picklng});
}

class BookingNavigatorPopEvent extends BookingEvent {}

class BookingStreamRequestEvent extends BookingEvent {}

class BookingConfirmEvent extends BookingEvent {}

class TimerEvent extends BookingEvent {
  final int duration;

  TimerEvent({
    required this.duration,
  });
}

class NoDriversEvent extends BookingEvent {}

class BookingCreateRequestEvent extends BookingEvent {
  final UserDetail userData;
  final dynamic vehicleData;
  final List<AddressModel> pickupAddressList;
  final List<AddressModel> dropAddressList;
  final String selectedTransportType;
  final String selectedPaymentType;
  final String scheduleDateTime;
  final String goodsTypeId;
  final String goodsQuantity;
  final String polyLine;
  final bool isRentalRide;
  final bool isPetAvailable;
  final bool isLuggageAvailable;
  final String paidAt;

  BookingCreateRequestEvent({
    required this.userData,
    required this.vehicleData,
    required this.pickupAddressList,
    required this.dropAddressList,
    required this.selectedTransportType,
    required this.selectedPaymentType,
    required this.scheduleDateTime,
    required this.goodsTypeId,
    required this.goodsQuantity,
    required this.polyLine,
    required this.isRentalRide,
    required this.isPetAvailable,
    required this.isLuggageAvailable,
    required this.paidAt,
  });
}

class BookingCancelRequestEvent extends BookingEvent {
  final String requestId;
  final String? reason;
  final bool? timerCancel;

  BookingCancelRequestEvent(
      {required this.requestId, this.reason, this.timerCancel});
}

class TripRideCancelEvent extends BookingEvent {
  final bool isCancelByDriver;

  TripRideCancelEvent({required this.isCancelByDriver});
}

class BookingGetUserDetailsEvent extends BookingEvent {
  final String? requestId;

  BookingGetUserDetailsEvent({this.requestId});
}

class ShowEtaInfoEvent extends BookingEvent {
  final int infoIndex;
  ShowEtaInfoEvent({required this.infoIndex});
}

class BookingRatingsSelectEvent extends BookingEvent {
  final int selectedIndex;

  BookingRatingsSelectEvent({required this.selectedIndex});
}

class BookingUserRatingsEvent extends BookingEvent {
  final String requestId;
  final String ratings;
  final String feedBack;

  BookingUserRatingsEvent(
      {required this.requestId, required this.ratings, required this.feedBack});
}

class GetGoodsTypeEvent extends BookingEvent {}

// class SelectContactDetailsEvent extends BookingEvent {}

class EnableBiddingEvent extends BookingEvent {}

class BiddingIncreaseOrDecreaseEvent extends BookingEvent {
  final bool isIncrease;

  BiddingIncreaseOrDecreaseEvent({required this.isIncrease});
}

class BiddingCreateRequestEvent extends BookingEvent {
  final UserDetail userData;
  final EtaDetails vehicleData;
  final List<AddressModel> pickupAddressList;
  final List<AddressModel> dropAddressList;
  final String selectedTransportType;
  final String selectedPaymentType;
  final String scheduleDateTime;
  final String goodsTypeId;
  final String goodsQuantity;
  final String offeredRideFare;
  final String polyLine;
  final bool isPetAvailable;
  final bool isLuggageAvailable;
  final String paidAt;
  final bool isOutstationRide;
  final bool isRoundTrip;
  final String scheduleDateTimeForReturn;

  BiddingCreateRequestEvent({
    required this.userData,
    required this.vehicleData,
    required this.pickupAddressList,
    required this.dropAddressList,
    required this.selectedTransportType,
    required this.selectedPaymentType,
    required this.scheduleDateTime,
    required this.goodsTypeId,
    required this.goodsQuantity,
    required this.offeredRideFare,
    required this.polyLine,
    required this.isPetAvailable,
    required this.isLuggageAvailable,
    required this.paidAt,
    required this.isOutstationRide,
    required this.isRoundTrip,
    required this.scheduleDateTimeForReturn,
  });
}

class BiddingFareUpdateEvent extends BookingEvent {}

class BiddingAcceptOrDeclineEvent extends BookingEvent {
  final bool isAccept;
  final dynamic driver;
  final String? id;
  final String? offeredRideFare;

  BiddingAcceptOrDeclineEvent({
    required this.isAccept,
    required this.driver,
    this.id,
    this.offeredRideFare,
  });
}

class CancelReasonsEvent extends BookingEvent {
  final String beforeOrAfter;
  CancelReasonsEvent({required this.beforeOrAfter});
}

class PolylineEvent extends BookingEvent {
  final double pickLat;
  final double pickLng;
  final double dropLat;
  final double dropLng;
  final String pickAddress;
  final String dropAddress;
  final List<AddressModel> stops;
  final bool? isInitCall;
  final bool? isDriverStream;
  final bool? isDriverToPick;
  final BookingPageArguments? arg;
  final BitmapDescriptor? icon;
  final String? markerId;
  PolylineEvent({
    required this.pickLat,
    required this.pickLng,
    required this.dropLat,
    required this.dropLng,
    required this.stops,
    required this.pickAddress,
    required this.dropAddress,
    this.isInitCall,
    this.isDriverStream,
    this.isDriverToPick,
    this.arg,
    this.icon,
    this.markerId,
  });
}

class ChatWithDriverEvent extends BookingEvent {
  final String requestId;

  ChatWithDriverEvent({required this.requestId});
}

class GetChatHistoryEvent extends BookingEvent {
  final String requestId;

  GetChatHistoryEvent({required this.requestId});
}

class SeenChatMessageEvent extends BookingEvent {
  final String requestId;

  SeenChatMessageEvent({required this.requestId});
}

class SendChatMessageEvent extends BookingEvent {
  final String message;
  final String requestId;

  SendChatMessageEvent({required this.message, required this.requestId});
}

class SOSEvent extends BookingEvent {}

class NotifyAdminEvent extends BookingEvent {
  final String serviceLocId;
  final String requestId;

  NotifyAdminEvent({required this.serviceLocId, required this.requestId});
}

class SelectBiddingOrDemandEvent extends BookingEvent {
  final String selectedTypeEta;
  final bool isBidding;

  SelectBiddingOrDemandEvent(
      {required this.selectedTypeEta, required this.isBidding});
}

class UpdateMinChildSizeEvent extends BookingEvent {
  final double minChildSize;
  UpdateMinChildSizeEvent({required this.minChildSize});
}

class UpdateScrollPhysicsEvent extends BookingEvent {
  final bool enableEtaScrolling;
  UpdateScrollPhysicsEvent({required this.enableEtaScrolling});
}

class UpdateScrollSizeEvent extends BookingEvent {
  final int minChildSize;
  UpdateScrollSizeEvent({required this.minChildSize});
}

class DetailViewUpdateEvent extends BookingEvent {
  final bool detailView;

  DetailViewUpdateEvent(this.detailView);
}

class FilterApplyEvent extends BookingEvent {
  final int filterCapasity;
  final List filterCategory;
  final List filterPermit;
  final List filterBodyType;

  FilterApplyEvent(
      {required this.filterCapasity,
      required this.filterCategory,
      required this.filterPermit,
      required this.filterBodyType});
}

class WalletPageReUpdateEvents extends BookingEvent {
  String from;
  String url;
  String userId;
  String requestId;
  String currencySymbol;
  String money;
  WalletPageReUpdateEvents(
      {required this.from,
      required this.url,
      required this.userId,
      required this.requestId,
      required this.currencySymbol,
      required this.money});
}
