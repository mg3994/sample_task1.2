import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../common/common.dart';
import '../../../../common/pickup_icon.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/widgets/top_bar.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../../bookingpage/presentation/page/booking_page.dart';
import '../../../bookingpage/presentation/page/trip_summary_page.dart';
import '../../application/home_bloc.dart';

class OnGoingRidesPage extends StatelessWidget {
  static const String routeName = '/onGoingRidesPage';
  final OnGoingRidesPageArguments arg;

  const OnGoingRidesPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => HomeBloc()
        ..add(GetDirectionEvent())
        ..add(GetOnGoingRidesEvent()),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          if (state is HomeInitialState) {
            CustomLoader.loader(context);
          } else if (state is HomeLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is HomeLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is LogoutState) {
            if (context.read<HomeBloc>().nearByVechileSubscription != null) {
              context.read<HomeBloc>().nearByVechileSubscription?.cancel();
              context.read<HomeBloc>().nearByVechileSubscription = null;
            }
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          } else if (state is UserOnTripState) {
            if (context.read<HomeBloc>().nearByVechileSubscription != null) {
              context.read<HomeBloc>().nearByVechileSubscription?.cancel();
              context.read<HomeBloc>().nearByVechileSubscription = null;
            }
            Navigator.pushNamedAndRemoveUntil(
                context, BookingPage.routeName, (route) => false,
                arguments: BookingPageArguments(
                    picklat: state.tripData.pickLat,
                    picklng: state.tripData.pickLng,
                    droplat: state.tripData.dropLat,
                    droplng: state.tripData.dropLng,
                    pickupAddressList:
                        context.read<HomeBloc>().pickupAddressList,
                    stopAddressList: context.read<HomeBloc>().stopAddressList,
                    userData: arg.userData,
                    transportType: state.tripData.transportType,
                    polyString: state.tripData.polyLine,
                    distance: state.tripData.totalDistance,
                    duration: state.tripData.totalTime.toString(),
                    requestId: state.tripData.id,
                    isOutstationRide: state.tripData.isOutStation =="1",
                    mapType: arg.mapType));
          } else if (state is UserTripSummaryState) {
            if (context.read<HomeBloc>().nearByVechileSubscription != null) {
              context.read<HomeBloc>().nearByVechileSubscription?.cancel();
              context.read<HomeBloc>().nearByVechileSubscription = null;
            }
            Navigator.pushNamedAndRemoveUntil(
              context,
              TripSummaryPage.routeName,
              (route) => false,
              arguments: TripSummaryPageArguments(
                  requestData: state.requestData,
                  requestBillData: state.requestBillData,
                  driverData: state.driverData),
            );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Directionality(
              textDirection: context.read<HomeBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                  body: TopBarDesign(
                isHistoryPage: false,
                title: AppLocalizations.of(context)!.onGoingRides,
                isOngoingPage: true,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: context.read<HomeBloc>().isLoading
                      ? const Loader()
                      : (context.read<HomeBloc>().onGoingRideList.isEmpty)
                          ? Center(
                              child: MyText(
                                  text: AppLocalizations.of(context)!
                                      .noRidesFound))
                          : ListView.builder(
                              itemCount: context
                                  .read<HomeBloc>()
                                  .onGoingRideList
                                  .length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                final ride = context
                                    .read<HomeBloc>()
                                    .onGoingRideList
                                    .elementAt(index);
                                return InkWell(
                                  onTap: () {
                                    context.read<HomeBloc>().add(
                                        OnGoingRideOnTapEvent(
                                            selectedIndex: index));
                                  },
                                  child: SizedBox(
                                    child: Column(
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.all(size.width * 0.02),
                                          width: size.width * 0.9,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColorDark
                                                  .withOpacity(0.1),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                      size.width * 0.02),
                                                  topRight: Radius.circular(
                                                      size.width * 0.02)),
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .dividerColor)),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      MyText(
                                                          text: ride
                                                              .requestNumber
                                                              .toString(),
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                      MyText(
                                                          text: (ride.acceptedAt !=
                                                                      "" &&
                                                                  ride.isDriverArrived ==
                                                                      0)
                                                              ? AppLocalizations.of(
                                                                      context)!
                                                                  .accepted
                                                              : (ride.isDriverArrived ==
                                                                          1 &&
                                                                      ride.isTripStart ==
                                                                          0)
                                                                  ? AppLocalizations.of(
                                                                          context)!
                                                                      .arrived
                                                                  : (ride.isCompleted ==
                                                                          1)
                                                                      ? AppLocalizations.of(context)!
                                                                          .completed
                                                                      : AppLocalizations.of(
                                                                              context)!
                                                                          .tripStarted,
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: (ride.acceptedAt !=
                                                                                "" &&
                                                                            ride.isDriverArrived ==
                                                                                0)
                                                                        ? Theme.of(context)
                                                                            .primaryColorLight
                                                                        : (ride.isDriverArrived == 1 &&
                                                                                ride.isTripStart == 0)
                                                                            ? Theme.of(context).primaryColor
                                                                            : AppColors.green,
                                                                  )),
                                                      MyText(
                                                          text: ride
                                                              .paymentTypeString
                                                              .toString(),
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      MyText(
                                                          text:
                                                              'OTP - ${ride.rideOtp}',
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                      MyText(
                                                          text:
                                                              '${ride.creatededAtWithDate} ${ride.cvCreatedAt}'
                                                                  .toString(),
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor
                                                                      .withOpacity(
                                                                          0.5))),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                  height: size.width * 0.02),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const PickupIcon(),
                                                  Expanded(
                                                    child: MyText(
                                                      text: ride.pickAddress,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                  height: size.height * 0.02),
                                              if(ride.dropAddress.isNotEmpty)    
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const DropIcon(),
                                                  Expanded(
                                                    child: MyText(
                                                      text: ride.dropAddress,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.all(size.width * 0.02),
                                          width: size.width * 0.9,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .dividerColor),
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                      size.width * 0.02),
                                                  bottomRight: Radius.circular(
                                                      size.width * 0.02))),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl: ride
                                                          .driverDetail
                                                          .data
                                                          .profilePicture,
                                                      height: size.width * 0.11,
                                                      width: size.width * 0.11,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              const Center(
                                                        child: Loader(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Center(
                                                              child: Icon(
                                                        Icons.person,
                                                        size: 25,
                                                      )),
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            size.width * 0.03),
                                                    Expanded(
                                                      child: MyText(
                                                        text: ride.driverDetail
                                                            .data.name,
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  MyText(
                                                    text: ride.driverDetail.data
                                                        .carNumber,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                  MyText(
                                                    text: ride.driverDetail.data
                                                        .vehicleTypeName
                                                        .toString(),
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ],
                                              )),
                                              SizedBox(
                                                  width: size.width * 0.02),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: size.width * 0.03)
                                      ],
                                    ),
                                  ),
                                );
                              }),
                ),
              )),
            );
          },
        ),
      ),
    );
  }
}
