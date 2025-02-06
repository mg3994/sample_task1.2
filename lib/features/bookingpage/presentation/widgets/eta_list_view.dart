import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/booking_bloc.dart';
import 'schedule_ride.dart';

Widget etaListViewWidget(Size size, BuildContext context,
    BookingPageArguments arg, dynamic thisValue) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (context.read<BookingBloc>().isMultiTypeVechiles &&
          !arg.isOutstationRide && (arg.isWithoutDestinationRide == null ||(arg.isWithoutDestinationRide!= null &&!arg.isWithoutDestinationRide!)))  ...[
        SizedBox(height: size.width * 0.04),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  if(arg.isWithoutDestinationRide == null||!arg.isWithoutDestinationRide!)
                  InkWell(
                    onTap: () {
                      if (!context.read<BookingBloc>().showBiddingVehicles) {
                        context.read<BookingBloc>().add(
                            SelectBiddingOrDemandEvent(
                                selectedTypeEta: 'Bidding', isBidding: true));
                        // For Check near ETA
                        context.read<BookingBloc>().checkNearByEta(
                            context.read<BookingBloc>().nearByDriversData,
                            thisValue);
                      }
                    },
                    child: Container(
                      height: size.width * 0.08,
                      width: size.width * 0.25,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: context.read<BookingBloc>().showBiddingVehicles
                            ? Theme.of(context).dividerColor.withOpacity(0.5)
                            : Theme.of(context).dividerColor.withOpacity(0.5),
                        border: Border.all(
                            color:
                                context.read<BookingBloc>().showBiddingVehicles
                                    ? Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.5)
                                    : AppColors.transparent),
                      ),
                      child: Center(
                        child: MyText(
                          text: AppLocalizations.of(context)!.bidding,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).primaryColorDark),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (context.read<BookingBloc>().showBiddingVehicles) {
                        context.read<BookingBloc>().add(
                            SelectBiddingOrDemandEvent(
                                selectedTypeEta: 'On Demand',
                                isBidding: false));
                        // For Check near ETA
                        context.read<BookingBloc>().checkNearByEta(
                            context.read<BookingBloc>().nearByDriversData,
                            thisValue);
                      }
                    },
                    child: Container(
                      height: size.width * 0.08,
                      width: size.width * 0.25,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: !context.read<BookingBloc>().showBiddingVehicles
                            ? Theme.of(context).dividerColor.withOpacity(0.5)
                            : Theme.of(context).dividerColor.withOpacity(0.5),
                        border: Border.all(
                            color:
                                !context.read<BookingBloc>().showBiddingVehicles
                                    ? Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.5)
                                    : AppColors.transparent),
                      ),
                      child: Center(
                        child: MyText(
                          text: AppLocalizations.of(context)!.onDemand,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).primaryColorDark),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: size.width * 0.05),
      ],
      if(arg.isWithoutDestinationRide != null &&
          arg.isWithoutDestinationRide!)
        SizedBox(height: size.width * 0.04),
      if (arg.isOutstationRide) ...[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: size.width * 0.02),
              Container(
                width: size.width,
                height: size.width * 0.15,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<BookingBloc>().isRoundTrip = false;
                        context.read<BookingBloc>().showReturnDateTime = '';
                        context.read<BookingBloc>().scheduleDateTimeForReturn =
                            '';
                        context.read<BookingBloc>().add(UpdateEvent());
                      },
                      child: Container(
                        width: size.width * 0.45,
                        decoration: BoxDecoration(
                            border: !context.read<BookingBloc>().isRoundTrip
                                ? Border.all(
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.5))
                                : null,
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                    text: AppLocalizations.of(context)!
                                        .oneWayTrip,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  if (!context.read<BookingBloc>().isRoundTrip)
                                    Icon(Icons.check_circle,
                                        size: 20,
                                        color:
                                            Theme.of(context).primaryColorDark)
                                ],
                              ),
                              MyText(
                                text: AppLocalizations.of(context)!.getDropOff,
                                textStyle:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.read<BookingBloc>().isRoundTrip = true;
                        context.read<BookingBloc>().add(UpdateEvent());
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: false,
                            enableDrag: false,
                            isDismissible: true,
                            barrierColor: Theme.of(context).shadowColor,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            builder: (_) {
                              return scheduleRide(context, size, arg, true);
                            });
                      },
                      child: Container(
                        width: size.width * 0.45,
                        decoration: BoxDecoration(
                            border: context.read<BookingBloc>().isRoundTrip
                                ? Border.all(
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.5))
                                : null,
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                    text:
                                        AppLocalizations.of(context)!.roundTrip,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  if (context.read<BookingBloc>().isRoundTrip)
                                    Icon(Icons.check_circle,
                                        size: 20,
                                        color:
                                            Theme.of(context).primaryColorDark)
                                ],
                              ),
                              MyText(
                                text: AppLocalizations.of(context)!
                                    .keepTheCarTillReturn,
                                textStyle:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.width * 0.02),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: false,
                      enableDrag: false,
                      isDismissible: true,
                      barrierColor: Theme.of(context).shadowColor,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      builder: (_) {
                        return scheduleRide(context, size, arg, false);
                      });
                },
                child: Row(
                  children: [
                    MyText(
                        text: '${AppLocalizations.of(context)!.leaveOn} : ',
                        textStyle: Theme.of(context).textTheme.bodySmall),
                    if (context
                        .read<BookingBloc>()
                        .showDateTime
                        .isNotEmpty) ...[
                      MyText(
                        text: context.read<BookingBloc>().showDateTime,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.w600),
                      ),
                    ]
                  ],
                ),
              ),
              SizedBox(height: size.width * 0.01),
              if (context.read<BookingBloc>().isRoundTrip)
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: false,
                        enableDrag: false,
                        isDismissible: true,
                        barrierColor: Theme.of(context).shadowColor,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        builder: (_) {
                          return scheduleRide(context, size, arg, true);
                        });
                  },
                  child: Row(
                    children: [
                      MyText(
                        text: '${AppLocalizations.of(context)!.returnBy} : ',
                        textStyle: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (context
                          .read<BookingBloc>()
                          .showReturnDateTime
                          .isNotEmpty) ...[
                        MyText(
                          text: context.read<BookingBloc>().showReturnDateTime,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.w600),
                        ),
                      ],
                      if (context
                          .read<BookingBloc>()
                          .showReturnDateTime
                          .isEmpty) ...[
                        MyText(
                          text: AppLocalizations.of(context)!.selectDate,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.w600),
                        ),
                      ]
                    ],
                  ),
                ),
              SizedBox(height: size.width * 0.03),
            ],
          ),
        ),
      ],
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.rideDetails,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            if ((!context.read<BookingBloc>().showBiddingVehicles ||
                    !context.read<BookingBloc>().isMultiTypeVechiles) &&
                arg.userData.showRideLaterFeature)
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: false,
                      enableDrag: false,
                      isDismissible: true,
                      barrierColor: Theme.of(context).shadowColor,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      builder: (_) {
                        return scheduleRide(context, size, arg, false);
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (context.read<BookingBloc>().showDateTime.isEmpty) ...[
                        MyText(
                          text: AppLocalizations.of(context)!.now,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: size.width * 0.02),
                        Icon(Icons.calendar_month,
                            size: 20,
                            color: Theme.of(context).primaryColorDark),
                      ],
                      if (context
                          .read<BookingBloc>()
                          .showDateTime
                          .isNotEmpty) ...[
                        MyText(
                          text: context.read<BookingBloc>().showDateTime,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Theme.of(context).primaryColorDark),
                        ),
                        Icon(Icons.cancel_outlined,
                            size: 18, color: Theme.of(context).primaryColorDark)
                      ]
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      SizedBox(height: size.width * 0.02),
      ((context.read<BookingBloc>().isEtaFilter &&
              !context.read<BookingBloc>().filterSuccess) || ((context
                      .read<BookingBloc>()
                      .isMultiTypeVechiles && context.read<BookingBloc>().sortedEtaDetailsList.isEmpty) 
                      || context.read<BookingBloc>().etaDetailsList.isEmpty))
          ? SizedBox(
              height: size.height * 0.49,
              child: Center(child: Image.asset(AppImages.noDataFound)))
          : SizedBox(
              height: (arg.isOutstationRide) 
                  ? size.height * 0.34
                  : size.height * 0.44,
              child: ListView.builder(
                shrinkWrap: true,
                controller: context.read<BookingBloc>().etaScrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: context.read<BookingBloc>().enableEtaScrolling
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                itemCount: context.read<BookingBloc>().isMultiTypeVechiles
                    ? context.read<BookingBloc>().sortedEtaDetailsList.length
                    : context.read<BookingBloc>().etaDetailsList.length,
                itemBuilder: (context, index) {
                  final eta = context.read<BookingBloc>().isMultiTypeVechiles
                      ? context
                          .read<BookingBloc>()
                          .sortedEtaDetailsList
                          .elementAt(index)
                      : context
                          .read<BookingBloc>()
                          .etaDetailsList
                          .elementAt(index);
                  return InkWell(
                    onTap: () {
                      context.read<BookingBloc>().add(BookingEtaSelectEvent(
                          selectedVehicleIndex: index,
                          isOutstationRide: arg.isOutstationRide));
                      final selectedSize = context
                                  .read<BookingBloc>()
                                  .dropAddressList
                                  .length ==
                              1
                          ? context.read<BookingBloc>().currentSize
                          : context
                                      .read<BookingBloc>()
                                      .dropAddressList
                                      .length ==
                                  2
                              ? context.read<BookingBloc>().currentSizeTwo
                              : context.read<BookingBloc>().currentSizeThree;
                      context
                          .read<BookingBloc>()
                          .updateScrollHeight(selectedSize);
                      context.read<BookingBloc>().scrollToBottomFunction(
                          context.read<BookingBloc>().dropAddressList.length);

                      // Jump to the selected size position in the scroll controller
                      context
                          .read<BookingBloc>()
                          .etaScrollController
                          .jumpTo(selectedSize);

                      // For Check near ETA
                      context.read<BookingBloc>().checkNearByEta(
                          context.read<BookingBloc>().nearByDriversData,
                          thisValue);
                    },
                    child: Container(
                      width: size.width * 0.99,
                      height: size.width * 0.17,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: (index == 0) // Highlight the item now at the top
                            ? AppColors.darkGrey.withOpacity(0.5)
                            : Theme.of(context).dividerColor.withOpacity(0.1),
                        border: Border.all(
                            color: (index == 0) // Selected item at the top
                                ? Theme.of(context)
                                    .primaryColorDark
                                    .withOpacity(0.5)
                                : Colors.white),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: eta.vehicleIcon,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: Loader(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Text(""),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // SizedBox(height: size.width * 0.01),
                                    SizedBox(
                                      width: size.width * 0.44,
                                      child: MyText(
                                        text: eta.name,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          color: Theme.of(context).hintColor,
                                          size: 14,
                                        ),
                                        SizedBox(width: size.width * 0.005),
                                        MyText(
                                          text: (context
                                                      .read<BookingBloc>()
                                                      .nearByEtaVechileList
                                                      .isNotEmpty &&
                                                  context
                                                      .read<BookingBloc>()
                                                      .nearByEtaVechileList
                                                      .elementAt(context
                                                          .read<BookingBloc>()
                                                          .nearByEtaVechileList
                                                          .indexWhere(
                                                              (element) =>
                                                                  element
                                                                      .typeId ==
                                                                  eta.typeId))
                                                      .duration
                                                      .isNotEmpty)
                                              ? context
                                                  .read<BookingBloc>()
                                                  .nearByEtaVechileList
                                                  .elementAt(context
                                                      .read<BookingBloc>()
                                                      .nearByEtaVechileList
                                                      .indexWhere((element) =>
                                                          element.typeId ==
                                                          eta.typeId))
                                                  .duration
                                              : '--',
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                fontSize: 14,
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                        ),
                                        SizedBox(width: size.width * 0.005),
                                        InkWell(
                                          onTap: () {
                                            context.read<BookingBloc>().add(
                                                ShowEtaInfoEvent(
                                                    infoIndex: index));
                                          },
                                          child: Icon(
                                            Icons.info,
                                            color: Theme.of(context).hintColor,
                                            size: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: size.width * 0.2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MyText(
                                        text:
                                            '${eta.currency.toString()} ${eta.total.toStringAsFixed(1)}',
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                fontSize: 12,
                                                color:
                                                    Theme.of(context).hintColor,
                                                decoration: (eta.hasDiscount &&
                                                        !context
                                                            .read<BookingBloc>()
                                                            .showBiddingVehicles)
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                                decorationColor:
                                                    Theme.of(context)
                                                        .primaryColorDark,
                                                decorationThickness: 2),
                                      ),
                                      if (eta.hasDiscount &&
                                          !context
                                              .read<BookingBloc>()
                                              .showBiddingVehicles)
                                        MyText(
                                          text:
                                              '${eta.currency.toString()} ${eta.discountTotal.toStringAsFixed(1)}',
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                fontSize: 14,
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                        ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    ],
  );
}
