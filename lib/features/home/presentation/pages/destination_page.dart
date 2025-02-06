import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restart_tagxi/common/pickup_icon.dart';
import 'package:restart_tagxi/core/utils/custom_divider.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_navigation_icon.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../account/presentation/pages/fav_location.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../../bookingpage/presentation/page/booking_page.dart';
import '../../application/home_bloc.dart';
import '../../domain/models/stop_address_model.dart';
import '../../domain/models/user_details_model.dart';
import '../widgets/leave_instruction.dart';
import '../widgets/select_contact.dart';
import 'confirm_location_page.dart';

class DestinationPage extends StatefulWidget {
  static const String routeName = '/destinationPage';
  final DestinationPageArguments arg;

  const DestinationPage({super.key, required this.arg});

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return builderWidget(size);
  }

  Widget builderWidget(Size size) {
    return BlocProvider(
      create: (context) => HomeBloc()
        ..add(GetDirectionEvent())
        ..add(DesinationPageInitEvent(arg: widget.arg)),
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
          } else if (state is SelectFromMapState) {
            Navigator.pushNamed(context, ConfirmLocationPage.routeName,
                    arguments: ConfirmLocationPageArguments(
                        userData: widget.arg.userData,
                        isPickupEdit: state.isPickUpEdit,
                        isEditAddress: false,
                        mapType: widget.arg.mapType,
                        transportType: context.read<HomeBloc>().transportType))
                .then(
              (value) {
                if (value != null) {
                  if (!context.mounted) return;
                  final address = value as AddressModel;
                  final homeBloc = context.read<HomeBloc>();
                  if (context.read<HomeBloc>().transportType.toLowerCase() ==
                      'delivery') {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      enableDrag: false,
                      isScrollControlled: true,
                      barrierColor: Theme.of(context).shadowColor,
                      builder: (_) {
                        return BlocProvider.value(
                          value: homeBloc,
                          child: LeaveInstructions(
                            address: address,
                            isReceiveParcel:
                                widget.arg.title == 'Receive Parcel',
                            name: widget.arg.userData.name,
                            number: widget.arg.userData.mobile,
                            transportType: widget.arg.transportType,
                          ),
                        );
                      },
                    );
                  } else {
                    context.read<HomeBloc>().add(AddOrEditStopAddressEvent(
                          isPickUpEdit: state.isPickUpEdit,
                          choosenAddressIndex:
                              context.read<HomeBloc>().choosenAddressIndex,
                          newAddress: address,
                        ));
                  }
                }
              },
            );
          } else if (state is RecentSearchPlaceSelectState) {
            if (context.read<HomeBloc>().transportType.toLowerCase() ==
                'delivery') {
              final homeBloc = context.read<HomeBloc>();
              showModalBottomSheet(
                context: context,
                isDismissible: true,
                enableDrag: true,
                isScrollControlled: true,
                barrierColor: Theme.of(context).shadowColor,
                builder: (_) {
                  return PopScope(
                    canPop: false,
                    child: BlocProvider.value(
                      value: homeBloc,
                      child: LeaveInstructions(
                        address: state.address,
                        isReceiveParcel: widget.arg.title == 'Receive Parcel',
                        name: widget.arg.userData.name,
                        number: widget.arg.userData.mobile,
                        transportType: widget.arg.transportType,
                      ),
                    ),
                  );
                },
              );
            } else {
              context.read<HomeBloc>().addressList[
                  context.read<HomeBloc>().choosenAddressIndex] = state.address;
              context
                  .read<HomeBloc>()
                  .addressTextControllerList[
                      context.read<HomeBloc>().choosenAddressIndex]
                  .text = state.address.address;
              if (!context
                  .read<HomeBloc>()
                  .addressList
                  .any((element) => element.address.isEmpty)) {
                context.read<HomeBloc>().add(ConfirmRideAddressEvent(
                    rideType:widget.arg.isOutstationRide ? 'outstation' : 'taxi',
                    addressList: context.read<HomeBloc>().addressList));
              }
            }
          } else if (state is AddOrEditAddressState) {
            if (!context
                .read<HomeBloc>()
                .addressList
                .any((element) => element.address.isEmpty)) {
              context.read<HomeBloc>().add(ConfirmRideAddressEvent(
                  rideType: widget.arg.isOutstationRide ? 'outstation' : 'taxi',
                  addressList: context.read<HomeBloc>().addressList));
            }
          } else if (state is ReceiverDetailsState) {
            final homeBloc = context.read<HomeBloc>();
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              isScrollControlled: true,
              barrierColor: Theme.of(context).shadowColor,
              builder: (_) {
                return BlocProvider.value(
                  value: homeBloc,
                  child: LeaveInstructions(
                      address: state.address,
                      transportType: widget.arg.transportType,
                      isReceiveParcel: widget.arg.title == 'Receive Parcel',
                      name: widget.arg.userData.name,
                      number: widget.arg.userData.mobile),
                );
              },
            );
          } else if (state is SelectContactDetailsState) {
            final homeBloc = context.read<HomeBloc>();
            context.read<HomeBloc>().isMyself = false;
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              useRootNavigator: true,
              isScrollControlled: true,
              builder: (_) {
                return BlocProvider.value(
                  value: homeBloc,
                  child: const SelectFromContactList(),
                );
              },
            );
          } else if (state is ConfirmRideAddressState) {
            if (context.read<HomeBloc>().nearByVechileSubscription != null) {
              context.read<HomeBloc>().nearByVechileSubscription?.cancel();
              context.read<HomeBloc>().nearByVechileSubscription = null;
            }
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
                  userData: widget.arg.userData,
                  transportType: widget.arg.transportType,
                  pickupAddressList: context.read<HomeBloc>().pickupAddressList,
                  stopAddressList: context.read<HomeBloc>().stopAddressList,
                  title: widget.arg.title,
                  polyString: '',
                  distance: '',
                  duration: '',
                  isOutstationRide: widget.arg.isOutstationRide,
                  mapType: widget.arg.mapType),
            );
          } else if (state is RecentRouteSelectState) {
            if (context.read<HomeBloc>().nearByVechileSubscription != null) {
              context.read<HomeBloc>().nearByVechileSubscription?.cancel();
              context.read<HomeBloc>().nearByVechileSubscription = null;
            }
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
                  userData: widget.arg.userData,
                  transportType: widget.arg.transportType,
                  pickupAddressList: context.read<HomeBloc>().pickupAddressList,
                  stopAddressList: context.read<HomeBloc>().stopAddressList,
                  title: widget.arg.title,
                  polyString: state.selectedRoute.polyLine,
                  distance: state.selectedRoute.totalDistance.toString(),
                  duration: state.selectedRoute.totalTime.toString(),
                  isOutstationRide: widget.arg.isOutstationRide,
                  mapType: widget.arg.mapType),
            );
          } else if (state is ServiceNotAvailableState) {
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
            return Directionality(
              textDirection: context.read<HomeBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SafeArea(
                  child: Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      leadingWidth: size.width * 0.2,
                      surfaceTintColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 3),
                        child: NavigationIconWidget(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_new_rounded,
                              size: 18,
                              color: Theme.of(context).primaryColorDark),
                          isShadowWidget: true,
                        ),
                      ),
                      actions: [
                        (context.read<HomeBloc>().addressList.length < 4 &&
                                !widget.arg.isOutstationRide)
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: InkWell(
                                  onTap: () {
                                    context
                                        .read<HomeBloc>()
                                        .add(AddStopEvent());
                                  },
                                  // child: Icon(
                                  //   Icons.add_outlined,
                                  //   color: Theme.of(context).primaryColor,
                                  // ),
                                  child: MyText(
                                      text:
                                          AppLocalizations.of(context)!.addStop,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontWeight: FontWeight.w600)),
                                ),
                              )
                            : const SizedBox(width: 1)
                      ],
                      bottom: PreferredSize(
                        preferredSize: Size(
                            size.width,
                            (context.read<HomeBloc>().addressList.length == 2)
                                ? size.width * 0.3
                                : (context
                                            .read<HomeBloc>()
                                            .addressList
                                            .length ==
                                        3)
                                    ? size.width * 0.4
                                    : size.width * 0.55),
                        child: buildLocationSelect(context, size),
                      ),
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (context
                              .read<HomeBloc>()
                              .searchInfoMessage
                              .isEmpty) ...[
                            SizedBox(height: size.width * 0.03),
                            if (context.read<HomeBloc>().userData != null)
                              buildFavoriteLocations(
                                  context,
                                  context
                                      .read<HomeBloc>()
                                      .userData!
                                      .favouriteLocations
                                      .data,
                                  size),
                            SizedBox(height: size.width * 0.03),
                            if (context
                                .read<HomeBloc>()
                                .recentSearchPlaces
                                .isNotEmpty) ...[
                              if (context
                                      .read<HomeBloc>()
                                      .recentRoutes
                                      .isNotEmpty &&
                                  context.read<HomeBloc>().recentRoutes.any(
                                      (element) =>
                                          element.transportType ==
                                          widget.arg.transportType))
                                buildRecentRoutes(context, size),
                              SizedBox(height: size.width * 0.02),
                              buildRecentSearchLocations(context, size)
                            ],
                          ],
                          if (context
                              .read<HomeBloc>()
                              .searchInfoMessage
                              .isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 16),
                              child: MyText(
                                  text: context
                                      .read<HomeBloc>()
                                      .searchInfoMessage),
                            ),
                          if (context
                              .read<HomeBloc>()
                              .autoSearchPlaces
                              .isNotEmpty) ...[
                            SizedBox(height: size.width * 0.03),
                            autoSearchPlacesWidget(context, size)
                          ]
                        ],
                      ),
                    ),
                    bottomSheet: buildSelectFromMap(size, context),
                    bottomNavigationBar: (!context
                            .read<HomeBloc>()
                            .addressList
                            .any((element) => element.address.isEmpty))
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(8, 8, 8,
                                MediaQuery.of(context).viewInsets.bottom + 8),
                            child: CustomButton(
                              buttonName: AppLocalizations.of(context)!.done,
                              buttonColor: context
                                      .read<HomeBloc>()
                                      .addressList
                                      .any((element) => element.address.isEmpty)
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2)
                                  : Theme.of(context).primaryColor,
                              onTap: () {
                                if (!context.read<HomeBloc>().addressList.any(
                                    (element) => element.address.isEmpty)) {
                                  context.read<HomeBloc>().add(
                                      ConfirmRideAddressEvent(
                                          rideType: widget.arg.isOutstationRide
                                              ? 'outstation'
                                              : 'taxi',
                                          addressList: context
                                              .read<HomeBloc>()
                                              .addressList));
                                }
                              },
                            ))
                        : null,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget autoSearchPlacesWidget(BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SizedBox(
        child: GestureDetector(
          onVerticalDragStart: (details) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ListView.separated(
                    itemCount: context.read<HomeBloc>().autoSearchPlaces.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final autoAddres = context
                          .read<HomeBloc>()
                          .autoSearchPlaces
                          .elementAt(index);
                      return InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          context.read<HomeBloc>().add(
                              RecentSearchPlaceSelectEvent(
                                  transportType: widget.arg.transportType,
                                  address: autoAddres,
                                  isPickupSelect:
                                      context.read<HomeBloc>().isPickupSelect));
                        },
                        child: Row(
                          children: [
                            Container(
                              height: size.height * 0.075,
                              width: size.width * 0.075,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.25),
                                  shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.location_pin,
                                size: 20,
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.75),
                              ),
                            ),
                            SizedBox(width: size.width * 0.025),
                            SizedBox(
                              width: size.width * 0.8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                      text: autoAddres.address,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .disabledColor),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(color: Theme.of(context).dividerColor);
                    },
                  ),
                  SizedBox(height: size.width * 0.15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLocationSelect(BuildContext context, Size size) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).shadowColor,
                offset: const Offset(0, 5),
                blurRadius: 5,
                spreadRadius: 1)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (context.read<HomeBloc>().addressList.isNotEmpty) ...[
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.white,
                  shadowColor: Colors.transparent,
                ),
                child: ReorderableListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  onReorder: (oldIndex, newIndex) {
                    context.read<HomeBloc>().add(
                        ReorderEvent(oldIndex: oldIndex, newIndex: newIndex));
                  },
                  children: List.generate(
                    context.read<HomeBloc>().addressList.length,
                    (index) {
                      TextEditingController controller = context
                          .read<HomeBloc>()
                          .addressTextControllerList
                          .elementAt(index);
                      return Padding(
                        key: Key('$index'),
                        padding: EdgeInsets.only(bottom: size.width * 0.02),
                        child: Row(
                          children: [
                            if (index != 0 &&
                                index !=
                                    context
                                            .read<HomeBloc>()
                                            .addressList
                                            .length -
                                        1) ...[
                              Container(
                                height: size.width * 0.05,
                                width: size.width * 0.05,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 0.3,
                                        color:
                                            Theme.of(context).disabledColor)),
                                child: Center(
                                  child: MyText(
                                      text: '$index',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                            ],
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 0.3,
                                        color:
                                            Theme.of(context).disabledColor)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        controller: controller,
                                        enabled: true,
                                        filled: true,
                                        autofocus: context
                                                .read<HomeBloc>()
                                                .recentSearchPlaces
                                                .isEmpty
                                            ? (!widget.arg.pickUpChange &&
                                                    index == 1)
                                                ? true
                                                : (widget.arg.pickUpChange &&
                                                        index == 0)
                                                    ? true
                                                    : false
                                            : false,
                                        keyboardType: TextInputType.text,
                                        fillColor: Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.1),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 0.5,
                                                color: Theme.of(context)
                                                    .disabledColor
                                                    .withOpacity(0.3))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 0.8,
                                                color: Theme.of(context)
                                                    .disabledColor)),
                                        hintText: (index ==
                                                context
                                                        .read<HomeBloc>()
                                                        .addressList
                                                        .length -
                                                    1)
                                            ? AppLocalizations.of(context)!
                                                .destinationAddress
                                            : (index == 0)
                                                ? AppLocalizations.of(context)!
                                                    .pickupAddress
                                                : AppLocalizations.of(context)!
                                                    .addStopAddress,
                                        hintTextStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        prefixConstraints: BoxConstraints(
                                            maxWidth: size.width * 0.065),
                                        prefixIcon: (index == 0 ||
                                                index ==
                                                    context
                                                            .read<HomeBloc>()
                                                            .addressList
                                                            .length -
                                                        1)
                                            ? Center(
                                                child: (index == 0)
                                                    ? const PickupIcon()
                                                    : const DropIcon())
                                            : null,
                                        suffixConstraints: BoxConstraints(
                                            maxWidth: size.width * 0.2),
                                        suffixIcon: controller.text.isNotEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10, left: 10),
                                                child: InkWell(
                                                  onTap: () {
                                                    context
                                                            .read<HomeBloc>()
                                                            .addressList[index] =
                                                        AddressModel(
                                                            orderId: '',
                                                            address: '',
                                                            lat: 0,
                                                            lng: 0,
                                                            name: '',
                                                            number: '',
                                                            pickup: false);
                                                    context
                                                        .read<HomeBloc>()
                                                        .addressTextControllerList[
                                                            index]
                                                        .text = '';
                                                    if (context
                                                        .read<HomeBloc>()
                                                        .autoSearchPlaces
                                                        .isNotEmpty) {
                                                      context
                                                          .read<HomeBloc>()
                                                          .searchInfoMessage = '';
                                                      context
                                                          .read<HomeBloc>()
                                                          .autoSearchPlaces
                                                          .clear();
                                                    }
                                                    context
                                                        .read<HomeBloc>()
                                                        .add(UpdateEvent());
                                                  },
                                                  child: Icon(
                                                    Icons.cancel,
                                                    size: 20,
                                                    color: Theme.of(context)
                                                        .disabledColor
                                                        .withOpacity(0.4),
                                                  ),
                                                ),
                                              )
                                            : null,
                                        onTap: () {
                                          context
                                                  .read<HomeBloc>()
                                                  .isPickupSelect =
                                              (index == 0) ? true : false;
                                          context
                                              .read<HomeBloc>()
                                              .choosenAddressIndex = index;
                                          context
                                              .read<HomeBloc>()
                                              .add(UpdateEvent());
                                        },
                                        onChange: (value) {
                                          context
                                              .read<HomeBloc>()
                                              .debouncer
                                              .run(() {
                                            if (value.isEmpty) {
                                              context
                                                      .read<HomeBloc>()
                                                      .addressList[index] =
                                                  AddressModel(
                                                      orderId: '',
                                                      address: '',
                                                      lat: 0,
                                                      lng: 0,
                                                      name: '',
                                                      number: '',
                                                      pickup: false);
                                            }
                                            context.read<HomeBloc>().add(
                                                SearchPlacesEvent(
                                                    context: context,
                                                    mapType: widget.arg.mapType,
                                                    countryCode: widget.arg
                                                        .userData.countryCode,
                                                    latLng: (widget.arg
                                                                .pickupLatLng !=
                                                            null)
                                                        ? widget
                                                            .arg.pickupLatLng!
                                                        : (widget.arg
                                                                    .dropLatLng !=
                                                                null)
                                                            ? widget
                                                                .arg.dropLatLng!
                                                            : const LatLng(
                                                                0, 0),
                                                    enbleContryRestrictMap: widget
                                                        .arg
                                                        .userData
                                                        .enableCountryRestrictOnMap,
                                                    searchText: value));
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.01),
                                    Icon(Icons.drag_indicator_rounded,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        size: 20),
                                    SizedBox(width: size.width * 0.01),
                                  ],
                                ),
                              ),
                            ),
                            (context.read<HomeBloc>().addressList.length > 2)
                                ? InkWell(
                                    onTap: () {
                                      context
                                          .read<HomeBloc>()
                                          .addressList
                                          .removeAt(index);
                                      context
                                          .read<HomeBloc>()
                                          .addressTextControllerList
                                          .removeAt(index);
                                      context
                                          .read<HomeBloc>()
                                          .add(UpdateEvent());
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: size.width * 0.015),
                                      child: Icon(
                                        Icons.close,
                                        size: 20,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildFavoriteLocations(BuildContext context,
      List<FavoriteLocationData> favLocations, Size size) {
    bool isHomeAvailable = false;
    bool isWorkAvailable = false;
    bool isOthersAvailable = false;
    for (var element in favLocations) {
      if (element.addressName == 'Home') {
        isHomeAvailable = true;
      } else if (element.addressName == 'Work') {
        isWorkAvailable = true;
      } else {
        isOthersAvailable = true;
      }
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                favLocations.length,
                (index) {
                  final location = favLocations.elementAt(index);
                  return Padding(
                    padding: EdgeInsets.only(right: size.width * 0.02),
                    child: InkWell(
                      onTap: () {
                        context.read<HomeBloc>().add(FavLocationSelectEvent(
                            address: location,
                            isPickupSelect:
                                context.read<HomeBloc>().isPickupSelect));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:
                              Theme.of(context).disabledColor.withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          child: Row(
                            children: [
                              Icon(
                                (location.addressName.toLowerCase() == 'home')
                                    ? Icons.home_outlined
                                    : (location.addressName.toLowerCase() ==
                                            'work')
                                        ? Icons.business_center_outlined
                                        : Icons.home_work_outlined,
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 5),
                              MyText(
                                text: location.addressName,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                if (!isHomeAvailable)
                  Padding(
                    padding: EdgeInsets.only(right: size.width * 0.02),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                                context, FavoriteLocationPage.routeName,
                                arguments: FavouriteLocationPageArguments(
                                    userData: widget.arg.userData))
                            .then(
                          (value) {
                            if (!context.mounted) return;
                            if (value != null) {
                              context.read<HomeBloc>().userData =
                                  value as UserDetail;
                              context.read<HomeBloc>().add(UpdateEvent());
                            }
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:
                              Theme.of(context).disabledColor.withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 18,
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.5),
                              ),
                              const SizedBox(width: 5),
                              MyText(
                                text: AppLocalizations.of(context)!.home,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if (!isWorkAvailable)
                  Padding(
                    padding: EdgeInsets.only(right: size.width * 0.02),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                                context, FavoriteLocationPage.routeName,
                                arguments: FavouriteLocationPageArguments(
                                    userData: widget.arg.userData))
                            .then(
                          (value) {
                            if (!context.mounted) return;
                            if (value != null) {
                              context.read<HomeBloc>().userData =
                                  value as UserDetail;
                              context.read<HomeBloc>().add(UpdateEvent());
                            }
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:
                              Theme.of(context).disabledColor.withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 18,
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.5),
                              ),
                              const SizedBox(width: 5),
                              MyText(
                                text: AppLocalizations.of(context)!.work,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if (!isOthersAvailable)
                  Padding(
                    padding: EdgeInsets.only(right: size.width * 0.02),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                                context, FavoriteLocationPage.routeName,
                                arguments: FavouriteLocationPageArguments(
                                    userData: widget.arg.userData))
                            .then(
                          (value) {
                            if (!context.mounted) return;
                            if (value != null) {
                              context.read<HomeBloc>().userData =
                                  value as UserDetail;
                              context.read<HomeBloc>().add(UpdateEvent());
                            }
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:
                              Theme.of(context).disabledColor.withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 18,
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.5),
                              ),
                              const SizedBox(width: 5),
                              MyText(
                                text: AppLocalizations.of(context)!.others,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildRecentRoutes(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.recentSearchRoutes,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).disabledColor,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
            ),
            SizedBox(height: size.width * 0.02),
            SizedBox(
              width: size.width,
              height: size.width * (context.read<HomeBloc>().recentRouteHeight),
              child: PageView.builder(
                controller: context.read<HomeBloc>().recentRoutesPageController,
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: context
                    .read<HomeBloc>()
                    .recentRoutes
                    .where((element) =>
                        element.transportType == widget.arg.transportType)
                    .length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      context.read<HomeBloc>().add(RecentRouteSelectEvent(
                          selectedRoute:
                              context.read<HomeBloc>().recentRoutes[index]));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: Theme.of(context).disabledColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.018),
                                  child: const PickupIcon(),
                                ),
                                Expanded(
                                  child: MyText(
                                    text: context
                                        .read<HomeBloc>()
                                        .recentRoutes[index]
                                        .pickShortAddress,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            if (context
                                .read<HomeBloc>()
                                .recentRoutes[index]
                                .searchStops
                                .data
                                .isNotEmpty) ...[
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: VerticalDotDividerWidget(),
                              ),
                              ListView.separated(
                                itemCount: context
                                    .read<HomeBloc>()
                                    .recentRoutes[index]
                                    .searchStops
                                    .data
                                    .length,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemBuilder: (context, ind) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.023),
                                        child: Container(
                                          height: 16,
                                          width: 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          child: Center(
                                            child: MyText(
                                              text: '${ind + 1}',
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color: AppColors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: MyText(
                                          text: context
                                              .read<HomeBloc>()
                                              .recentRoutes[index]
                                              .searchStops
                                              .data[ind]
                                              .shortAddress,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: VerticalDotDividerWidget(),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: VerticalDotDividerWidget(),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.015),
                                  child: const DropIcon(),
                                ),
                                Expanded(
                                  child: MyText(
                                    text: context
                                        .read<HomeBloc>()
                                        .recentRoutes[index]
                                        .dropShortAddress,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                onPageChanged: (value) {
                  context
                      .read<HomeBloc>()
                      .add(RecentRoutesChangeIndex(routesIndex: value));
                },
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                context
                    .read<HomeBloc>()
                    .recentRoutes
                    .where((element) =>
                        element.transportType == widget.arg.transportType)
                    .length,
                (index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 5),
                    height:
                        context.read<HomeBloc>().routesIndex == index ? 10 : 8,
                    width:
                        context.read<HomeBloc>().routesIndex == index ? 10 : 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.read<HomeBloc>().routesIndex == index
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).splashColor),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRecentSearchLocations(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: AppLocalizations.of(context)!.searchPlaces,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontWeight: FontWeight.w600),
                maxLines: 1,
              ),
              SizedBox(height: size.width * 0.02),
              ListView.separated(
                itemCount: context.read<HomeBloc>().recentSearchPlaces.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (_, index) {
                  final recentPlace = context
                      .read<HomeBloc>()
                      .recentSearchPlaces
                      .elementAt(index);
                  return InkWell(
                    onTap: () {
                      context.read<HomeBloc>().add(
                            RecentSearchPlaceSelectEvent(
                                transportType: widget.arg.transportType,
                                address: recentPlace,
                                isPickupSelect:
                                    context.read<HomeBloc>().isPickupSelect),
                          );
                    },
                    child: SizedBox(
                      height: size.width * 0.14,
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
                              Icons.location_pin,
                              size: 20,
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.75),
                            ),
                          ),
                          SizedBox(width: size.width * 0.025),
                          SizedBox(
                            width: size.width * 0.75,
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
                                          fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                ),
                                MyText(
                                  text: recentPlace.address,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color:
                                              Theme.of(context).disabledColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                      color: Theme.of(context).dividerColor.withOpacity(0.5));
                },
              ),
              SizedBox(height: size.width * 0.15),
            ],
          ),
        ),
      ),
    );
  }

  Container buildSelectFromMap(Size size, BuildContext context) {
    return Container(
      height: size.width * 0.1,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -1),
              color: Theme.of(context).shadowColor,
            )
          ]),
      child: InkWell(
        onTap: () {
          context.read<HomeBloc>().add(SelectFromMapEvent(
              selectedAddressIndex:
                  context.read<HomeBloc>().choosenAddressIndex,
              isPickUpEdit:
                  context.read<HomeBloc>().isPickupSelect ? true : false));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pin_drop_outlined),
            MyText(text: AppLocalizations.of(context)!.selectFromMap),
          ],
        ),
      ),
    );
  }
}
