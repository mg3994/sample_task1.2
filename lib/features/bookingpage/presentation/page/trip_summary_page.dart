import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:restart_tagxi/features/account/application/acc_bloc.dart";
import "package:restart_tagxi/features/account/presentation/pages/paymentgateways.dart";
import "package:restart_tagxi/features/bookingpage/presentation/page/give_ratings_page.dart";
import "package:restart_tagxi/features/home/domain/models/user_details_model.dart";
import "../../../../common/common.dart";
import "../../../../common/pickup_icon.dart";
import "../../../../core/utils/custom_button.dart";
import "../../../../core/utils/custom_loader.dart";
import "../../../../core/utils/custom_text.dart";
import "../../../../l10n/app_localizations.dart";
import "../../application/booking_bloc.dart";
import "../widgets/fare_breakup.dart";

class TripSummaryPage extends StatelessWidget {
  static const String routeName = '/tripsummary';
  final TripSummaryPageArguments arg;
  TripSummaryPage({super.key, required this.arg});

  final bookingBloc = BookingBloc();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider.value(
      value: bookingBloc,
      child: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is WalletPageReUpdateStates) {
            Navigator.pushNamed(
              context,
              PaymentGatwaysPage.routeName,
              arguments: PaymentGateWayPageArguments(
                currencySymbol: state.currencySymbol,
                from: '1',
                requestId: state.requestId,
                money: state.money,
                url: state.url,
                userId: state.userId,
              ),
            ).then((value) {
              if (!context.mounted) return;
              if (value != null && value == true) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return PopScope(
                      canPop: false,
                      child: AlertDialog(
                        content: SizedBox(
                          height: size.height * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.paymentSuccess,
                                fit: BoxFit.contain,
                                width: size.width * 0.5,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                AppLocalizations.of(context)!.paymentSuccess,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RatingsPage.routeName,
                                      arguments: RatingsPageArguments(
                                          requestId: arg.requestData.id,
                                          driverData: arg.driverData),
                                      (route) => false);
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.okText),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                if (!context.mounted) return;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return PopScope(
                      canPop: false,
                      child: AlertDialog(
                        content: SizedBox(
                          height: size.height * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.paymentFail,
                                fit: BoxFit.contain,
                                width: size.width * 0.5,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                AppLocalizations.of(context)!.paymentFailed,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.okText),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            });
          }
        },
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipPath(
                        clipper: ShapePainterBottom(),
                        child: Container(
                          padding: EdgeInsets.all(size.width * 0.025),
                          width: size.width,
                          height: size.height * 0.9,
                          color: const Color(0xffDEDCDC),
                          child: ClipPath(
                            clipper: ShapePainterCenter(),
                            child: Container(
                              padding: EdgeInsets.all(size.width * 0.05),
                              width: size.width,
                              height: size.height * 0.5,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Column(
                                children: [
                                  SizedBox(height: size.width * 0.4),
                                  Row(
                                    children: [
                                      MyText(
                                        text: arg.requestData.requestNumber,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.width * 0.05,
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: size.width * 0.05,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(
                                                size.width * 0.05),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .disabledColor
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.play_arrow,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorDark,
                                                        ),
                                                        MyText(
                                                          text: AppLocalizations
                                                                  .of(context)!
                                                              .duration,
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor
                                                                      .withOpacity(
                                                                          0.7)),
                                                        )
                                                      ],
                                                    )),
                                                    MyText(
                                                      text:
                                                          '${arg.requestData.totalTime} ${AppLocalizations.of(context)!.mins}',
                                                      textStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .scaffoldBackgroundColor
                                                                  .withOpacity(
                                                                      0.7)),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: size.width * 0.025),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.play_arrow,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorDark,
                                                        ),
                                                        MyText(
                                                          text: AppLocalizations
                                                                  .of(context)!
                                                              .distance,
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor
                                                                      .withOpacity(
                                                                          0.7)),
                                                        )
                                                      ],
                                                    )),
                                                    MyText(
                                                      text:
                                                          '${arg.requestData.totalDistance} ${arg.requestData.unit}',
                                                      textStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .scaffoldBackgroundColor
                                                                  .withOpacity(
                                                                      0.7)),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: size.width * 0.025),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.play_arrow,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorDark,
                                                        ),
                                                        MyText(
                                                          text: AppLocalizations
                                                                  .of(context)!
                                                              .typeofRide,
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor
                                                                      .withOpacity(
                                                                          0.7)),
                                                        )
                                                      ],
                                                    )),
                                                    MyText(
                                                      text: (arg.requestData
                                                                  .isOutStation ==
                                                              '1')
                                                          ? AppLocalizations.of(
                                                                  context)!
                                                              .outStation
                                                          : (arg.requestData
                                                                  .isRental)
                                                              ? AppLocalizations
                                                                      .of(
                                                                          context)!
                                                                  .rental
                                                              : AppLocalizations
                                                                      .of(context)!
                                                                  .regular,
                                                      textStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .scaffoldBackgroundColor
                                                                  .withOpacity(
                                                                      0.7)),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: size.width * 0.05),
                                          Container(
                                            padding: EdgeInsets.all(
                                                size.width * 0.020),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              border: Border.all(
                                                width: size.width * 0.001,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const PickupIcon(),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5),
                                                        child: MyText(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          text: arg.requestData
                                                              .pickAddress,
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (arg.requestData.requestStops
                                                    .data.isNotEmpty)
                                                  ListView.separated(
                                                    itemCount: arg
                                                        .requestData
                                                        .requestStops!
                                                        .data
                                                        .length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    padding: EdgeInsets.zero,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const DropIcon(),
                                                          SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.02),
                                                          Expanded(
                                                            child: MyText(
                                                              text: arg
                                                                  .requestData
                                                                  .requestStops!
                                                                  .data[index]
                                                                  .address,
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (context, index) {
                                                      return SizedBox(
                                                          height: size.width *
                                                              0.0025);
                                                    },
                                                  ),
                                                if (arg.requestData.requestStops
                                                    .data.isEmpty)
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        const DropIcon(),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 5),
                                                            child: MyText(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              text: arg
                                                                  .requestData
                                                                  .dropAddress,
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: size.width * 0.05),
                                          if (arg.requestData.isBidRide ==
                                              1) ...[
                                            Center(
                                              child: MyText(
                                                text: (arg.requestData
                                                            .paymentOpt ==
                                                        '1')
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .cash
                                                    : (arg.requestData
                                                                .paymentOpt ==
                                                            '2')
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .wallet
                                                        : AppLocalizations.of(
                                                                context)!
                                                            .card,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColorDark,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                                height: size.width * 0.025),
                                            Center(
                                              child: MyText(
                                                  text:
                                                      '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.totalAmount}',
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(fontSize: 25)),
                                            )
                                          ],
                                          if (arg.requestData.isBidRide ==
                                              0) ...[
                                            Center(
                                              child: MyText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .fareBreakup,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColorDark,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(
                                                height: size.width * 0.025),
                                            Column(
                                              children: [
                                                if (arg.requestBillData
                                                        .basePrice !=
                                                    0)
                                                  FareBreakup(
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .basePrice,
                                                      price:
                                                          '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.basePrice}'),
                                                if (arg.requestBillData
                                                        .distancePrice !=
                                                    0)
                                                  FareBreakup(
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .distancePrice,
                                                      price:
                                                          '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.distancePrice}'),
                                                if (arg.requestBillData
                                                        .timePrice !=
                                                    0)
                                                  FareBreakup(
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .timePrice,
                                                      price:
                                                          '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.timePrice}'),
                                                if (arg.requestBillData
                                                        .waitingCharge !=
                                                    0)
                                                  FareBreakup(
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .waitingPrice,
                                                      price:
                                                          '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.waitingCharge}'),
                                                if (arg.requestBillData
                                                        .adminCommision !=
                                                    0)
                                                  FareBreakup(
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .convenienceFee,
                                                      price:
                                                          '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.adminCommision}'),
                                                if (arg.requestBillData
                                                        .promoDiscount !=
                                                    0)
                                                  FareBreakup(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .discount,
                                                    price:
                                                        '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.promoDiscount}',
                                                    textcolor: Theme.of(context)
                                                        .primaryColorDark,
                                                    pricecolor:
                                                        Theme.of(context)
                                                            .primaryColorDark,
                                                  ),
                                                FareBreakup(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .taxes,
                                                    price:
                                                        '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.serviceTax}'),
                                              ],
                                            ),
                                          ],
                                          SizedBox(height: size.width * 0.025),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.4,
                                        child: Row(
                                          children: [
                                            MyText(
                                              text:
                                                  (arg.requestData.paymentOpt ==
                                                          '1')
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .cash
                                                      : (arg.requestData
                                                                  .paymentOpt ==
                                                              '2')
                                                          ? AppLocalizations.of(
                                                                  context)!
                                                              .wallet
                                                          : AppLocalizations.of(
                                                                  context)!
                                                              .card,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColorDark,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.025,
                                            ),
                                            MyText(
                                              text:
                                                  '${arg.requestBillData.requestedCurrencySymbol} ${arg.requestBillData.totalAmount}',
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          size.width * 0.045),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.02,
                                      ),
                                      Expanded(
                                        child: CustomButton(
                                          buttonColor:
                                              Theme.of(context).primaryColor,
                                          buttonName:
                                              AppLocalizations.of(context)!
                                                  .confirm,
                                          onTap: () {
                                            if (arg.requestData.isCompleted ==
                                                        1 &&
                                                    arg.requestData.isPaid ==
                                                        1 ||
                                                arg.requestData.isCompleted ==
                                                        1 &&
                                                    (arg.requestData
                                                                .paymentTypeString ==
                                                            'cash' ||
                                                        arg.requestData
                                                                .paymentTypeString ==
                                                            'wallet')) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  RatingsPage.routeName,
                                                  arguments:
                                                      RatingsPageArguments(
                                                          requestId: arg
                                                              .requestData.id,
                                                          driverData:
                                                              arg.driverData),
                                                  (route) => false);
                                            } else if (arg.requestData
                                                        .isCompleted ==
                                                    1 &&
                                                arg.requestData.isPaid == 0 &&
                                                (arg.requestData
                                                            .paymentTypeString ==
                                                        'card' ||
                                                    arg.requestData
                                                            .paymentTypeString ==
                                                        'online')) {
                                              if (arg.requestData
                                                  .paymentGateways.isNotEmpty) {
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: false,
                                                    enableDrag: true,
                                                    isDismissible: true,
                                                    builder: (_) {
                                                      return BlocProvider.value(
                                                        value: context.read<
                                                            BookingBloc>(),
                                                        child: paymentGatewaysList(
                                                            context,
                                                            size,
                                                            arg.requestData
                                                                .paymentGateways),
                                                      );
                                                    });
                                              }
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      top: size.height * 0.18,
                      child: SizedBox(
                        width: size.width,
                        child: Column(
                          children: [
                            SizedBox(
                              width: size.width * 0.8,
                              child: MyText(
                                text: arg.driverData.name.toUpperCase(),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: AppColors.white),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(height: size.width * 0.025),
                            Container(
                              height: size.width * 0.2,
                              width: size.width * 0.2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Theme.of(context).dividerColor),
                              child: (arg.driverData.profilePicture.isEmpty)
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: CachedNetworkImage(
                                        imageUrl: arg.driverData.profilePicture,
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: Loader(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                          child: Text(""),
                                        ),
                                      ),
                                    ),
                            )
                          ],
                        ),
                      )),
                  Positioned(
                      child: SafeArea(
                    child: Column(
                      children: [
                        SizedBox(height: size.width * 0.05),
                        Container(
                          height: size.width * 0.1,
                          width: size.width * 0.5,
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: size.width * 0.065,
                                width: size.width * 0.065,
                                child: Image.asset(AppImages.tripSummary),
                              ),
                              SizedBox(width: size.width * 0.05),
                              MyText(
                                text: AppLocalizations.of(context)!.tripSummary,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).disabledColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget paymentGatewaysList(BuildContext currentContext, Size size,
      List<PaymentGatewayData> walletPaymentGatways) {
    return BlocBuilder<AccBloc, AccState>(builder: (context, state) {
      return Column(
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
                    // (walletPaymentGatways[index].enabled == true)
                    //     ?
                    InkWell(
                      onTap: () {
                        context.read<AccBloc>().add(
                            PaymentOnTapEvent(selectedPaymentIndex: index));
                      },
                      child: Container(
                        width: size.width * 0.9,
                        padding: EdgeInsets.all(size.width * 0.02),
                        margin: EdgeInsets.only(bottom: size.width * 0.025),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 0.5,
                                color: Theme.of(context)
                                    .primaryColorDark
                                    .withOpacity(0.5))),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(size.width * 0.05),
                                  ),
                                  MyText(
                                      text: walletPaymentGatways[index]
                                          .gateway
                                          .toString(),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontWeight: FontWeight.w600)),
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
                                      color:
                                          Theme.of(context).primaryColorDark)),
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
                                        ? Theme.of(context).primaryColorDark
                                        : Colors.transparent),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                    // : Container(),
                  ],
                );
              },
            ),
          ),
          CustomButton(
              buttonName: AppLocalizations.of(currentContext)!.pay,
              onTap: () async {
                Navigator.pop(context); // Use 'cont' instead of 'context'
                context.read<BookingBloc>().add(WalletPageReUpdateEvents(
                      currencySymbol: arg.requestData.requestedCurrencySymbol,
                      from: '1',
                      requestId: arg.requestData.id,
                      money: (arg.requestData.isBidRide == 1)
                          ? arg.requestData.acceptedRideFare
                          : arg.requestData.requestEtaAmount,
                      url: walletPaymentGatways[
                              context.read<AccBloc>().choosenPaymentIndex!]
                          .url,
                      userId: arg.requestData.userId.toString(),
                    ));
              }),
          SizedBox(
            height: size.width * 0.05,
          )
        ],
      );
    });
  }
}

class ShapePainterBottom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.35);
    path.quadraticBezierTo(size.width * 0.985, size.height * 0.25,
        size.width * 0.8, size.height * 0.225);
    path.lineTo(size.width * 0.15, size.height * 0.13);
    path.quadraticBezierTo(size.width * 0, size.height * 0.1, 0, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ShapePainterCenter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height * 0.125);
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(0, size.height, 20, size.height);
    path.lineTo(size.width - 20, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 20);
    path.lineTo(size.width * 0.99, size.height * 0.335);
    path.quadraticBezierTo(size.width * 0.965, size.height * 0.25,
        size.width * 0.8, size.height * 0.23);
    path.lineTo(10, size.height * 0.123);
    path.quadraticBezierTo(size.width * 0.0, size.height * 0.12,
        size.width * 0.0, size.height * 0.14);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
