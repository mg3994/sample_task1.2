import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../common/common.dart';
import '../../../../common/pickup_icon.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_divider.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/functions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/application/acc_bloc.dart';
import '../../../account/presentation/pages/paymentgateways.dart';
import '../../../home/domain/models/user_details_model.dart';
import '../../application/booking_bloc.dart';

class OnRideBottomSheet extends StatelessWidget {
  const OnRideBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if ((context.read<BookingBloc>().requestData != null &&
                      context.read<BookingBloc>().requestData!.acceptedAt !=
                          '' &&
                      context.read<BookingBloc>().requestData!.arrivedAt !=
                          "" &&
                      context.read<BookingBloc>().requestData!.isTripStart ==
                          0) &&
                  (context.read<BookingBloc>().waitingTime / 60)
                          .toStringAsFixed(0) !=
                      '0' && context.read<BookingBloc>().requestData!.isBidRide ==0 && !context.read<BookingBloc>().requestData!.isRental) 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Image.asset(
                      AppImages.waitingTime,
                      color: Theme.of(context).disabledColor,
                      width: size.width * 0.098,
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                        child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Theme.of(context).shadowColor,
                              spreadRadius: 1,
                              blurRadius: 1)
                        ],
                        color: AppColors.secondary,
                      ),
                      padding:
                          const EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: MyText(
                        text:
                            '${context
                                  .read<BookingBloc>()
                                  .formatDuration(
                                      context.read<BookingBloc>().waitingTime)
                                  .toString()} ${AppLocalizations.of(context)!.mins}',
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.black),
                      ),
                    ))
                  ],
                                ),
                ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: (context.read<BookingBloc>().requestData != null &&
                        context.read<BookingBloc>().driverData != null)
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: size.width * 0.03),
                          const CustomDivider(),
                          SizedBox(height: size.width * 0.03),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyText(
                                    text: ((context.read<BookingBloc>().requestData != null &&
                                            context
                                                    .read<BookingBloc>()
                                                    .requestData!
                                                    .acceptedAt !=
                                                '' &&
                                            context.read<BookingBloc>().requestData!.arrivedAt ==
                                                "" &&
                                            context
                                                    .read<BookingBloc>()
                                                    .requestData!
                                                    .isTripStart ==
                                                0))
                                        ? AppLocalizations.of(context)!.onTheWay
                                        : (context.read<BookingBloc>().requestData != null &&
                                                context
                                                        .read<BookingBloc>()
                                                        .requestData!
                                                        .acceptedAt !=
                                                    '' &&
                                                context
                                                        .read<BookingBloc>()
                                                        .requestData!
                                                        .arrivedAt !=
                                                    "" &&
                                                context
                                                        .read<BookingBloc>()
                                                        .requestData!
                                                        .isTripStart ==
                                                    0)
                                            ? AppLocalizations.of(context)!
                                                .driverArrived
                                            : AppLocalizations.of(context)!
                                                .reachingDestination,
                                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        color: Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.bold)),
                                if ((context.read<BookingBloc>().requestData !=
                                        null &&
                                    context
                                            .read<BookingBloc>()
                                            .requestData!
                                            .acceptedAt !=
                                        '' &&
                                    context
                                            .read<BookingBloc>()
                                            .requestData!
                                            .arrivedAt !=
                                        "" &&
                                    context
                                            .read<BookingBloc>()
                                            .requestData!
                                            .isTripStart ==
                                        0 &&
                                    context
                                        .read<BookingBloc>()
                                        .requestData!
                                        .showOtpFeature))
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Theme.of(context)
                                            .primaryColorDark
                                            .withOpacity(0.5)),
                                    child: Row(
                                      children: [
                                        MyText(
                                          text: 'OTP ',
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: (Theme.of(context).brightness==Brightness.light)?AppColors.white:AppColors.black,),
                                        ),
                                        MyText(
                                          text: context
                                              .read<BookingBloc>()
                                              .requestData!
                                              .rideOtp
                                              .toString(),
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  color: (Theme.of(context).brightness==Brightness.light)?AppColors.black:AppColors.white,
                                                  fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                          SizedBox(height: size.width * 0.03),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: HorizontalDotDividerWidget(),
                          ),
                          SizedBox(height: size.width * 0.02),
                          if (context.read<BookingBloc>().requestData != null &&
                              context
                                      .read<BookingBloc>()
                                      .requestData!
                                      .isTripStart ==
                                  0) ...[
                            Container(
                              width: size.width,
                              padding: EdgeInsets.fromLTRB(
                                  size.width * 0.05,
                                  size.width * 0.025,
                                  size.width * 0.05,
                                  size.width * 0.025),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            (context
                                                            .read<BookingBloc>()
                                                            .requestData!
                                                            .acceptedAt !=
                                                        '' &&
                                                    context
                                                            .read<BookingBloc>()
                                                            .requestData!
                                                            .arrivedAt ==
                                                        '' &&
                                                    context
                                                            .read<BookingBloc>()
                                                            .requestData!
                                                            .isTripStart ==
                                                        0)
                                                ? MyText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .driverArriveText
                                                        .replaceAll('**',
                                                            '${(context.read<BookingBloc>().duration.isNotEmpty && context.read<BookingBloc>().duration != '0') ? context.read<BookingBloc>().duration : 2}'),
                                                   textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!,
                                                    maxLines: 2,
                                                  )
                                                : (context
                                                                .read<
                                                                    BookingBloc>()
                                                                .requestData!
                                                                .acceptedAt !=
                                                            '' &&
                                                        context
                                                                .read<
                                                                    BookingBloc>()
                                                                .requestData!
                                                                .arrivedAt !=
                                                            '' &&
                                                        context
                                                                .read<
                                                                    BookingBloc>()
                                                                .requestData!
                                                                .isTripStart ==
                                                            0)
                                                    ? (context
                                                                .read<
                                                                    BookingBloc>()
                                                                .requestData!
                                                                .isBidRide ==
                                                            1 || context
                                                                .read<
                                                                    BookingBloc>()
                                                                .requestData!
                                                                .isRental)
                                                        ? MyText(
                                                            text: AppLocalizations
                                                                    .of(context)!
                                                                .driverArrivedLocation,
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall!,
                                                          )
                                                        : MyText(
                                                            text: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .arrivedMessage
                                                                .replaceAll(
                                                                    '***',
                                                                    '${context.read<BookingBloc>().requestData!.requestedCurrencySymbol} ${context.read<BookingBloc>().requestData!.waitingCharge}')
                                                                .replaceAll(
                                                                    '*', '5'),
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall!,
                                                            maxLines: 2,
                                                          )
                                                    : MyText(
                                                        text: AppLocalizations
                                                                .of(context)!
                                                            .reachingDestinationInMinutes
                                                            .replaceAll('***',
                                                                '${context.read<BookingBloc>().duration.isNotEmpty ? context.read<BookingBloc>().duration : 2}'),
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodySmall!,
                                                      ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.025),
                                ],
                              ),
                            ),
                          ],
                          SizedBox(height: size.width * 0.025),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 0.5,
                                      color: Theme.of(context)
                                          .disabledColor)),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: size.width * 0.11,
                                                width: size.width * 0.11,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Theme.of(context)
                                                        .disabledColor
                                                        .withOpacity(0.2)),
                                                alignment: Alignment.center,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: CachedNetworkImage(
                                                    imageUrl: context
                                                        .read<BookingBloc>()
                                                        .driverData!
                                                        .profilePicture,
                                                    fit: BoxFit.fill,
                                                    placeholder:
                                                        (context, url) =>
                                                            const Center(
                                                      child: Loader(),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Center(
                                                      child: Text(""),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.025),
                                              InkWell(
                                                onTap: () {},
                                                child: SizedBox(
                                                  width: size.width * 0.36,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      MyText(
                                                        text: context
                                                            .read<BookingBloc>()
                                                            .driverData!
                                                            .name,
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge!,
                                                        maxLines: 1,
                                                      ),
                                                      Wrap(
                                                        children: [
                                                         if(context
                                                                .read<
                                                                    BookingBloc>()
                                                                .driverData!
                                                                .rating!="0")...[Icon(
                                                            Icons.star,
                                                            size: 15,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                          MyText(
                                                            text: context
                                                                .read<
                                                                    BookingBloc>()
                                                                .driverData!
                                                                .rating,
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                    // color: Theme.of(context).primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          ),],
                                                          const SizedBox(width: 5),
                                                          if(context.read<BookingBloc>().driverData!.completedRides != 0)
                                                          Container(
                                                            width: 1,
                                                            height: 20,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                          const SizedBox( width: 5),
                                                          if(context.read<BookingBloc>().driverData!.completedRides != 0)
                                                          MyText(
                                                            text:
                                                                '${context.read<BookingBloc>().driverData!.completedRides} trips done',
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                    // color: Theme.of(context).primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: size.width * 0.01),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.35,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            height: size.width * 0.15,
                                            width: size.width * 0.15,
                                            child: CachedNetworkImage(
                                              imageUrl: context
                                                  .read<BookingBloc>()
                                                  .driverData!
                                                  .vehicleTypeImage
                                                  .toString(),
                                              height: size.width * 0.15,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child: Loader(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Center(
                                                child: Text(""),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColorDark)),
                                            child: MyText(
                                                text: context
                                                    .read<BookingBloc>()
                                                    .driverData!
                                                    .carNumber,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall),
                                          ),
                                          Wrap(
                                            children: [
                                              MyText(
                                                text:
                                                    '${context.read<BookingBloc>().driverData!.carModelName}|',
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!,
                                                maxLines: 1,
                                              ),
                                              MyText(
                                                text: context
                                                    .read<BookingBloc>()
                                                    .driverData!
                                                    .carMakeName,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.width * 0.03),
                          if (context
                                  .read<BookingBloc>()
                                  .requestData!
                                  .isTripStart ==
                              0) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        context.read<BookingBloc>().add(
                                            ChatWithDriverEvent(
                                                requestId: context
                                                    .read<BookingBloc>()
                                                    .requestData!
                                                    .id));
                                      },
                                      child: Container(
                                        height: size.width * 0.100,
                                        width: size.width * 0.110,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).disabledColor.withOpacity(0.3),
                                            border: Border.all(
                                                width: 0.5,
                                                color: Theme.of(context)
                                                    .primaryColorDark
                                                    .withOpacity(0.5))),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.message,
                                          size: size.width * 0.05,
                                          color: Theme.of(context).primaryColorDark,
                                        ),
                                      ),
                                    ),
                                    if (context
                                            .read<BookingBloc>()
                                            .chatHistoryList
                                            .isNotEmpty &&
                                        context
                                            .read<BookingBloc>()
                                            .chatHistoryList
                                            .where((element) =>
                                                element.fromType == 2 &&
                                                element.seen == 0)
                                            .isNotEmpty)
                                      Positioned(
                                        top: size.width * 0.01,
                                        right: size.width * 0.008,
                                        child: Container(
                                          height: size.width * 0.03,
                                          width: size.width * 0.03,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(
                                  width: size.width * 0.025,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await openUrl(
                                        "tel:${context.read<BookingBloc>().driverData!.mobile}");
                                  },
                                  child: Container(
                                    height: size.width * 0.100,
                                    width: size.width * 0.110,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).disabledColor.withOpacity(0.3),
                                        border: Border.all(
                                            width: 0.5,
                                            color: Theme.of(context)
                                                .primaryColorDark
                                                .withOpacity(0.5))),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.call,
                                      size: size.width * 0.05,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.025,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await Share.share(
                                        'Your Driver is ${context.read<BookingBloc>().driverData!.name}. ${context.read<BookingBloc>().driverData!.carColor} ${context.read<BookingBloc>().driverData!.carMakeName} ${context.read<BookingBloc>().driverData!.carModelName}, Vehicle Number: ${context.read<BookingBloc>().driverData!.carNumber}. Track with link: ${AppConstants.baseUrl}track/request/${context.read<BookingBloc>().requestData!.id}');
                                  },
                                  child: Container(
                                    height: size.width * 0.100,
                                    width: size.width * 0.110,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).disabledColor.withOpacity(0.3),
                                        border: Border.all(
                                            width: 0.5,
                                            color: Theme.of(context)
                                                .primaryColorDark
                                                .withOpacity(0.5))),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.share,
                                      size: size.width * 0.05,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                size.width * 0.05,
                                size.width * 0.025,
                                size.width * 0.05,
                                size.width * 0.025),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const PickupIcon(),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Expanded(
                                        child: MyText(
                                          maxLines: 2,
                                            text: context
                                                .read<BookingBloc>()
                                                .requestData!
                                                .pickAddress)),
                                  ],
                                ),
                                if (!context
                                    .read<BookingBloc>()
                                    .requestData!.isRental && context
                                    .read<BookingBloc>()
                                    .requestData!
                                    .requestStops
                                    .data
                                    .isNotEmpty) ...[
                                  ListView.separated(
                                    itemCount: context
                                        .read<BookingBloc>()
                                        .requestData!
                                        .requestStops
                                        .data
                                        .length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const DropIcon(),
                                          SizedBox(width: size.width * 0.02),
                                          Expanded(
                                              child: MyText(
                                                maxLines: 2,
                                                  text: context
                                                      .read<BookingBloc>()
                                                      .requestData!
                                                      .requestStops
                                                      .data[index]
                                                      .address)),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: size.width * 0.025),
                                            child:
                                                const VerticalDotDividerWidget(),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                                if (!context
                                    .read<BookingBloc>()
                                    .requestData!.isRental && context
                                    .read<BookingBloc>()
                                    .requestData!
                                    .requestStops
                                    .data
                                    .isEmpty && context
                                    .read<BookingBloc>()
                                    .requestData!
                                    .dropAddress.isNotEmpty) ...[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const DropIcon(),
                                      SizedBox(width: size.width * 0.02),
                                      Expanded(
                                          child: MyText(
                                            maxLines: 2,
                                              text: context
                                                  .read<BookingBloc>()
                                                  .requestData!
                                                  .dropAddress)),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          SizedBox(height: size.width * 0.02),
                          if (context.read<BookingBloc>().requestData!.isPetAvailable == 1 ||
                      context.read<BookingBloc>().requestData!.isLuggageAvailable == 1)
                    Column(
                      children: [
                        SizedBox(height: size.width * 0.05),
                        SizedBox(
                          width: size.width * 0.9,
                          child: Row(
                            children: [
                              MyText(text: 'Preferences :- ',
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color:
                                              Theme.of(context).primaryColorDark,fontWeight: FontWeight.w600)),
                              if (context.read<BookingBloc>()
                                                    .requestData!.isPetAvailable == 1)
                                Icon(
                                  Icons.pets,
                                  size: size.width * 0.05,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              if (context.read<BookingBloc>()
                                                    .requestData!.isLuggageAvailable ==
                                  1)
                                Icon(
                                  Icons.luggage,
                                  size: size.width * 0.05,
                                  color: Theme.of(context).primaryColorDark,
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.width * 0.02),
                          Container(
                            margin: EdgeInsets.only(
                                left: size.width * 0.05,
                                right: size.width * 0.05),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.5,
                                        child: MyText(
                                            text:context
                                                    .read<BookingBloc>()
                                                    .requestData!.isRental ?  context
                                                    .read<BookingBloc>()
                                                    .requestData!.rentalPackageName:AppLocalizations.of(context)!
                                                .rideFare,
                                            maxLines: 2,    
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.w600)),
                                      ),
                                      (context.read<BookingBloc>().requestData!.isBidRide ==
                                              1)
                                          ? MyText(
                                              text:
                                                  '${context.read<BookingBloc>().requestData!.requestedCurrencySymbol} ${context.read<BookingBloc>().requestData!.acceptedRideFare}',
                                              textStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                                                  color: AppColors.green,
                                                  fontWeight: FontWeight.bold))
                                          : (context.read<BookingBloc>().requestData!.discountedTotal != null &&
                                                  context
                                                          .read<BookingBloc>()
                                                          .requestData!
                                                          .discountedTotal !=
                                                      "")
                                              ? MyText(
                                                  text:
                                                      '${context.read<BookingBloc>().requestData!.requestedCurrencySymbol} ${context.read<BookingBloc>().requestData!.discountedTotal}',
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge!
                                                      .copyWith(
                                                          color:
                                                              AppColors.green,
                                                          fontWeight:
                                                              FontWeight.bold))
                                              : MyText(
                                                  text:
                                                      '${context.read<BookingBloc>().requestData!.requestedCurrencySymbol} ${context.read<BookingBloc>().requestData!.requestEtaAmount}',
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge!
                                                      .copyWith(
                                                          color: AppColors.green,
                                                          fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    MyText(
                                        text: context
                                                    .read<BookingBloc>()
                                                    .requestData!
                                                    .paymentOpt ==
                                                '1'
                                            ? AppLocalizations.of(context)!.cash
                                            : context
                                                        .read<BookingBloc>()
                                                        .requestData!
                                                        .paymentOpt ==
                                                    '2'
                                                ? AppLocalizations.of(context)!
                                                    .wallet
                                                : AppLocalizations.of(context)!
                                                    .card,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: size.width * 0.025,
                                    ),
                                    Icon(
                                      context
                                                  .read<BookingBloc>()
                                                  .requestData!
                                                  .paymentOpt ==
                                              '1'
                                          ? Icons.payments_outlined
                                          : context
                                                      .read<BookingBloc>()
                                                      .requestData!
                                                      .paymentOpt ==
                                                  '0'
                                              ? Icons.credit_card_rounded
                                              : Icons
                                                  .account_balance_wallet_outlined,
                                      size: size.width * 0.05,
                                      color: AppColors.green,
                                    ),
                                  ],
                                )

                                
                              ],
                            ),
                          ),
                          if (context
                                      .read<BookingBloc>()
                                      .requestData!
                                      .transportType ==
                                  'delivery' &&
                              !context.read<BookingBloc>().payAtDrop &&
                              context
                                      .read<BookingBloc>()
                                      .requestData!
                                      .paymentType !=
                                  'wallet' &&
                              context
                                      .read<BookingBloc>()
                                      .requestData!
                                      .paymentType !=
                                  'cash' &&
                              context.read<BookingBloc>().requestData!.isPaid ==
                                  0)
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: false,
                                    enableDrag: true,
                                    isDismissible: true,
                                    builder: (_) {
                                      return BlocProvider.value(
                                        value: context.read<BookingBloc>(),
                                        child: paymentGatewaysList(
                                            context,
                                            size,
                                            context
                                                .read<BookingBloc>()
                                                .requestData!
                                                .paymentGateways),
                                      );
                                    });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: size.width * 0.5,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: MyText(
                                          text:
                                              AppLocalizations.of(context)!.pay,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: size.width * 0.025),
                          if (context
                                  .read<BookingBloc>()
                                  .requestData!
                                  .isTripStart ==
                              0)
                            InkWell(
                              onTap: () {
                                context
                                    .read<BookingBloc>()
                                    .selectedCancelReason = '';
                                context.read<BookingBloc>().add(
                                    CancelReasonsEvent(
                                        beforeOrAfter: (context
                                                    .read<BookingBloc>()
                                                    .requestData!
                                                    .isDriverArrived ==
                                                0)
                                            ? 'before'
                                            : 'after'));
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          MyText(
                                            text: AppLocalizations.of(context)!
                                                .cancelRide,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: size.width * 0.05),
                        ],
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget paymentGatewaysList(BuildContext cont, Size size,
      List<PaymentGatewayData> walletPaymentGatways) {
    return BlocProvider(
      create: (context) => 
          AccBloc()..add(GetWalletHistoryListEvent(pageIndex: 1)),
      child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
        return walletPaymentGatways.isNotEmpty
            ? Column(
                children: [
                  SizedBox(height: size.width * 0.05),
                  Expanded(
                    child: ListView.builder(
                      itemCount: walletPaymentGatways.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return Column(
                          children: [
                            (walletPaymentGatways[index].enabled == true)
                                ? InkWell(
                                    onTap: () {
                                      context.read<AccBloc>().add(
                                          PaymentOnTapEvent(
                                              selectedPaymentIndex: index));
                                    },
                                    child: Container(
                                      width: size.width * 0.9,
                                      padding:
                                          EdgeInsets.all(size.width * 0.02),
                                      margin: EdgeInsets.only(
                                          bottom: size.width * 0.025),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              width: 0.5,
                                              color: Theme.of(context)
                                                  .primaryColorDark.withOpacity(0.5))),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(
                                                      size.width * 0.05),
                                                ),
                                                MyText(
                                                    text: walletPaymentGatways[
                                                            index]
                                                        .gateway
                                                        .toString(),
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,fontWeight: FontWeight.w600)),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: size.width * 0.05,
                                            height: size.width * 0.05,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 1.5,
                                                    color: Theme.of(context)
                                                        .primaryColorDark)),
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: size.width * 0.03,
                                              height: size.width * 0.03,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: (context
                                                              .read<AccBloc>()
                                                              .choosenPaymentIndex ==
                                                          index)
                                                      ? Theme.of(context)
                                                          .primaryColorDark
                                                      : Colors.transparent),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        );
                      },
                    ),
                  ),
                  CustomButton(
                      buttonName: AppLocalizations.of(cont)!.pay,
                      onTap: () async {
                        Navigator.pop(cont); // Use 'cont' instead of 'context'
                        Navigator.pushNamed(
                          cont,
                          PaymentGatwaysPage.routeName,
                          arguments: PaymentGateWayPageArguments(
                            currencySymbol: context
                                .read<BookingBloc>()
                                .requestData!
                                .requestedCurrencySymbol,
                            from: '1',
                            requestId:
                                context.read<BookingBloc>().requestData!.id,
                            money: (context
                                        .read<BookingBloc>()
                                        .requestData!
                                        .isBidRide ==
                                    1)
                                ? context
                                    .read<BookingBloc>()
                                    .requestData!
                                    .acceptedRideFare
                                : context
                                    .read<BookingBloc>()
                                    .requestData!
                                    .requestEtaAmount,
                            url: walletPaymentGatways[context
                                    .read<AccBloc>()
                                    .choosenPaymentIndex!]
                                .url,
                            userId: context
                                .read<BookingBloc>()
                                .requestData!
                                .userId
                                .toString(),
                          ),
                        ).then((value) {
                          if (!context.mounted) return;
                          if (value != null && value == true) {
                            showDialog(
                              context: cont, // Use 'cont' for the context here
                              barrierDismissible: false,
                              builder: (_) {
                                return AlertDialog(
                                  content: SizedBox(
                                    height: size.height * 0.4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          AppImages.paymentSuccess,
                                          fit: BoxFit.contain,
                                          width: size.width * 0.5,
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          AppLocalizations.of(cont)!
                                              .paymentSuccess,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(cont);
                                          },
                                          child: Text(AppLocalizations.of(cont)!
                                              .okText),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: cont, // Use 'cont' for the context here
                              barrierDismissible: false,
                              builder: (_) {
                                return AlertDialog(
                                  content: SizedBox(
                                    height: size.height * 0.4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          AppImages.paymentFail,
                                          fit: BoxFit.contain,
                                          width: size.width * 0.5,
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          AppLocalizations.of(cont)!
                                              .paymentFailed,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(cont);
                                          },
                                          child: Text(AppLocalizations.of(cont)!
                                              .okText),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        });
                      }),
                  SizedBox(
                    height: size.width * 0.05,
                  )
                ],
              )
            : const SizedBox();
      }),
    );
  }
}
