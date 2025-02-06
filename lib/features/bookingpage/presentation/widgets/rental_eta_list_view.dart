import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/booking_bloc.dart';
import 'schedule_ride.dart';

Widget rentalEtaListViewWidget(
  Size size,
  BuildContext context,
  BookingPageArguments arg,
  dynamic thisValue,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.width * 0.02),
        const Divider(),
        SizedBox(height: size.width * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.selectedPackage,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            InkWell(
              onTap: () {
                context.read<BookingBloc>().add(ShowRentalPackageListEvent());
              },
              child: MyText(
                text: AppLocalizations.of(context)!.edit,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        SizedBox(height: size.width * 0.02),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Theme.of(context).primaryColorDark.withOpacity(0.7)),
              color: AppColors.darkGrey.withOpacity(0.3)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: MyText(
              text: context
                  .read<BookingBloc>()
                  .rentalPackagesList[
                      context.read<BookingBloc>().selectedPackageIndex]
                  .packageName,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        SizedBox(height: size.width * 0.02),
        const Divider(),
        SizedBox(height: size.width * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.rideDetails,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            if(arg.userData.showRideLaterFeature)
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: false,
                    enableDrag: false,
                    isDismissible: true,
                    barrierColor: Theme.of(context).shadowColor,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    builder: (_) {
                      return scheduleRide(context, size, arg,false);
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
                          size: 20, color: Theme.of(context).primaryColorDark),
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
                            .copyWith(color: Theme.of(context).primaryColorDark),
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
        SizedBox(height: size.width * 0.02),
        SizedBox(
          height: size.height * 0.49,
          child: ListView.builder(
            shrinkWrap: true,
            controller: context.read<BookingBloc>().etaScrollController,
            padding: EdgeInsets.zero,
            physics: context.read<BookingBloc>().enableEtaScrolling
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            itemCount: context.read<BookingBloc>().rentalEtaDetailsList.length,
            itemBuilder: (context, index) {
              final eta = context
                  .read<BookingBloc>()
                  .rentalEtaDetailsList
                  .elementAt(index);
              return InkWell(
                onTap: () {
                  context
                      .read<BookingBloc>()
                      .add(BookingEtaSelectEvent(selectedVehicleIndex: index,
                      isOutstationRide: arg.isOutstationRide));
                  final selectedSize = context
                              .read<BookingBloc>()
                              .dropAddressList
                              .length ==
                          1
                      ? context.read<BookingBloc>().currentSize
                      : context.read<BookingBloc>().dropAddressList.length == 2
                          ? context.read<BookingBloc>().currentSizeTwo
                          : context.read<BookingBloc>().currentSizeThree;
                  context.read<BookingBloc>().updateScrollHeight(selectedSize);
                  context.read<BookingBloc>().scrollToBottomFunction(
                      context.read<BookingBloc>().dropAddressList.length);

                  // Jump to the selected size position in the scroll controller
                  context
                      .read<BookingBloc>()
                      .etaScrollController
                      .jumpTo(selectedSize);

                  // For Check near ETA
                  context.read<BookingBloc>().checkNearByEta(
                      context.read<BookingBloc>().nearByDriversData, thisValue);
                },
                child: Container(
                  width: size.width * 0.99,
                  height: size.width * 0.17,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: (index == 0) // Highlight the item now at the top
                        ? Theme.of(context).dividerColor.withOpacity(0.3)
                        : Theme.of(context).dividerColor.withOpacity(0.1),
                    border: Border.all(
                        color: (index == 0) // Selected item at the top
                            ? Theme.of(context).primaryColorDark.withOpacity(0.7)
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
                              imageUrl: eta.icon,
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
                                                      .indexWhere((element) =>
                                                          element.typeId ==
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
                                            color: Theme.of(context).hintColor,
                                          ),
                                    ),
                                    SizedBox(width: size.width * 0.005),
                                    InkWell(
                                      onTap: () {
                                        context.read<BookingBloc>().add(
                                            ShowEtaInfoEvent(infoIndex: index));
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyText(
                                    text:
                                        '${eta.currency.toString()} ${eta.fareAmount.toStringAsFixed(1)}',
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            fontSize: 12,
                                            color: Theme.of(context).hintColor,
                                            decoration: (eta.hasDiscount &&
                                                    !context
                                                        .read<BookingBloc>()
                                                        .showBiddingVehicles)
                                                ? TextDecoration.lineThrough
                                                : null,
                                            decorationColor:
                                                Theme.of(context).primaryColorDark,
                                            decorationThickness: 2),
                                  ),
                                  if (eta.hasDiscount &&
                                      !context
                                          .read<BookingBloc>()
                                          .showBiddingVehicles)
                                    MyText(
                                      text:
                                          '${eta.currency.toString()} ${eta.discountedTotel.toStringAsFixed(1)}',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor,
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
    ),
  );
}
