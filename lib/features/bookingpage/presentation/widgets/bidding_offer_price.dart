import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../common/common.dart';
import '../../../../common/pickup_icon.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_snack_bar.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/booking_bloc.dart';

Widget biddingPriceOffer(BuildContext context, BookingPageArguments arg) {
  final size = MediaQuery.of(context).size;

  return BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.width * 0.01),
            MyText(
                text: context.read<BookingBloc>().isMultiTypeVechiles
                    ? context
                        .read<BookingBloc>()
                        .sortedEtaDetailsList[
                            context.read<BookingBloc>().selectedVehicleIndex]
                        .name
                    : context
                        .read<BookingBloc>()
                        .etaDetailsList[
                            context.read<BookingBloc>().selectedVehicleIndex]
                        .name,
                textStyle: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: size.width * 0.03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: AppLocalizations.of(context)!.pickupLocation,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).disabledColor),
                ),
                SizedBox(height: size.width * 0.01),
                ListView.builder(
                    itemCount:
                        context.read<BookingBloc>().pickUpAddressList.length,
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
                          color:
                              Theme.of(context).disabledColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
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
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                SizedBox(height: size.width * 0.01),
                MyText(
                  text: AppLocalizations.of(context)!.dropLocation,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).disabledColor),
                ),
                SizedBox(height: size.width * 0.01),
                ListView.builder(
                    itemCount:
                        context.read<BookingBloc>().dropAddressList.length,
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
                          color:
                              Theme.of(context).disabledColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.005),
                                child: const DropIcon(),
                              ),
                              Expanded(
                                child: MyText(
                                  text: address.address,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
            SizedBox(height: size.width * 0.03),
            Center(
              child: MyText(
                  text: AppLocalizations.of(context)!.offerYourFare,
                  textStyle: Theme.of(context).textTheme.bodyLarge),
            ),
            SizedBox(height: size.width * 0.005),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                    text: AppLocalizations.of(context)!
                        .minimumRecommendedFare
                        .replaceAll('***',
                            '${context.read<BookingBloc>().isMultiTypeVechiles ? context.read<BookingBloc>().sortedEtaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].currency : context.read<BookingBloc>().etaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].currency} ${context.read<BookingBloc>().isMultiTypeVechiles ? context.read<BookingBloc>().sortedEtaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].minAmount.toStringAsFixed(2) : context.read<BookingBloc>().etaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].minAmount.toStringAsFixed(2)}'),
                    textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).disabledColor)),
              ],
            ),
            SizedBox(height: size.width * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: size.width * 0.03),
                Container(
                  width: size.width * 0.5,
                  decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    enabled: true,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.number,
                    controller: context.read<BookingBloc>().farePriceController,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide()),
                      prefixIconConstraints:
                          BoxConstraints(maxWidth: size.width * 0.2),
                      prefixIcon: Center(
                        child: MyText(
                          text: context.read<BookingBloc>().isMultiTypeVechiles
                              ? context
                                  .read<BookingBloc>()
                                  .sortedEtaDetailsList[context
                                      .read<BookingBloc>()
                                      .selectedVehicleIndex]
                                  .currency
                                  .toString()
                              : context
                                  .read<BookingBloc>()
                                  .etaDetailsList[context
                                      .read<BookingBloc>()
                                      .selectedVehicleIndex]
                                  .currency
                                  .toString(),
                          textStyle: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                SizedBox(width: size.width * 0.03),
              ],
            ),
            SizedBox(height: size.width * 0.05),
            Center(
              child: CustomButton(
                width: size.width,
                buttonColor: Theme.of(context).primaryColor,
                buttonName: AppLocalizations.of(context)!.createRequest,
                isLoader: context.read<BookingBloc>().isLoading,
                onTap: () {
                  if (double.parse(context
                          .read<BookingBloc>()
                          .farePriceController
                          .text) >=
                      (context.read<BookingBloc>().isMultiTypeVechiles
                          ? context
                              .read<BookingBloc>()
                              .sortedEtaDetailsList[context
                                  .read<BookingBloc>()
                                  .selectedVehicleIndex]
                              .total
                          : context
                              .read<BookingBloc>()
                              .etaDetailsList[context
                                  .read<BookingBloc>()
                                  .selectedVehicleIndex]
                              .total)) {
                    Navigator.pop(context);
                    if (arg.transportType == 'taxi' ||
                        (arg.transportType == 'delivery' &&
                            context.read<BookingBloc>().selectedGoodsTypeId !=
                                0)) {
                      context.read<BookingBloc>().add(BiddingCreateRequestEvent(
                          userData: arg.userData,
                          vehicleData: context.read<BookingBloc>().isMultiTypeVechiles
                              ? context.read<BookingBloc>().sortedEtaDetailsList[context
                                  .read<BookingBloc>()
                                  .selectedVehicleIndex]
                              : context.read<BookingBloc>().etaDetailsList[context
                                  .read<BookingBloc>()
                                  .selectedVehicleIndex],
                          pickupAddressList: arg.pickupAddressList,
                          dropAddressList: arg.stopAddressList,
                          selectedTransportType: arg.transportType,
                          paidAt: context.read<BookingBloc>().payAtDrop
                              ? 'Receiver'
                              : 'Sender',
                          selectedPaymentType:
                              context.read<BookingBloc>().selectedPaymentType,
                          scheduleDateTime:
                              context.read<BookingBloc>().scheduleDateTime,
                          goodsTypeId: context
                              .read<BookingBloc>()
                              .selectedGoodsTypeId
                              .toString(),
                          goodsQuantity: context
                              .read<BookingBloc>()
                              .goodsQtyController
                              .text,
                          offeredRideFare: context
                              .read<BookingBloc>()
                              .farePriceController
                              .text,
                          polyLine: context.read<BookingBloc>().polyLine,
                          isPetAvailable:
                              context.read<BookingBloc>().petPreference,
                          isLuggageAvailable:
                              context.read<BookingBloc>().luggagePreference,
                          isOutstationRide: arg.isOutstationRide,
                          isRoundTrip: context.read<BookingBloc>().isRoundTrip,
                          scheduleDateTimeForReturn: context.read<BookingBloc>().scheduleDateTimeForReturn));
                    } else {
                      showToast(
                          message: AppLocalizations.of(context)!
                              .pleaseSelectCredentials);
                    }
                  } else {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      enableDrag: false,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.0),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      builder: (_) {
                        return BlocProvider.value(
                          value: context.read<BookingBloc>(),
                          child: Container(
                            width: size.width,
                            height: size.width * 0.5,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  MyText(
                                    text: AppLocalizations.of(context)!
                                        .minimumRideFareError,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                  ),
                                  SizedBox(height: size.width * 0.1),
                                  CustomButton(
                                    width: size.width,
                                    buttonName:
                                        AppLocalizations.of(context)!.okText,
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: size.width * 0.05),
          ],
        ),
      ),
    );
  });
}
