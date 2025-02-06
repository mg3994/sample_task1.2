part of 'booking_bloc.dart';

abstract class BookingState {}

// Eta Details
final class BookingInitialState extends BookingState {}

final class BookingLoadingStartState extends BookingState {}

final class BookingLoadingStopState extends BookingState {}

final class BookingSuccessState extends BookingState {}

final class BookingFailureState extends BookingState {}

final class BookingUpdateState extends BookingState {}

final class BookingNavigatorPopState extends BookingState {}

final class EtaSelectState extends BookingState {}

final class RentalPackageSelectState extends BookingState {}

final class RentalPackageConfirmState extends BookingState {}

final class EtaNotAvailableState extends BookingState {}

final class ShowEtaInfoState extends BookingState {
  final int infoIndex;

  ShowEtaInfoState({required this.infoIndex});
}

final class LogoutState extends BookingState {}

final class TimerState extends BookingState {}

final class BookingCreateRequestSuccessState extends BookingState {}

final class BookingLaterCreateRequestSuccessState extends BookingState {
  final bool isOutstation;

  BookingLaterCreateRequestSuccessState({required this.isOutstation});

}

final class BookingCreateRequestFailureState extends BookingState {}

final class BookingNoDriversFoundState extends BookingState {}

final class BookingOnTripRequestState extends BookingState {}

final class BookingStreamRequestState extends BookingState {}

final class TripCompletedState extends BookingState {}

final class TripRideCancelState extends BookingState {
  final bool isCancelByDriver;

  TripRideCancelState({required this.isCancelByDriver});
}

final class BookingRatingsUpdateState extends BookingState {}

final class BookingUserRatingsSuccessState extends BookingState {}

final class SelectGoodsTypeState extends BookingState {}

final class GetContactPermissionState extends BookingState {}

final class SelectContactDetailsState extends BookingState {}

final class ShowBiddingState extends BookingState {}

final class BiddingCreateRequestSuccessState extends BookingState {}

final class BiddingCreateRequestFailureState extends BookingState {}

final class BiddingFareUpdateState extends BookingState {}

final class BookingRequestCancelState extends BookingState {}

final class CancelReasonState extends BookingState {}

final class PolylineSuccessState extends BookingState {}

final class ChatWithDriverState extends BookingState {}

final class SosState extends BookingState {}

final class MinChildUpdateState extends BookingState {}

final class BookingMinChildSizeUpdated extends BookingState {
  final double minChildSize;
  BookingMinChildSizeUpdated({required this.minChildSize});
}

final class BookingScrollPhysicsUpdated extends BookingState {
  final bool enableEtaScrolling;

  BookingScrollPhysicsUpdated({required this.enableEtaScrolling});
}

class DetailViewUpdateState extends BookingState {
  final bool detailView;

  DetailViewUpdateState(this.detailView);
}

class WalletPageReUpdateStates extends BookingState {
  String url;
  String userId;
  String requestId;
  String currencySymbol;
  String money;
  WalletPageReUpdateStates(
      {required this.url,
      required this.userId,
      required this.requestId,
      required this.currencySymbol,
      required this.money});
}
