import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_snack_bar.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/booking_bloc.dart';

class ApplyCouponWidget extends StatelessWidget {
  final BookingPageArguments arg;
  const ApplyCouponWidget({
    super.key,
    required this.arg,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: AppLocalizations.of(context)!.applyCoupon,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Theme.of(context).primaryColorDark,fontWeight: FontWeight.w600,fontSize: 16),
                        ),
                        MyText(
                          text: AppLocalizations.of(context)!.applyCouponText,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Theme.of(context).disabledColor),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: size.width * 0.06,
                        width: size.width * 0.06,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              Theme.of(context).disabledColor.withOpacity(0.3),
                        ),
                        child: Center(
                          child: Icon(Icons.close,
                              size: 18,
                              color: Theme.of(context).primaryColorDark),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: CustomTextField(
                  controller: context.read<BookingBloc>().applyCouponController,
                  onChange: (p0) {
                    context.read<BookingBloc>().promoErrorText = '';
                    context.read<BookingBloc>().add(UpdateEvent());
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                  focusedBorder:
                      (context.read<BookingBloc>().promoErrorText.isNotEmpty)
                          ? OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            )
                          : OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).hintColor, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                  enabledBorder:
                      (context.read<BookingBloc>().promoErrorText.isNotEmpty)
                          ? OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            )
                          : OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).hintColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                  autofocus: false,
                  suffixConstraints: BoxConstraints(maxWidth: size.width * 0.1),
                  suffixIcon: context
                          .read<BookingBloc>()
                          .applyCouponController
                          .text
                          .isNotEmpty
                      ? InkWell(
                          onTap: () {
                            context.read<BookingBloc>().promoErrorText = '';
                            context
                                .read<BookingBloc>()
                                .applyCouponController
                                .clear();
                            context.read<BookingBloc>().add(UpdateEvent());
                          },
                          child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.cancel_outlined,
                                color: Theme.of(context).hintColor,
                              )),
                        )
                      : null,
                ),
              ),
              if (context.read<BookingBloc>().promoErrorText.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: MyText(
                        text: context.read<BookingBloc>().promoErrorText,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: AppColors.red)),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Center(
                  child: CustomButton(
                    width: size.width,
                    buttonColor: Theme.of(context).primaryColor,
                    buttonName: (context.read<BookingBloc>().isRentalRide
                            ? context
                                .read<BookingBloc>()
                                .rentalEtaDetailsList[context
                                    .read<BookingBloc>()
                                    .selectedVehicleIndex]
                                .hasDiscount
                            : context.read<BookingBloc>().isMultiTypeVechiles
                                ? context
                                    .read<BookingBloc>()
                                    .sortedEtaDetailsList[context
                                        .read<BookingBloc>()
                                        .selectedVehicleIndex]
                                    .hasDiscount
                                : context
                                    .read<BookingBloc>()
                                    .etaDetailsList[context
                                        .read<BookingBloc>()
                                        .selectedVehicleIndex]
                                    .hasDiscount)
                        ? AppLocalizations.of(context)!.remove
                        : AppLocalizations.of(context)!.apply,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (!context.read<BookingBloc>().isRentalRide) {
                        if (context.read<BookingBloc>().isMultiTypeVechiles
                            ? context
                                .read<BookingBloc>()
                                .sortedEtaDetailsList[context
                                    .read<BookingBloc>()
                                    .selectedVehicleIndex]
                                .hasDiscount
                            : context
                                .read<BookingBloc>()
                                .etaDetailsList[context
                                    .read<BookingBloc>()
                                    .selectedVehicleIndex]
                                .hasDiscount) {
                          context
                              .read<BookingBloc>()
                              .applyCouponController
                              .clear();
                          context.read<BookingBloc>().add(
                              BookingEtaRequestEvent(
                                  picklat: arg.picklat,
                                  picklng: arg.picklng,
                                  droplat: arg.droplat,
                                  droplng: arg.droplng,
                                  ridetype: 1,
                                  transporttype: arg.transportType,
                                  distance:
                                      context.read<BookingBloc>().distance,
                                  duration:
                                      context.read<BookingBloc>().duration,
                                  polyLine:
                                      context.read<BookingBloc>().polyLine,
                                  pickupAddressList: arg.pickupAddressList,
                                  dropAddressList: arg.stopAddressList,
                                  isOutstationRide: arg.isOutstationRide,
                                  isWithoutDestinationRide:
                                      arg.isWithoutDestinationRide ??
                                          false));
                        } else {
                          if (context
                              .read<BookingBloc>()
                              .applyCouponController
                              .text
                              .isNotEmpty) {
                            context.read<BookingBloc>().add(
                                BookingEtaRequestEvent(
                                    picklat: arg.picklat,
                                    picklng: arg.picklng,
                                    droplat: arg.droplat,
                                    droplng: arg.droplng,
                                    ridetype: 1,
                                    transporttype: arg.transportType,
                                    promocode: context
                                        .read<BookingBloc>()
                                        .applyCouponController
                                        .text,
                                    vehicleId: (arg.transportType != 'taxi')
                                        ? (context
                                                .read<BookingBloc>()
                                                .isMultiTypeVechiles)
                                            ? context
                                                .read<BookingBloc>()
                                                .sortedEtaDetailsList[context
                                                    .read<BookingBloc>()
                                                    .selectedVehicleIndex]
                                                .zoneTypeId
                                            : context
                                                .read<BookingBloc>()
                                                .etaDetailsList[context
                                                    .read<BookingBloc>()
                                                    .selectedVehicleIndex]
                                                .zoneTypeId
                                        : null,
                                    distance:
                                        context.read<BookingBloc>().distance,
                                    duration:
                                        context.read<BookingBloc>().duration,
                                    polyLine:
                                        context.read<BookingBloc>().polyLine,
                                    pickupAddressList: arg.pickupAddressList,
                                    dropAddressList: arg.stopAddressList,
                                    isOutstationRide: arg.isOutstationRide,
                                    isWithoutDestinationRide:
                                        arg.isWithoutDestinationRide ??
                                            false));
                          } else {
                            context.read<BookingBloc>().promoErrorText =
                                AppLocalizations.of(context)!
                                    .enterTheCredentials;
                            showToast(
                                message: AppLocalizations.of(context)!
                                    .enterTheCredentials);
                          }
                        }
                      } else {
                        // Rental Eta Promocode Apply
                        if (context
                            .read<BookingBloc>()
                            .rentalEtaDetailsList[context
                                .read<BookingBloc>()
                                .selectedVehicleIndex]
                            .hasDiscount) {
                          context
                              .read<BookingBloc>()
                              .applyCouponController
                              .clear();
                          context.read<BookingBloc>().add(
                              BookingRentalEtaRequestEvent(
                                  picklat: arg.picklat,
                                  picklng: arg.picklng,
                                  transporttype: arg.transportType));
                        } else {
                          if (context
                              .read<BookingBloc>()
                              .applyCouponController
                              .text
                              .isNotEmpty) {
                            context
                                .read<BookingBloc>()
                                .add(BookingRentalEtaRequestEvent(
                                  picklat: arg.picklat,
                                  picklng: arg.picklng,
                                  transporttype: arg.transportType,
                                  promocode: context
                                      .read<BookingBloc>()
                                      .applyCouponController
                                      .text,
                                ));
                          } else {
                            context.read<BookingBloc>().promoErrorText =
                                AppLocalizations.of(context)!
                                    .enterTheCredentials;
                            showToast(
                                message: AppLocalizations.of(context)!
                                    .enterTheCredentials);
                          }
                        }
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: size.width * 0.08),
              if ((!context.read<BookingBloc>().isRentalRide &&
                      (context.read<BookingBloc>().isMultiTypeVechiles
                  ? context
                      .read<BookingBloc>()
                      .sortedEtaDetailsList[
                          context.read<BookingBloc>().selectedVehicleIndex]
                      .hasDiscount
                  : context
                      .read<BookingBloc>()
                      .etaDetailsList[
                          context.read<BookingBloc>().selectedVehicleIndex]
                              .hasDiscount)) ||
                  (context.read<BookingBloc>().isRentalRide &&
                      context
                          .read<BookingBloc>()
                          .rentalEtaDetailsList[
                              context.read<BookingBloc>().selectedVehicleIndex]
                          .hasDiscount))
                Image.asset(AppImages.couponApplied, height: size.width * 0.5),
              SizedBox(height: size.width * 0.08)
            ],
          ),
        );
      },
    );
  }
}
