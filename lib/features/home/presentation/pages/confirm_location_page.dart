// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart' as fmlt;
import 'package:restart_tagxi/l10n/app_localizations.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_navigation_icon.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../application/home_bloc.dart';

class ConfirmLocationPage extends StatefulWidget {
  static const String routeName = '/confirmLocationPage';
  final ConfirmLocationPageArguments arg;

  const ConfirmLocationPage({super.key, required this.arg});

  @override
  State<ConfirmLocationPage> createState() => _ConfirmLocationPageState();
}

class _ConfirmLocationPageState extends State<ConfirmLocationPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return builderWidget(size);
  }

  Widget builderWidget(Size size) {
    return BlocProvider(
      create: (context) =>HomeBloc()
          ..add(GetDirectionEvent())
          ..add(ConfirmLocationPageInitEvent(arg: widget.arg)),
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
          } else if (state is ConfirmAddressState) {
            Navigator.pop(context, state.address);
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (widget.arg.mapType == 'google_map') {
              if (Theme.of(context).brightness == Brightness.dark) {
                if (context.read<HomeBloc>().googleMapController != null) {
                  context
                      .read<HomeBloc>()
                      .googleMapController!
                      .setMapStyle(context.read<HomeBloc>().darkMapString);
                }
              } else {
                if (context.read<HomeBloc>().googleMapController != null) {
                  context
                      .read<HomeBloc>()
                      .googleMapController!
                      .setMapStyle(context.read<HomeBloc>().lightMapString);
                }
              }
            }
            return Directionality(
              textDirection: context.read<HomeBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                resizeToAvoidBottomInset: true,
                body: bodyMapBuilder(context, size),
                bottomNavigationBar: bottomConfirmationWidget(size, context),
              ),
            );
          },
        ),
      ),
    );
  }

  Stack bodyMapBuilder(BuildContext context, Size size) {
    return Stack(
      children: [
        Stack(
          children: [
            (widget.arg.mapType == 'google_map')
                ? GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      if (context.read<HomeBloc>().googleMapController ==
                          null) {
                        context.read<HomeBloc>().add(GoogleControllAssignEvent(
                            controller: controller,
                            isFromHomePage: false,
                            isEditAddress: widget.arg.isEditAddress,
                            latlng: context.read<HomeBloc>().currentLatLng));
                      }
                    },
                    compassEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: context.read<HomeBloc>().currentLatLng,
                      zoom: 15.0,
                    ),
                    onCameraMoveStarted: () {
                      context.read<HomeBloc>().isCameraMoveComplete = true;
                    },
                    onCameraMove: (CameraPosition position) {
                      if (!context.mounted) return;
                      context.read<HomeBloc>().currentLatLng = position.target;
                      context.read<HomeBloc>().add(UpdateEvent());
                    },
                    onCameraIdle: () {
                      if (context.read<HomeBloc>().isCameraMoveComplete) {
                        if (context
                            .read<HomeBloc>()
                            .pickupAddressList
                            .isEmpty) {
                          context.read<HomeBloc>().add(UpdateLocationEvent(
                              isFromHomePage: false,
                              latLng: context.read<HomeBloc>().currentLatLng,
                              mapType: widget.arg.mapType));
                        } else {
                          context.read<HomeBloc>().confirmPinAddress = true;
                          context.read<HomeBloc>().add(UpdateEvent());
                        }
                      }
                    },
                    minMaxZoomPreference: const MinMaxZoomPreference(0, 20),
                    buildingsEnabled: false,
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false)
                : fm.FlutterMap(
                   mapController: context.read<HomeBloc>().fmController,
                    options: fm.MapOptions(
                      onTap: (tapPosition, latLng) {
                        context.read<HomeBloc>().currentLatLng =
                            LatLng(latLng.latitude, latLng.longitude);
                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (context.read<HomeBloc>().fmController != null) {
                            context
                                .read<HomeBloc>()
                                .fmController!
                                .move(latLng, 15);
                          }
                        // });
                        context.read<HomeBloc>().add(UpdateLocationEvent(
                            isFromHomePage: true,
                            latLng: context.read<HomeBloc>().currentLatLng,
                            mapType: widget.arg.mapType));
                      },
                      onMapEvent: (v) async {
                        if (v.source ==
                            fm.MapEventSource.nonRotatedSizeChange) {
                          context.read<HomeBloc>().fmLatLng = fmlt.LatLng(
                              v.camera.center.latitude,
                              v.camera.center.longitude);
                          context.read<HomeBloc>().currentLatLng = LatLng(
                              v.camera.center.latitude,
                              v.camera.center.longitude);
                          if (v.camera.center.latitude != 0.0 &&
                              v.camera.center.longitude != 0.0) {
                            context.read<HomeBloc>().add(UpdateLocationEvent(
                              isFromHomePage: true,
                              latLng: context.read<HomeBloc>().currentLatLng,
                              mapType: widget.arg.mapType));
                          }else{
                            context.read<HomeBloc>().add(UpdateLocationEvent(
                                isFromHomePage: true,
                                latLng: AppConstants.currentLocations,
                                mapType: widget.arg.mapType));
                          }
                        }
                        if (v.source == fm.MapEventSource.onDrag) {
                          context.read<HomeBloc>().currentLatLng = LatLng(
                              v.camera.center.latitude,
                              v.camera.center.longitude);
                          context.read<HomeBloc>().add(UpdateEvent());
                        }
                        if (v.source == fm.MapEventSource.dragEnd) {
                          context.read<HomeBloc>().add(UpdateLocationEvent(
                              isFromHomePage: true,
                              latLng: LatLng(v.camera.center.latitude,
                                  v.camera.center.longitude),
                              mapType: widget.arg.mapType));
                        }
                      },
                      onPositionChanged: (p, l) async {
                        if (l == false) {
                          context.read<HomeBloc>().currentLatLng =
                              LatLng(p.center.latitude, p.center.longitude);
                          context.read<HomeBloc>().add(UpdateEvent());
                        }
                      },
                      initialCenter: fmlt.LatLng(
                          context.read<HomeBloc>().currentLatLng.latitude,
                          context.read<HomeBloc>().currentLatLng.longitude),
                      initialZoom: 16,
                      minZoom: 13,
                      maxZoom: 20,
                    ),
                    children: [
                      fm.TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                    ],
                  ),
            Positioned(
              child: Container(
                height: size.height * 1,
                width: size.width * 1,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 25),
                child: Image.asset(
                  AppImages.pickupIcon,
                  width: size.width * 0.08,
                  height: size.width * 0.08,
                ),
              ),
            ),
            if (context.read<HomeBloc>().confirmPinAddress)
            Positioned(
              child: Container(
                height: size.height * 1,
                width: size.width * 1,
                alignment: Alignment.center,
                margin:const EdgeInsets.only(top: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        height: size.width * 0.08,
                        width: size.width * 0.25,
                        onTap: () {
                          context.read<HomeBloc>().confirmPinAddress =
                              false;
                          context.read<HomeBloc>().add(
                              UpdateLocationEvent(
                                  isFromHomePage: false,
                                  latLng: context
                                      .read<HomeBloc>()
                                      .currentLatLng,
                            mapType: widget.arg.mapType));
                        },
                        textSize: 12,
                        buttonName:
                            AppLocalizations.of(context)!.confirm)
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 16,
              child: InkWell(
                onTap: () {
                  context
                      .read<HomeBloc>()
                      .add(LocateMeEvent(mapType: widget.arg.mapType));
                },
                child: Container(
                  height: size.width * 0.1,
                  width: size.width * 0.1,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).shadowColor,
                            blurRadius: 1,
                            spreadRadius: 1)
                      ]),
                  margin: const EdgeInsets.only(bottom: 5),
                  child: const Center(
                      child: Icon(
                    Icons.my_location,
                    size: 20,
                    color: AppColors.black,
                  )),
                ),
              ),
            )
          ],
        ),
        if (context.read<HomeBloc>().autoSearchPlaces.isNotEmpty)
          Container(
            height: size.height,
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: Padding(
              padding:
                  EdgeInsets.only(top: size.height * 0.08, left: 16, right: 16),
              child: autoSearchPlacesWidget(context, size),
            ),
          ),
        searchbarWidget(context, size),
      ],
    );
  }

  Widget searchbarWidget(BuildContext context, Size size) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                NavigationIconWidget(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      size: 18, color: Theme.of(context).primaryColorDark),
                  isShadowWidget: true,
                ),
                SizedBox(width: size.width * 0.04),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 4,
                              spreadRadius: 3,
                              color: Theme.of(context).shadowColor)
                        ]),
                    child: CustomTextField(
                      controller: context.read<HomeBloc>().searchController,
                      filled: true,
                      focusNode: context.read<HomeBloc>().searchFocus,
                      // focusNode: FocusNode(skipTraversal: true, canRequestFocus:false),
                      prefixConstraints:
                          BoxConstraints(maxWidth: size.width * 0.1),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Icon(
                          Icons.search_rounded,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      suffixConstraints:
                          BoxConstraints(maxWidth: size.width * 0.1),
                      suffixIcon: context
                              .read<HomeBloc>()
                              .searchController
                              .text
                              .isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: InkWell(
                                onTap: () {
                                  context
                                      .read<HomeBloc>()
                                      .searchController
                                      .clear();
                                  context.read<HomeBloc>().searchInfoMessage =
                                      '';
                                  context
                                      .read<HomeBloc>()
                                      .autoSearchPlaces
                                      .clear();
                                  context.read<HomeBloc>().add(UpdateEvent());
                                },
                                child: Icon(
                                  Icons.cancel,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                            )
                          : null,
                      hintText: AppLocalizations.of(context)!.searchPlaces,
                      onTap: () {},
                      onSubmitted: (p0) {},
                      onChange: (value) {
                        context.read<HomeBloc>().debouncer.run(() {
                          context.read<HomeBloc>().add(SearchPlacesEvent(
                              context: context,
                              mapType: widget.arg.mapType,
                              countryCode: widget.arg.userData.countryCode,
                              latLng: context.read<HomeBloc>().currentLatLng,
                              enbleContryRestrictMap: widget
                                  .arg.userData.enableCountryRestrictOnMap,
                              searchText: value));
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget autoSearchPlacesWidget(BuildContext context, Size size) {
    return SizedBox(
      height: size.height * 0.55,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.05),
            if (context.read<HomeBloc>().autoSearchPlaces.isNotEmpty)
              ListView.separated(
                itemCount: context.read<HomeBloc>().autoSearchPlaces.length > 5
                    ? 5
                    : context.read<HomeBloc>().autoSearchPlaces.length,
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
                      context
                          .read<HomeBloc>()
                          .searchFocus
                          .unfocus(); // Dismiss the keyboard
                      context.read<HomeBloc>().add(
                          ConfirmLocationSearchPlaceSelectEvent(
                              address: autoAddres,
                              mapType: widget.arg.mapType));
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
                                          color:
                                              Theme.of(context).disabledColor),
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
          ],
        ),
      ),
    );
  }

  Widget bottomConfirmationWidget(Size size, BuildContext context) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).shadowColor,
              offset: const Offset(8, 0),
              blurRadius: 9,
              spreadRadius: 1)
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: size.width * 0.01),
            MyText(
                maxLines: 3,
                textStyle: Theme.of(context).textTheme.bodyLarge,
                text: context.read<HomeBloc>().currentLocation),
            SizedBox(height: size.width * 0.05),
            CustomButton(
              buttonName: widget.arg.isPickupEdit
                  ? '${AppLocalizations.of(context)!.confirm} ${AppLocalizations.of(context)!.pickupLocation}'
                  : AppLocalizations.of(context)!.confirmLocation,
              width: size.width,
              onTap: () {
                context.read<HomeBloc>().add(ConfirmAddressEvent(
                      isDelivery:
                          widget.arg.transportType.toString().toLowerCase() ==
                                  'delivery'
                              ? true
                              : false,
                      isEditAddress: widget.arg.isEditAddress,
                      isPickUpEdit: widget.arg.isPickupEdit,
                    ));
              },
            ),
            SizedBox(height: size.width * 0.05),
          ],
        ),
      ),
    );
  }
}
