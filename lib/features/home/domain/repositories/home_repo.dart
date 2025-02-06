import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/network/network.dart';
import '../../../account/domain/models/history_model.dart';
import '../models/recent_routes_model.dart';
import '../models/stop_address_model.dart';
import '../models/user_details_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, UserDetailResponseModel>> getUserDetails(
      {String? requestId});

  Future<Either<Failure, dynamic>> getAutoCompletePlaces({
    required String input,
    required String mapType,
    required String? countryCode,
    required String enbleContryRestrictMap,
    required LatLng currentLatLng,
  });

  Future<Either<Failure, dynamic>> getAutoCompletePlaceLatLng(
      {required String placeId});

  Future<Either<Failure, dynamic>> getAddressFromLatLng({
    required double lat,
    required double lng,
    required String mapType,
  });

  Future<Either<Failure, HistoryResponseModel>> getOnGoingRides(
      {required String historyFilter});

  Future<Either<Failure, RecentRoutesModel>> getRecentRoutes();

  Future<Either<Failure, dynamic>> serviceLocationVerify({
    required String rideType,
    required List<AddressModel> address,
  });
}
