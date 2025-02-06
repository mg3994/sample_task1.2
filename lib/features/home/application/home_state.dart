part of 'home_bloc.dart';

abstract class HomeState {}

final class HomeInitialState extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeLoadedState extends HomeState {}

final class LogoutState extends HomeState {}

final class HomeUpdateState extends HomeState {}

final class VechileStreamMarkerState extends HomeState {}

final class HomeLoadingStartState extends HomeState {}

final class HomeLoadingStopState extends HomeState {}

final class GetLocationPermissionState extends HomeState {}

final class UserOnTripState extends HomeState {
  final OnTripRequestData tripData;

  UserOnTripState({required this.tripData});
}

final class UserTripSummaryState extends HomeState {
  final OnTripRequestData requestData;
  final RequestBillData requestBillData;
  final DriverDetailData driverData;

  UserTripSummaryState(
      {required this.requestData,
      required this.requestBillData,
      required this.driverData});
}

final class ServiceTypeChangeState extends HomeState {}

final class UpdateLocationState extends HomeState {}

final class DestinationSelectState extends HomeState {
  final bool isPickupChange;
  final String? dropAddress;
  final LatLng? dropLatLng;

  DestinationSelectState({
    required this.isPickupChange,
    this.dropAddress,
    this.dropLatLng,
  });
}

final class LocateMeState extends HomeState {}

final class SearchOnChangeState extends HomeState {}

final class RecentSearchPlaceSelectState extends HomeState {
  final AddressModel address;
  final String transportType;

  RecentSearchPlaceSelectState({required this.address,required this.transportType});
}

final class SelectFromMapState extends HomeState {
  final bool isPickUpEdit;

  SelectFromMapState({
    required this.isPickUpEdit,
  });
}

final class OnGoingRidesFailureState extends HomeState {}

final class OnGoingRidesSuccessState extends HomeState {}

final class NavigateToOnGoingRidesPageState extends HomeState {}

// ConfirmPageState
final class ConfirmAddressState extends HomeState {
  final bool isEditAddress;
  final bool isPickUpEdit;
  final AddressModel address;
  final bool? isFavouriteAddress;
  final bool? isDelivery;

  ConfirmAddressState(
      {required this.isEditAddress,
      required this.isPickUpEdit,
      required this.address,
      this.isFavouriteAddress,
      this.isDelivery});
}

final class ReceiverDetailsState extends HomeState {
  final AddressModel address;

  ReceiverDetailsState({required this.address});
}

final class SelectContactDetailsState extends HomeState {}

final class UpdateScrollPositionState extends HomeState {
  final double sheetSize;
  UpdateScrollPositionState(this.sheetSize);
}

final class DeliverySelectState extends HomeState {}

final class RentalSelectState extends HomeState {}

final class OutStationSelectState extends HomeState {}

final class ConfirmRideAddressState extends HomeState {}

final class AddOrEditAddressState extends HomeState {}

final class RecentRouteSelectState extends HomeState {
  final RecentRouteData selectedRoute;

  RecentRouteSelectState({required this.selectedRoute});
}

final class RideWithoutDestinationState extends HomeState {}

final class CarouselUpdateState extends HomeState {
  final Map<String, int> carouselIndices;
  CarouselUpdateState({required this.carouselIndices});
}

final class ServiceNotAvailableState extends HomeState {
  final String message;

  ServiceNotAvailableState({required this.message});
}
