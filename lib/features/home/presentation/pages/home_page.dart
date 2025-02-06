// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart' as fmlt;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restart_tagxi/core/utils/custom_button.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import '../../../../common/pickup_icon.dart';
import '../../../../core/utils/custom_divider.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_navigation_icon.dart';
import '../../../account/presentation/pages/account_page.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../../bookingpage/presentation/page/booking_page.dart';
import '../../../bookingpage/presentation/page/trip_summary_page.dart';
import '../../application/home_bloc.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../domain/models/stop_address_model.dart';
import '../../domain/models/user_details_model.dart';
import '../widgets/home_on_going_rides.dart';
import '../widgets/home_page_shimmer.dart';
import '../widgets/send_receive_delivery.dart';
import 'confirm_location_page.dart';
import 'destination_page.dart';
import 'on_going_rides.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/homePage';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // && Platform.isAndroid
    if (state == AppLifecycleState.paused) {
      if (HomeBloc().nearByVechileSubscription != null) {
        HomeBloc().nearByVechileSubscription?.pause();
      }
    }
    if (state == AppLifecycleState.resumed) {
      if (HomeBloc().nearByVechileSubscription != null) {
        HomeBloc().nearByVechileSubscription?.resume();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addObserver(this);
    HomeBloc().nearByVechileCheckStream(context, this);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return builderWidget(size);
  }

  Widget builderWidget(Size size) {
    return BlocProvider(
      create: (context) => HomeBloc()
        ..add(GetDirectionEvent())
        ..add(GetUserDetailsEvent()),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          if (state is HomeInitialState) {
            CustomLoader.loader(context);
          } else if (state is HomeLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is HomeLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is VechileStreamMarkerState) {
            context.read<HomeBloc>().nearByVechileCheckStream(context, this);
          } else if (state is LogoutState) {
            if (context.read<HomeBloc>().nearByVechileSubscription != null) {
              context.read<HomeBloc>().nearByVechileSubscription?.cancel();
              context.read<HomeBloc>().nearByVechileSubscription = null;
            }
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          } else if (state is GetLocationPermissionState) {
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                          alignment:
                              context.read<HomeBloc>().textDirection == 'rtl'
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.cancel_outlined,
                                  color: Theme.of(context).primaryColor))),
                      MyText(
                          text: AppLocalizations.of(context)!.locationAccess,
                          maxLines: 4),
                    ],
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            await openAppSettings();
                          },
                          child: MyText(
                              text: AppLocalizations.of(context)!.openSetting,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor)),
                        ),
                        InkWell(
                          onTap: () async {
                            PermissionStatus status =
                                await Permission.location.status;
                            if (status.isGranted || status.isLimited) {
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              context.read<HomeBloc>().add(LocateMeEvent(
                                  mapType: context.read<HomeBloc>().mapType));
                            } else {
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            }
                          },
                          child: MyText(
                              text: AppLocalizations.of(context)!.done,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor)),
                        ),
                      ],
                    )
                  ],
                );
              },
            );
          } else if (state is NavigateToOnGoingRidesPageState) {
            Navigator.pushNamed(context, OnGoingRidesPage.routeName,
                    arguments: OnGoingRidesPageArguments(
                        userData: context.read<HomeBloc>().userData!,
                        mapType: context.read<HomeBloc>().mapType))
                .then(
              (value) {
                if (!context.mounted) return;
                context.read<HomeBloc>().add(GetUserDetailsEvent());
              },
            );
          } else if (state is UserOnTripState &&
              state.tripData.acceptedAt == '') {
            if (context.read<HomeBloc>().nearByVechileSubscription != null) {
              context.read<HomeBloc>().nearByVechileSubscription?.cancel();
              context.read<HomeBloc>().nearByVechileSubscription = null;
            }
            Navigator.pushNamedAndRemoveUntil(
              context,
              BookingPage.routeName,
              (route) => false,
              arguments: BookingPageArguments(
                  picklat: state.tripData.pickLat,
                  picklng: state.tripData.pickLng,
                  droplat: state.tripData.dropLat,
                  droplng: state.tripData.dropLng,
                  pickupAddressList: context.read<HomeBloc>().pickupAddressList,
                  stopAddressList: context.read<HomeBloc>().stopAddressList,
                  userData: context.read<HomeBloc>().userData!,
                  transportType: state.tripData.transportType,
                  polyString: state.tripData.polyLine,
                  distance: (double.parse(state.tripData.totalDistance) * 1000)
                      .toString(),
                  duration: state.tripData.totalTime.toString(),
                  isRentalRide: state.tripData.isRental,
                  isWithoutDestinationRide: ((state.tripData.dropLat.isEmpty &&
                              state.tripData.dropLng.isEmpty) &&
                          !state.tripData.isRental)
                      ? true
                      : false,
                  isOutstationRide: state.tripData.isOutStation == "1",
                  mapType: context.read<HomeBloc>().mapType),
            );
          } else if (state is DeliverySelectState) {
            final homeBloc = context.read<HomeBloc>();
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: false,
              isScrollControlled: true,
              builder: (_) {
                return BlocProvider.value(
                  value: homeBloc,
                  child: const SendOrReceiveDelivery(),
                );
              },
            );
          } else if (state is DestinationSelectState) {
            Navigator.pushNamed(
              context,
              DestinationPage.routeName,
              arguments: DestinationPageArguments(
                  title: context.read<HomeBloc>().selectedServiceType == 0
                      ? 'Taxi'
                      : 'Delivery',
                  pickupAddress: context.read<HomeBloc>().currentLocation,
                  pickupLatLng: context.read<HomeBloc>().currentLatLng,
                  dropAddress: state.dropAddress,
                  dropLatLng: state.dropLatLng,
                  userData: context.read<HomeBloc>().userData!,
                  pickUpChange: state.isPickupChange,
                  transportType:
                      context.read<HomeBloc>().selectedServiceType == 0
                          ? 'taxi'
                          : 'delivery',
                  isOutstationRide: false,
                  mapType: context.read<HomeBloc>().mapType),
            );
          } else if (state is OutStationSelectState) {
            Navigator.pushNamed(
              context,
              DestinationPage.routeName,
              arguments: DestinationPageArguments(
                  title: context.read<HomeBloc>().selectedServiceType == 0
                      ? 'Taxi'
                      : 'Delivery',
                  pickupAddress: context.read<HomeBloc>().currentLocation,
                  pickupLatLng: context.read<HomeBloc>().currentLatLng,
                  userData: context.read<HomeBloc>().userData!,
                  pickUpChange: false,
                  transportType:
                      context.read<HomeBloc>().selectedServiceType == 0
                          ? 'taxi'
                          : 'delivery',
                  isOutstationRide: true,
                  mapType: context.read<HomeBloc>().mapType),
            );
          } else if (state is RecentSearchPlaceSelectState) {
            context.read<HomeBloc>().add(ServiceLocationVerifyEvent(
                address: [state.address], rideType: state.transportType));
          } else if (state is ConfirmRideAddressState) {
            if (context.read<HomeBloc>().nearByVechileSubscription != null) {
              context.read<HomeBloc>().nearByVechileSubscription?.cancel();
              context.read<HomeBloc>().nearByVechileSubscription = null;
            }
            if (context.read<HomeBloc>().pickupAddressList.isNotEmpty &&
                context.read<HomeBloc>().stopAddressList.length == 1) {
              Navigator.pushNamed(
                context,
                BookingPage.routeName,
                arguments: BookingPageArguments(
                    picklat: context
                        .read<HomeBloc>()
                        .pickupAddressList
                        .first
                        .lat
                        .toString(),
                    picklng: context
                        .read<HomeBloc>()
                        .pickupAddressList
                        .first
                        .lng
                        .toString(),
                    droplat: context
                        .read<HomeBloc>()
                        .stopAddressList
                        .last
                        .lat
                        .toString(),
                    droplng: context
                        .read<HomeBloc>()
                        .stopAddressList
                        .last
                        .lng
                        .toString(),
                    userData: context.read<HomeBloc>().userData!,
                    transportType:
                        context.read<HomeBloc>().selectedServiceType == 0
                            ? 'taxi'
                            : 'delivery',
                    pickupAddressList:
                        context.read<HomeBloc>().pickupAddressList,
                    stopAddressList: context.read<HomeBloc>().stopAddressList,
                    polyString: '',
                    distance: '',
                    duration: '',
                    isOutstationRide: false,
                    mapType: context.read<HomeBloc>().mapType),
              );
            } else {
              context.read<HomeBloc>().stopAddressList.clear();
            }
          } else if (state is RentalSelectState) {
            Navigator.pushNamed(context, ConfirmLocationPage.routeName,
                    arguments: ConfirmLocationPageArguments(
                        userData: context.read<HomeBloc>().userData!,
                        isPickupEdit: true,
                        isEditAddress: false,
                        mapType: context.read<HomeBloc>().mapType,
                        transportType: ''))
                .then(
              (value) {
                if (!context.mounted) return;
                if (value != null) {
                  if (context.read<HomeBloc>().nearByVechileSubscription !=
                      null) {
                    context
                        .read<HomeBloc>()
                        .nearByVechileSubscription
                        ?.cancel();
                    context.read<HomeBloc>().nearByVechileSubscription = null;
                  }
                  context.read<HomeBloc>().pickupAddressList.clear();
                  final add = value as AddressModel;
                  context.read<HomeBloc>().pickupAddressList.add(add);
                  Navigator.pushNamed(
                    context,
                    BookingPage.routeName,
                    arguments: BookingPageArguments(
                        picklat: context
                            .read<HomeBloc>()
                            .pickupAddressList[0]
                            .lat
                            .toString(),
                        picklng: context
                            .read<HomeBloc>()
                            .pickupAddressList[0]
                            .lng
                            .toString(),
                        droplat: '',
                        droplng: '',
                        userData: context.read<HomeBloc>().userData!,
                        transportType: '',
                        pickupAddressList:
                            context.read<HomeBloc>().pickupAddressList,
                        stopAddressList: [],
                        polyString: '',
                        distance: '',
                        duration: '',
                        mapType: context.read<HomeBloc>().mapType,
                        isOutstationRide: false,
                        isRentalRide: true),
                  );
                }
              },
            );
          } else if (state is RideWithoutDestinationState) {
            Navigator.pushNamed(context, ConfirmLocationPage.routeName,
                    arguments: ConfirmLocationPageArguments(
                        userData: context.read<HomeBloc>().userData!,
                        isPickupEdit: true,
                        isEditAddress: false,
                        mapType: context.read<HomeBloc>().mapType,
                        transportType: ''))
                .then(
              (value) {
                if (!context.mounted) return;
                if (value != null) {
                  if (context.read<HomeBloc>().nearByVechileSubscription !=
                      null) {
                    context
                        .read<HomeBloc>()
                        .nearByVechileSubscription
                        ?.cancel();
                    context.read<HomeBloc>().nearByVechileSubscription = null;
                  }
                  context.read<HomeBloc>().pickupAddressList.clear();
                  final add = value as AddressModel;
                  context.read<HomeBloc>().pickupAddressList.add(add);
                  Navigator.pushNamed(
                    context,
                    BookingPage.routeName,
                    arguments: BookingPageArguments(
                        picklat: context
                            .read<HomeBloc>()
                            .pickupAddressList[0]
                            .lat
                            .toString(),
                        picklng: context
                            .read<HomeBloc>()
                            .pickupAddressList[0]
                            .lng
                            .toString(),
                        droplat: '',
                        droplng: '',
                        userData: context.read<HomeBloc>().userData!,
                        transportType: 'taxi',
                        pickupAddressList:
                            context.read<HomeBloc>().pickupAddressList,
                        stopAddressList: [],
                        polyString: '',
                        distance: '',
                        duration: '',
                        mapType: context.read<HomeBloc>().mapType,
                        isRentalRide: false,
                        isOutstationRide: false,
                        isWithoutDestinationRide: true),
                  );
                }
              },
            );
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
                    userData: context.read<HomeBloc>().userData!,
                    transportType: state.tripData.transportType,
                    polyString: state.tripData.polyLine,
                    distance: state.tripData.totalDistance,
                    duration: state.tripData.totalTime.toString(),
                    requestId: state.tripData.id,
                    mapType: context.read<HomeBloc>().mapType,
                    isOutstationRide: state.tripData.isOutStation == "1"));
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
          } else if (state is ServiceNotAvailableState) {
            context.read<HomeBloc>().stopAddressList.clear();
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                          alignment:
                              context.read<HomeBloc>().textDirection == 'rtl'
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.cancel_outlined,
                                  color: Theme.of(context).primaryColor))),
                      Center(
                        child: MyText(
                            text: state.message,
                            // AppLocalizations.of(context)!.serviceNotAvailable,
                            maxLines: 4),
                      ),
                    ],
                  ),
                  actions: [
                    Center(
                      child: CustomButton(
                        buttonName: AppLocalizations.of(context)!.okText,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                );
              },
            );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (context.read<HomeBloc>().mapType == 'google_map') {
              if (Theme.of(context).brightness == Brightness.dark) {
                if (context.read<HomeBloc>().googleMapController != null) {
                  if (context.mounted) {
                    context
                        .read<HomeBloc>()
                        .googleMapController!
                        .setMapStyle(context.read<HomeBloc>().darkMapString);
                  }
                }
              } else {
                if (context.read<HomeBloc>().googleMapController != null) {
                  if (context.mounted) {
                    context
                        .read<HomeBloc>()
                        .googleMapController!
                        .setMapStyle(context.read<HomeBloc>().lightMapString);
                  }
                }
              }
            }

            return PopScope(
              canPop: true,
              child: Directionality(
                textDirection: context.read<HomeBloc>().textDirection == 'rtl'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Scaffold(
                  body: (context.read<HomeBloc>().userData != null &&
                          ((context.read<HomeBloc>().userData!.onTripRequest ==
                                      null ||
                                  context
                                          .read<HomeBloc>()
                                          .userData!
                                          .onTripRequest ==
                                      "") ||
                              (context.read<HomeBloc>().userData!.metaRequest ==
                                      null ||
                                  context
                                          .read<HomeBloc>()
                                          .userData!
                                          .metaRequest ==
                                      "")))
                      ? bodyMapBuilder(context, size)
                      : HomePageShimmer(size: size),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget bottomSheetBuilder(Size size, BuildContext context) {
    return BlocProvider.value(
        value: context.read<HomeBloc>(),
        child: Container(
          height: size.height,
          margin: const EdgeInsets.only(top: 1),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 1,
                  color: Theme.of(context).shadowColor)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.width * 0.03),
              Center(
                  child: CustomDivider(
                      height: 5,
                      width: size.width * 0.2,
                      color: Theme.of(context).dividerColor.withOpacity(0.4))),
              SizedBox(height: size.width * 0.02),
              recentSearchPlaces(size, context),
              SizedBox(height: size.width * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (context.read<HomeBloc>().isSheetAtTop == true &&
                      context.read<HomeBloc>().userData != null &&
                      context
                          .read<HomeBloc>()
                          .userData!
                          .bannerImage
                          .data
                          .isNotEmpty) ...[
                    SizedBox(height: size.width * 0.025),
                    bannerWidget(context, size),
                  ],
                ],
              ),
              SizedBox(height: size.width * 0.1),
              Expanded(
                  child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.bottomBackground),
                    fit: BoxFit.cover,
                  ),
                ),
              ))
            ],
          ),
        ));
  }

  Widget recentSearchPlaces(Size size, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // Access the current sheetSize directly from HomeBloc
          double sheetSize = context.read<HomeBloc>().sheetSize;
          double maxSheetSize = context.read<HomeBloc>().maxChildSize;
          double recentSearchWidth =
              sheetSize == maxSheetSize ? size.width * 0.9 : size.width * 0.9;
          return Container(
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  right: size.width * 0.0,
                  left: size.width * 0,
                  top: size.width * 0.020,
                  bottom: size.width * 0.020),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: size.width * 0.02),
                      if (context.read<HomeBloc>().isSheetAtTop)
                        Flexible(
                          child: NavigationIconWidget(
                            icon: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                        context, AccountPage.routeName,
                                        arguments: AccountPageArguments(
                                            userData: context
                                                .read<HomeBloc>()
                                                .userData!))
                                    .then((value) {
                                  if (!context.mounted) return;
                                  context
                                      .read<HomeBloc>()
                                      .add(GetDirectionEvent());
                                  if (value != null) {
                                    context.read<HomeBloc>().userData =
                                        value as UserDetail;
                                    context.read<HomeBloc>().add(UpdateEvent());
                                  }
                                });
                              },
                              child: Icon(
                                Icons.menu,
                                size: 20,
                                color: Theme.of(context).primaryColorDark,
                              ),
                            ),
                            isShadowWidget: true,
                          ),
                        ),
                      if (context.read<HomeBloc>().isSheetAtTop)
                        SizedBox(width: size.width * 0.02),
                      Flexible(
                        flex: context
                            .read<HomeBloc>()
                            .calculateResponsiveFlex(size.width),
                        child: InkWell(
                          onTap: () {
                            if (context
                                        .read<HomeBloc>()
                                        .userData!
                                        .enableModulesForApplications ==
                                    'both' ||
                                context
                                        .read<HomeBloc>()
                                        .userData!
                                        .enableModulesForApplications ==
                                    'taxi') {
                              context.read<HomeBloc>().add(
                                  DestinationSelectEvent(
                                      isPickupChange: false));
                            } else {
                              context.read<HomeBloc>().add(
                                  ServiceTypeChangeEvent(serviceTypeIndex: 1));
                            }
                          },
                          child: AnimatedContainer(
                            transformAlignment: Alignment.centerRight,
                            duration: const Duration(milliseconds: 100),
                            width: recentSearchWidth,
                            padding: EdgeInsets.all(size.width * 0.02),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: size.width * 0.075,
                                  height: size.width * 0.075,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.3),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.search,
                                    size: 20,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                ),
                                SizedBox(width: size.width * 0.02),
                                Expanded(
                                  // Place Expanded inside Row to prevent overflow here
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .whereAreYouGoing,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .disabledColor
                                              .withOpacity(0.5),
                                        ),
                                  ),
                                ),
                                if (context.read<HomeBloc>().userData != null &&
                                    (context
                                            .read<HomeBloc>()
                                            .userData!
                                            .showRideWithoutDestination ==
                                        "1") &&
                                    (context
                                                .read<HomeBloc>()
                                                .userData!
                                                .enableModulesForApplications ==
                                            'taxi' ||
                                        context
                                                .read<HomeBloc>()
                                                .userData!
                                                .enableModulesForApplications ==
                                            'both'))
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<HomeBloc>()
                                          .add(RideWithoutDestinationEvent());
                                    },
                                    child: Container(
                                      height: size.width * 0.075,
                                      alignment: Alignment.center,
                                      child: MyText(
                                        text:
                                            AppLocalizations.of(context)!.skip,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .disabledColor
                                                  .withOpacity(0.5),
                                            ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (context.read<HomeBloc>().isSheetAtTop == false &&
                      context.read<HomeBloc>().userData != null &&
                      context
                          .read<HomeBloc>()
                          .userData!
                          .bannerImage
                          .data
                          .isNotEmpty) ...[
                    SizedBox(height: size.width * 0.025),
                    bannerWidget(context, size),
                  ],
                  if (context.read<HomeBloc>().userData != null &&
                      ((context
                                  .read<HomeBloc>()
                                  .userData!
                                  .enableModulesForApplications ==
                              'both') ||
                          (context
                                      .read<HomeBloc>()
                                      .userData!
                                      .enableModulesForApplications ==
                                  'taxi' &&
                              context
                                  .read<HomeBloc>()
                                  .userData!
                                  .showRentalRide) ||
                          (context
                                      .read<HomeBloc>()
                                      .userData!
                                      .enableModulesForApplications ==
                                  'delivery' &&
                              context
                                  .read<HomeBloc>()
                                  .userData!
                                  .showRentalRide)))
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: servicesWidget(context, size),
                    ),
                  if (context.read<HomeBloc>().isMultipleRide) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                              text: AppLocalizations.of(context)!.onGoingRides,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).primaryColorDark)),
                        ],
                      ),
                    ),
                    SizedBox(height: size.width * 0.01),
                    onGoingRides(context, size),
                  ],
                  if (context
                      .read<HomeBloc>()
                      .recentSearchPlaces
                      .isNotEmpty) ...[
                    SizedBox(
                        height: context.read<HomeBloc>().isSheetAtTop == false
                            ? size.width * 0.01
                            : size.width * 0.02),
                    ListView.builder(
                      itemCount:
                          context.read<HomeBloc>().recentSearchPlaces.length > 2
                              ? 2
                              : context
                                  .read<HomeBloc>()
                                  .recentSearchPlaces
                                  .length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final recentPlace = context
                            .read<HomeBloc>()
                            .recentSearchPlaces
                            .reversed
                            .elementAt(index);
                        return InkWell(
                          onTap: () {
                            if (context
                                .read<HomeBloc>()
                                .pickupAddressList
                                .isNotEmpty) {
                              if (context
                                          .read<HomeBloc>()
                                          .userData!
                                          .enableModulesForApplications ==
                                      'both' ||
                                  context
                                          .read<HomeBloc>()
                                          .userData!
                                          .enableModulesForApplications ==
                                      'taxi') {
                                context.read<HomeBloc>().add(
                                    RecentSearchPlaceSelectEvent(
                                        address: recentPlace,
                                        isPickupSelect: false,
                                        transportType: 'taxi'));
                              } else {
                                context.read<HomeBloc>().add(
                                    ServiceTypeChangeEvent(
                                        serviceTypeIndex: 1));
                              }
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                height: size.height * 0.075,
                                width: size.width * 0.075,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.history,
                                  size: 18,
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.75),
                                ),
                              ),
                              SizedBox(width: size.width * 0.025),
                              SizedBox(
                                width: size.width * 0.63,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MyText(
                                      text: recentPlace.address.split(',')[0],
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      maxLines: 1,
                                    ),
                                    MyText(
                                      text: recentPlace.address,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color:
                                                Theme.of(context).disabledColor,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget bodyMapBuilder(BuildContext context, Size size) {
    final screenWidth = size.width;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Stack(
          children: [
            // The map and other widgets
            SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                children: [
                  Stack(
                    children: [
                      (context.read<HomeBloc>().mapType == 'google_map')
                          // GOOGLE MAP
                          ? SizedBox(
                              height: size.height,
                              width: size.width,
                              child: GoogleMap(
                                gestureRecognizers: {
                                  Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer(),
                                  ),
                                },
                                onMapCreated: (GoogleMapController controller) {
                                  if (context
                                          .read<HomeBloc>()
                                          .googleMapController ==
                                      null) {
                                    context.read<HomeBloc>().add(
                                        GoogleControllAssignEvent(
                                            controller: controller,
                                            isFromHomePage: true,
                                            isEditAddress: false,
                                            latlng: context
                                                .read<HomeBloc>()
                                                .currentLatLng));
                                  } else {
                                    context.read<HomeBloc>().add(LocateMeEvent(
                                        mapType:
                                            context.read<HomeBloc>().mapType));
                                  }
                                },
                                padding: EdgeInsets.only(
                                    bottom: screenWidth + size.width * 0.01),
                                initialCameraPosition: CameraPosition(
                                  target:
                                      context.read<HomeBloc>().currentLatLng,
                                  zoom: 15.0,
                                ),
                                onTap: (argument) {
                                  context.read<HomeBloc>().currentLatLng =
                                      argument;
                                  if (context
                                          .read<HomeBloc>()
                                          .googleMapController !=
                                      null) {
                                    context
                                        .read<HomeBloc>()
                                        .googleMapController!
                                        .animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                    target: argument,
                                                    zoom: 15)));
                                  }
                                },
                                onCameraMoveStarted: () {
                                  context
                                      .read<HomeBloc>()
                                      .isCameraMoveComplete = true;
                                },
                                onCameraMove: (CameraPosition? position) {
                                  if (position != null) {
                                    if (!context.mounted) return;
                                    context.read<HomeBloc>().currentLatLng =
                                        position.target;
                                  }
                                },
                                onCameraIdle: () {
                                  if (context
                                      .read<HomeBloc>()
                                      .isCameraMoveComplete) {
                                    if (context
                                        .read<HomeBloc>()
                                        .pickupAddressList
                                        .isEmpty) {
                                      context.read<HomeBloc>().add(
                                          UpdateLocationEvent(
                                              isFromHomePage: true,
                                              latLng: context
                                                  .read<HomeBloc>()
                                                  .currentLatLng,
                                              mapType: context
                                                  .read<HomeBloc>()
                                                  .mapType));
                                    } else {
                                      context
                                          .read<HomeBloc>()
                                          .confirmPinAddress = true;
                                      context
                                          .read<HomeBloc>()
                                          .add(UpdateEvent());
                                    }
                                  }
                                },
                                markers: context
                                        .read<HomeBloc>()
                                        .markerList
                                        .isNotEmpty
                                    ? Set.from(
                                        context.read<HomeBloc>().markerList)
                                    : {},
                                minMaxZoomPreference:
                                    const MinMaxZoomPreference(13, 20),
                                buildingsEnabled: false,
                                zoomControlsEnabled: false,
                                compassEnabled: false,
                                mapToolbarEnabled: false,
                                myLocationEnabled: true,
                                myLocationButtonEnabled: false,
                              ),
                            ) // OPEN STREET MAP
                          : SizedBox(
                              height: size.height * 0.55,
                              width: size.width,
                              child: fm.FlutterMap(
                                mapController:
                                    context.read<HomeBloc>().fmController,
                                options: fm.MapOptions(
                                  onTap: (tapPosition, latLng) {
                                    context.read<HomeBloc>().currentLatLng =
                                        LatLng(
                                            latLng.latitude, latLng.longitude);
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (context
                                              .read<HomeBloc>()
                                              .fmController !=
                                          null) {
                                        context
                                            .read<HomeBloc>()
                                            .fmController!
                                            .move(latLng, 15);
                                      }
                                    });
                                    context.read<HomeBloc>().add(
                                        UpdateLocationEvent(
                                            isFromHomePage: true,
                                            latLng: context
                                                .read<HomeBloc>()
                                                .currentLatLng,
                                            mapType: context
                                                .read<HomeBloc>()
                                                .mapType));
                                  },
                                  onMapEvent: (v) async {
                                    if (v.source ==
                                        fm.MapEventSource
                                            .nonRotatedSizeChange) {
                                      context.read<HomeBloc>().fmLatLng =
                                          fmlt.LatLng(v.camera.center.latitude,
                                              v.camera.center.longitude);
                                      context.read<HomeBloc>().currentLatLng =
                                          LatLng(v.camera.center.latitude,
                                              v.camera.center.longitude);
                                      context.read<HomeBloc>().add(
                                          UpdateLocationEvent(
                                              isFromHomePage: true,
                                              latLng: context
                                                  .read<HomeBloc>()
                                                  .currentLatLng,
                                              mapType: context
                                                  .read<HomeBloc>()
                                                  .mapType));
                                      // context.read<HomeBloc>().add(
                                      //     UpdateMarkerEvent(
                                      //         fmLatLng: context
                                      //             .read<HomeBloc>()
                                      //             .fmLatLng));
                                    }
                                    if (v.source == fm.MapEventSource.onDrag) {
                                      context.read<HomeBloc>().currentLatLng =
                                          LatLng(v.camera.center.latitude,
                                              v.camera.center.longitude);
                                      context
                                          .read<HomeBloc>()
                                          .add(UpdateEvent());
                                    }
                                    if (v.source == fm.MapEventSource.dragEnd) {
                                      context.read<HomeBloc>().add(
                                          UpdateLocationEvent(
                                              isFromHomePage: true,
                                              latLng: LatLng(
                                                  v.camera.center.latitude,
                                                  v.camera.center.longitude),
                                              mapType: context
                                                  .read<HomeBloc>()
                                                  .mapType));
                                    }
                                  },
                                  onPositionChanged: (p, l) async {
                                    if (l == false) {
                                      context.read<HomeBloc>().currentLatLng =
                                          LatLng(p.center.latitude,
                                              p.center.longitude);
                                      context
                                          .read<HomeBloc>()
                                          .add(UpdateEvent());
                                    }
                                  },
                                  initialCenter: fmlt.LatLng(
                                      context
                                          .read<HomeBloc>()
                                          .currentLatLng
                                          .latitude,
                                      context
                                          .read<HomeBloc>()
                                          .currentLatLng
                                          .longitude),
                                  initialZoom: 16,
                                  minZoom: 13,
                                  maxZoom: 20,
                                ),
                                children: [
                                  fm.TileLayer(
                                    // minZoom: 10,
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.example.app',
                                  ),
                                  fm.MarkerLayer(
                                    markers: context
                                        .read<HomeBloc>()
                                        .markerList
                                        .asMap()
                                        .map(
                                          (k, value) {
                                            final marker = context
                                                .read<HomeBloc>()
                                                .markerList
                                                .elementAt(k);
                                            return MapEntry(
                                              k,
                                              fm.Marker(
                                                alignment: Alignment.topCenter,
                                                point: fmlt.LatLng(
                                                    marker.position.latitude,
                                                    marker.position.longitude),
                                                child: RotationTransition(
                                                  turns: AlwaysStoppedAnimation(
                                                      marker.rotation / 360),
                                                  child: Image.asset(
                                                    (marker.markerId.value
                                                            .toString()
                                                            .contains('truck'))
                                                        ? AppImages.truck
                                                        : marker.markerId.value
                                                                .toString()
                                                                .contains(
                                                                    'motor_bike')
                                                            ? AppImages.bike
                                                            : marker.markerId
                                                                    .value
                                                                    .toString()
                                                                    .contains(
                                                                        'auto')
                                                                ? AppImages.auto
                                                                : marker.markerId
                                                                        .value
                                                                        .toString()
                                                                        .contains(
                                                                            'lcv')
                                                                    ? AppImages
                                                                        .lcv
                                                                    : marker.markerId
                                                                            .value
                                                                            .toString()
                                                                            .contains(
                                                                                'ehcv')
                                                                        ? AppImages
                                                                            .ehcv
                                                                        : marker.markerId.value.toString().contains('hatchback')
                                                                            ? AppImages.hatchBack
                                                                            : marker.markerId.value.toString().contains('hcv')
                                                                                ? AppImages.hcv
                                                                                : marker.markerId.value.toString().contains('mcv')
                                                                                    ? AppImages.mcv
                                                                                    : marker.markerId.value.toString().contains('luxury')
                                                                                        ? AppImages.luxury
                                                                                        : marker.markerId.value.toString().contains('premium')
                                                                                            ? AppImages.premium
                                                                                            : marker.markerId.value.toString().contains('suv')
                                                                                                ? AppImages.suv
                                                                                                : AppImages.car,
                                                    width: 16,
                                                    height: 25,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                        .values
                                        .toList(),
                                  ),
                                  const fm.RichAttributionWidget(
                                    attributions: [],
                                  ),
                                ],
                              ),
                            ),
                      // Marker in the center of the screen
                      Positioned(
                        child: Container(
                          height: size.height * 0.8,
                          width: size.width * 1,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: screenWidth * 0.6 + size.width * 0.06),
                            child: Image.asset(
                              AppImages.pickupIcon,
                              width: size.width * 0.08,
                              height: size.width * 0.08,
                            ),
                          ),
                        ),
                      ),
                      if (context.read<HomeBloc>().confirmPinAddress)
                      Positioned(
                        top: screenWidth * 0.1,
                        right: screenWidth * 0.38,
                        child: Container(
                          height: size.height * 0.8,
                          alignment: Alignment.center,
                          child: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      screenWidth * 0.6 + size.width * 0.06),
                              child: Row(
                                children: [
                                  CustomButton(
                                      height: size.width * 0.08,
                                      width: size.width * 0.25,
                                      onTap: () {
                                        context
                                            .read<HomeBloc>()
                                            .confirmPinAddress = false;
                                        context.read<HomeBloc>().add(
                                            UpdateLocationEvent(
                                                isFromHomePage: true,
                                                latLng: context
                                                    .read<HomeBloc>()
                                                    .currentLatLng,
                                                mapType: context
                                                    .read<HomeBloc>()
                                                    .mapType));
                                      },
                                      textSize: 12,
                                      buttonName:
                                          AppLocalizations.of(context)!
                                              .confirm)
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Locate Me
            Positioned(
              bottom: size.height * 0.5,
              right: size.width * 0.03,
              child: InkWell(
                onTap: () {
                  context.read<HomeBloc>().confirmPinAddress = false;
                  context.read<HomeBloc>().add(
                      LocateMeEvent(mapType: context.read<HomeBloc>().mapType));
                },
                child: Container(
                  height: size.width * 0.11,
                  width: size.width * 0.11,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    border: Border.all(
                      width: 1.2,
                      color: AppColors.black.withOpacity(0.8),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.my_location,
                      size: size.width * 0.05,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ),
            //Navigation and location bar
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    NavigationIconWidget(
                      icon: InkWell(
                        onTap: () {
                          if (context.read<HomeBloc>().userData != null) {
                            Navigator.pushNamed(context, AccountPage.routeName,
                                    arguments: AccountPageArguments(
                                        userData:
                                            context.read<HomeBloc>().userData!))
                                .then(
                              (value) {
                                if (!context.mounted) return;
                                context
                                    .read<HomeBloc>()
                                    .add(GetDirectionEvent());
                                if (value != null) {
                                  context.read<HomeBloc>().userData =
                                      value as UserDetail;
                                  context.read<HomeBloc>().add(UpdateEvent());
                                }
                              },
                            );
                          }
                        },
                        child: Icon(Icons.menu,
                            size: 20,
                            color: Theme.of(context).primaryColorDark),
                      ),
                      isShadowWidget: true,
                    ),
                    SizedBox(width: size.width * 0.03),
                    InkWell(
                      onTap: () {
                        if (context
                                    .read<HomeBloc>()
                                    .userData!
                                    .enableModulesForApplications ==
                                'both' ||
                            context
                                    .read<HomeBloc>()
                                    .userData!
                                    .enableModulesForApplications ==
                                'taxi') {
                          context.read<HomeBloc>().add(
                              DestinationSelectEvent(isPickupChange: true));
                        } else {
                          context
                              .read<HomeBloc>()
                              .add(ServiceTypeChangeEvent(serviceTypeIndex: 1));
                        }
                      },
                      child: Container(
                        width: size.width * 0.78,
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 3,
                                  spreadRadius: 2,
                                  color: Theme.of(context).shadowColor)
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 6),
                          child: Row(
                            children: [
                              const PickupIcon(),
                              SizedBox(width: size.width * 0.01),
                              SizedBox(
                                width: size.width * 0.63,
                                child: MyText(
                                    text: context
                                        .read<HomeBloc>()
                                        .currentLocation,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Icon(Icons.edit_outlined,
                                  size: 18,
                                  color: Theme.of(context).disabledColor),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  double sheetSize = context.read<HomeBloc>().sheetSize;
                  double minChildSize =
                      context.read<HomeBloc>().minChildSize; // Bottom
                  double midChildSize =
                      context.read<HomeBloc>().midChildSize; // Midpoint
                  double maxChildSize =
                      context.read<HomeBloc>().maxChildSize; // Top

                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter set) {
                      double currentSize = sheetSize;

                      return GestureDetector(
                        onVerticalDragUpdate: (details) {
                          final dragAmount = details.primaryDelta ?? 0;
                          set(() {
                            currentSize = (currentSize -
                                    dragAmount / context.size!.height)
                                .clamp(minChildSize, maxChildSize);
                          });
                          context
                              .read<HomeBloc>()
                              .add(UpdateScrollPositionEvent(currentSize));
                        },
                        onVerticalDragEnd: (details) {
                          set(() {
                            // If scrolling up, snap to the top or midpoint
                            if (details.velocity.pixelsPerSecond.dy < 0) {
                              currentSize = currentSize >= midChildSize
                                  ? maxChildSize
                                  : midChildSize;
                            }
                            // If scrolling down, skip the midpoint and go directly to the bottom
                            else {
                              currentSize = minChildSize;
                            }
                          });

                          context
                              .read<HomeBloc>()
                              .add(UpdateScrollPositionEvent(currentSize));
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height:
                              MediaQuery.of(context).size.height * currentSize,
                          curve: Curves.easeInOut,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: context.read<HomeBloc>().serviceAvailable 
                              ? bottomSheetBuilder(size, context) 
                              : Column(
                                children: [
                                  Image.asset(
                                    AppImages.noDataFound,
                                    height: size.width * 0.5,
                                    width: size.width),
                                  SizedBox(height: size.width * 0.02),
                                  MyText(text: AppLocalizations.of(context)!.serviceNotAvailable)
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget servicesWidget(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: AppLocalizations.of(context)!.service,
          textStyle: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(height: size.width * 0.025),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if (context.read<HomeBloc>().userData != null &&
                  (context
                              .read<HomeBloc>()
                              .userData!
                              .enableModulesForApplications ==
                          'taxi' ||
                      context
                              .read<HomeBloc>()
                              .userData!
                              .enableModulesForApplications ==
                          'both'))
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      context
                          .read<HomeBloc>()
                          .add(ServiceTypeChangeEvent(serviceTypeIndex: 0));
                    },
                    child: Container(
                      height: size.width * 0.19,
                      width: size.width * 0.21,
                      decoration: BoxDecoration(
                        color: context.read<HomeBloc>().selectedServiceType == 0
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).splashColor,
                        border: Border.all(
                          color:
                              context.read<HomeBloc>().selectedServiceType == 0
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            context.read<HomeBloc>().serviceTypeImages[0],
                            height: size.width * 0.10,
                          ),
                          const SizedBox(height: 6),
                          MyText(
                            text: AppLocalizations.of(context)!.taxi,
                            textStyle:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (context.read<HomeBloc>().userData != null &&
                  (context
                              .read<HomeBloc>()
                              .userData!
                              .enableModulesForApplications ==
                          'delivery' ||
                      context
                              .read<HomeBloc>()
                              .userData!
                              .enableModulesForApplications ==
                          'both'))
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      context
                          .read<HomeBloc>()
                          .add(ServiceTypeChangeEvent(serviceTypeIndex: 1));
                    },
                    child: Container(
                      height: size.width * 0.19,
                      width: size.width * 0.21,
                      decoration: BoxDecoration(
                        color: context.read<HomeBloc>().selectedServiceType == 1
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).splashColor,
                        border: Border.all(
                          color:
                              context.read<HomeBloc>().selectedServiceType == 1
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            context.read<HomeBloc>().serviceTypeImages[1],
                            height: size.width * 0.10,
                          ),
                          const SizedBox(height: 6),
                          MyText(
                            text: AppLocalizations.of(context)!.delivery,
                            // text: 'Delivery',
                            textStyle:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (context.read<HomeBloc>().userData != null &&
                  (context.read<HomeBloc>().userData!.showRentalRide))
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      context
                          .read<HomeBloc>()
                          .add(ServiceTypeChangeEvent(serviceTypeIndex: 2));
                    },
                    child: Container(
                      height: size.width * 0.19,
                      width: size.width * 0.21,
                      decoration: BoxDecoration(
                        color: context.read<HomeBloc>().selectedServiceType == 2
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).splashColor,
                        border: Border.all(
                          color:
                              context.read<HomeBloc>().selectedServiceType == 2
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            context.read<HomeBloc>().serviceTypeImages[2],
                            height: size.width * 0.11,
                          ),
                          const SizedBox(height: 2),
                          MyText(
                            text: AppLocalizations.of(context)!.rental,
                            textStyle:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (context.read<HomeBloc>().userData != null &&
                  (context
                          .read<HomeBloc>()
                          .userData!
                          .showOutstationRideFeature ==
                      '1'))
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      if (context
                          .read<HomeBloc>()
                          .pickupAddressList
                          .isNotEmpty) {
                        context
                            .read<HomeBloc>()
                            .add(ServiceTypeChangeEvent(serviceTypeIndex: 3));
                      }
                    },
                    child: Container(
                      height: size.width * 0.19,
                      width: size.width * 0.21,
                      decoration: BoxDecoration(
                        color: context.read<HomeBloc>().selectedServiceType == 2
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).splashColor,
                        border: Border.all(
                          color:
                              context.read<HomeBloc>().selectedServiceType == 2
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            context.read<HomeBloc>().serviceTypeImages[3],
                            height: size.width * 0.11,
                          ),
                          const SizedBox(height: 2),
                          MyText(
                            text: AppLocalizations.of(context)!.outStation,
                            textStyle:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget bannerWidget(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.width * 0.01),
        CarouselSlider(
          items: List.generate(
            context.read<HomeBloc>().userData!.bannerImage.data.length,
            (index) {
              return CachedNetworkImage(
                imageUrl: context
                    .read<HomeBloc>()
                    .userData!
                    .bannerImage
                    .data[index]
                    .image,
                // height: size.width * 0.2,
                width: size.width,
                fit: BoxFit.fill,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Text(
                    "",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
          options: CarouselOptions(
            height: size.width * 0.2,
            aspectRatio: 16 / 9,
            viewportFraction: 0.95,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: false,
            autoPlayInterval: const Duration(seconds: 2),
            autoPlayAnimationDuration: const Duration(milliseconds: 300),
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              context.read<HomeBloc>().bannerIndex = index;
              context.read<HomeBloc>().add(UpdateEvent());
            },
          ),
        ),
        SizedBox(height: size.width * 0.025),
        if (context.read<HomeBloc>().userData!.bannerImage.data.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              context.read<HomeBloc>().userData!.bannerImage.data.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    height: size.width * 0.02,
                    width: size.width * 0.02,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.read<HomeBloc>().bannerIndex == index
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColorLight),
                  ),
                );
              },
            ),
          )
      ],
    );
  }
}
