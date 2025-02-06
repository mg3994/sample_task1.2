import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/core/utils/custom_divider.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../common/common.dart';
import '../../../../common/pickup_icon.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_container.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/booking_bloc.dart';

class WaitingForDriverConfirmation extends StatelessWidget {
  final double maximumTime;

  const WaitingForDriverConfirmation({
    super.key,
    required this.maximumTime,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        final timerDuration = context.read<BookingBloc>().timerDuration;
        return Container(
          width: size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.width * 0.02),
                const Center(child: CustomDivider()),
                SizedBox(height: size.width * 0.02),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          Theme.of(context).disabledColor.withOpacity(0.1),
                      child: Image.asset(AppImages.defaultProfile),
                    ),
                    SizedBox(width: size.width * 0.02),
                    MyText(
                      text: AppLocalizations.of(context)!.discoverYourCaptain,
                      textStyle:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).primaryColorDark,fontWeight: FontWeight.w600,
                              ),
                    ),
                  ],
                ),
                SizedBox(height: size.width * 0.02),
                Container(
                  height: size.width * 0.02,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.width * 0.024),
                    color: (timerDuration == 0)
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: size.width * 0.02,
                    width: (size.width * 0.9 * (timerDuration / maximumTime)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size.width * 0.024),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyText(
                      text:
                          '${Duration(seconds: timerDuration).toString().substring(3, 7)} ${AppLocalizations.of(context)!.mins}',
                      textStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: size.width * 0.04),
                MyText(
                  text: AppLocalizations.of(context)!.bookingDetails,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).disabledColor),
                ),
                SizedBox(height: size.width * 0.03),
                CustomContainer(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Column(
                      children: [
                        ListView.builder(
                            itemCount: context
                                .read<BookingBloc>()
                                .pickUpAddressList
                                .length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final address = context
                                  .read<BookingBloc>()
                                  .pickUpAddressList
                                  .elementAt(index);
                              return Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.01),
                                        child: const PickupIcon(),
                                      ),
                                      Expanded(
                                        child: MyText(
                                          text: address.address,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        SizedBox(height: size.width * 0.01),
                        ListView.builder(
                            itemCount: context
                                .read<BookingBloc>()
                                .dropAddressList
                                .length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final address = context
                                  .read<BookingBloc>()
                                  .dropAddressList
                                  .elementAt(index);
                              return Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.005),
                                        child: Icon(Icons.place_rounded,
                                            size: 20,
                                            color:
                                                Theme.of(context).primaryColorDark),
                                      ),
                                      Expanded(
                                        child: MyText(
                                          text: address.address,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.width * 0.05),
                if (context.read<BookingBloc>().requestData != null) ...[
                  MyText(
                    text: AppLocalizations.of(context)!.rideDetails,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Theme.of(context).disabledColor),
                  ),
                  SizedBox(height: size.width * 0.03),
                  CustomContainer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          Center(
                            child: CachedNetworkImage(
                              imageUrl: context
                                  .read<BookingBloc>()
                                  .requestData!
                                  .vehicleTypeImage,
                              height: size.width * 0.1,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: Loader(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Text(""),
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.02),
                          MyText(
                            text: context
                                .read<BookingBloc>()
                                .requestData!
                                .vehicleTypeName,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: size.width * 0.03),
                MyText(
                  text: AppLocalizations.of(context)!.payment,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).disabledColor),
                ),
                SizedBox(height: size.width * 0.03),
                CustomContainer(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      children: [
                        Icon(
                            context.read<BookingBloc>().selectedPaymentType ==
                                    'cash'
                                ? Icons.payments_outlined
                                : context
                                            .read<BookingBloc>()
                                            .selectedPaymentType ==
                                        'card'
                                    ? Icons.credit_card_rounded
                                    : Icons.account_balance_wallet_outlined,
                            color: Theme.of(context).primaryColorDark),
                        SizedBox(width: size.width * 0.05),
                        MyText(
                          text: context.read<BookingBloc>().selectedPaymentType,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.width * 0.05),
                MyText(
                  text: AppLocalizations.of(context)!.manageRide,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).disabledColor),
                ),
                SizedBox(height: size.width * 0.03),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      isScrollControlled: true,
                      enableDrag: false,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.0),
                        ),
                      ),
                      builder: (_) {
                        return BlocProvider.value(
                            value: context.read<BookingBloc>(),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // SizedBox(height: size.width * 0.1),
                                  Center(
                                      child: Image.asset(AppImages.cancelGif,
                                          height: size.width * 0.2)),
                                  Center(
                                    child: MyText(
                                      text: AppLocalizations.of(context)!
                                          .cancelRide,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColorDark),
                                    ),
                                  ),
                                  SizedBox(height: size.width * 0.05),
                                  Center(
                                    child: MyText(
                                      text: AppLocalizations.of(context)!
                                          .cancelRideText,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                  SizedBox(height: size.width * 0.05),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomButton(
                                        buttonName:
                                            AppLocalizations.of(context)!
                                                .cancelRide,
                                        borderRadius: 5,
                                        isBorder: true,
                                        width: size.width * 0.4,
                                        height: size.width * 0.1,
                                        buttonColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        textColor:
                                            Theme.of(context).primaryColor,
                                        onTap: () {
                                          context
                                              .read<BookingBloc>()
                                              .timerCount(context,
                                                  duration: 0,
                                                  isNormalRide: true,
                                                  isCloseTimer: true);
                                          context
                                              .read<BookingBloc>()
                                              .onRideBottomPosition = -250;
                                          context.read<BookingBloc>().add(
                                              BookingCancelRequestEvent(
                                                  requestId: context
                                                      .read<BookingBloc>()
                                                      .requestData!
                                                      .id));
                                        },
                                      ),
                                      CustomButton(
                                        buttonName:
                                            AppLocalizations.of(context)!.back,
                                        borderRadius: 5,
                                        width: size.width * 0.4,
                                        height: size.width * 0.1,
                                        buttonColor:
                                            Theme.of(context).primaryColor,
                                        textColor: AppColors.white,
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                  SizedBox(height: size.width * 0.1),
                                ],
                              ),
                            ));
                      },
                    );
                  },
                  child: CustomContainer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.cancel_outlined,
                              color: AppColors.red),
                          SizedBox(width: size.width * 0.05),
                          MyText(
                            text: AppLocalizations.of(context)!.cancelRide,
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
