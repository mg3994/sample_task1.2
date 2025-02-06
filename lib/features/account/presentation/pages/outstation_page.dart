import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../common/common.dart';
import '../../../../common/pickup_icon.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../application/acc_bloc.dart';
import '../widgets/history_card_shimmer.dart';
import '../widgets/top_bar.dart';
import 'outstation_offered_page.dart';
import 'trip_summary_history.dart';

class OutstationHistoryPage extends StatelessWidget {
  final OutstationHistoryPageArguments arg;
  static const String routeName = '/outstationHistory';

  const OutstationHistoryPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(HistoryGetEvent(historyFilter: 'out_station=1')),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          } else if (state is HistoryDataLoadingState) {
            CustomLoader.loader(context);
          } else if (state is HistoryDataSuccessState) {
            CustomLoader.dismiss(context);
          }
        },
        child: BlocBuilder<AccBloc, AccState>(
          builder: (context, state) {
            return Directionality(
              textDirection: context.read<AccBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                body: TopBarDesign(
                  controller: context.read<AccBloc>().scrollController,
                  isHistoryPage: false,
                  title: AppLocalizations.of(context)!.outStation,
                  onTap: () {
                    if (arg.isFromBooking) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomePage.routeName, (route) => false);
                    } else {
                      Navigator.of(context).pop();
                    }
                    context.read<AccBloc>().scrollController.dispose();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: size.width * 0.05),
                        if (context.read<AccBloc>().isLoading)
                          HistoryShimmer(size: size),
                        if (!context.read<AccBloc>().isLoading &&
                            context.read<AccBloc>().history.isEmpty)
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppImages.noOutstation,
                                    height: 200,
                                    width: 200,
                                  ),
                                  const SizedBox(height: 10),
                                  MyText(
                                    text:
                                        AppLocalizations.of(context)!.noHistory,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .disabledColor,fontSize: 18),
                                  ),
                                  MyText(
                                    text: AppLocalizations.of(context)!
                                        .noHistoryText,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color:
                                              Theme.of(context).disabledColor,fontSize: 16
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: context.read<AccBloc>().history.length,
                              itemBuilder: (_, index) {
                                final history = context
                                    .read<AccBloc>()
                                    .history
                                    .elementAt(index);
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: InkWell(
                                        onTap: () {
                                          if (history.isLater == true) {
                                            if (history.isOutStation == 1 &&
                                                history.driverDetail == null) {
                                              Navigator.pushNamed(
                                                  context,
                                                  OutStationOfferedPage
                                                      .routeName,
                                                  arguments:
                                                      OutStationOfferedPageArguments(
                                                    requestId: history.id,
                                                    currencySymbol: history
                                                        .requestedCurrencySymbol,
                                                    dropAddress:
                                                        history.dropAddress,
                                                    pickAddress:
                                                        history.pickAddress,
                                                    updatedAt: history
                                                        .tripStartTimeWithDate,
                                                    offeredFare: history
                                                        .offerredRideFare
                                                        .toString(),
                                                    // userData: context
                                                    //     .read<AccBloc>()
                                                    //     .userData!
                                                  )).then(
                                                (value) {
                                                  if (!context.mounted) return;
                                                  context
                                                      .read<AccBloc>()
                                                      .history
                                                      .clear();
                                                  context.read<AccBloc>().add(
                                                      HistoryGetEvent(
                                                          historyFilter:
                                                              'is_later=1'));
                                                },
                                              );
                                            } else {
                                              Navigator.pushNamed(
                                                context,
                                                HistoryTripSummaryPage
                                                    .routeName,
                                                arguments: HistoryPageArguments(
                                                  historyData: history,
                                                ),
                                              ).then((value) {
                                                if (!context.mounted) return;
                                                context
                                                    .read<AccBloc>()
                                                    .history
                                                    .clear();
                                                context.read<AccBloc>().add(
                                                      HistoryGetEvent(
                                                          historyFilter:
                                                              'is_later=1'),
                                                    );
                                                context
                                                    .read<AccBloc>()
                                                    .add(AccUpdateEvent());
                                              });
                                            }
                                          } else {
                                            Navigator.pushNamed(
                                              context,
                                              HistoryTripSummaryPage.routeName,
                                              arguments: HistoryPageArguments(
                                                historyData: history,
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              bottom: size.width * 0.02),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              width: size.width * 0.001,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: Row(
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
                                                          text: history
                                                              .pickAddress,
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                        ),
                                                      ),
                                                    ),
                                                    MyText(
                                                      text: history
                                                          .cvTripStartTime,
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .disabledColor,
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (!history.isRental &&
                                                  history
                                                      .dropAddress.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
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
                                                            text: history
                                                                .dropAddress,
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                          ),
                                                        ),
                                                      ),
                                                      MyText(
                                                        text: history
                                                            .cvCompletedAt,
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodySmall!
                                                                .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              SizedBox(
                                                  height: size.width * 0.03),
                                              Container(
                                                padding: EdgeInsets.all(
                                                    size.width * 0.025),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    (history.isOutStation != 1)
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              MyText(
                                                                text: history
                                                                            .laterRide ==
                                                                        true
                                                                    ? history
                                                                        .tripStartTimeWithDate
                                                                    : history.isCompleted ==
                                                                            1
                                                                        ? history
                                                                            .convertedCompletedAt
                                                                        : history.isCancelled ==
                                                                                1
                                                                            ? history.convertedCancelledAt
                                                                            : history.convertedCreatedAt,
                                                                textStyle: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelMedium,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    width: 50,
                                                                    height: 50,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Theme.of(context)
                                                                            .scaffoldBackgroundColor),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                          history
                                                                              .vehicleTypeImage,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              const Center(
                                                                        child:
                                                                            Loader(),
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          const Center(
                                                                        child: Text(
                                                                            ""),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: size
                                                                            .width *
                                                                        0.025,
                                                                  ),
                                                                  MyText(
                                                                    text: history
                                                                        .vehicleTypeName,
                                                                    textStyle: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .labelMedium,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        : Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  MyText(
                                                                    text: (history.isOutStation ==
                                                                                1 &&
                                                                            history.isRoundTrip !=
                                                                                '')
                                                                        ? AppLocalizations.of(context)!
                                                                            .roundTrip
                                                                        : AppLocalizations.of(context)!
                                                                            .oneWayTrip,
                                                                    textStyle: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyLarge!
                                                                        .copyWith(
                                                                          color:
                                                                              Theme.of(context).primaryColorDark,
                                                                        ),
                                                                  ),
                                                                  if (history.isOutStation ==
                                                                          1 &&
                                                                      history.isRoundTrip !=
                                                                          '')
                                                                    const Icon(Icons
                                                                        .import_export)
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    width: 50,
                                                                    height: 50,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Theme.of(context)
                                                                            .scaffoldBackgroundColor),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                          history
                                                                              .vehicleTypeImage,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              const Center(
                                                                        child:
                                                                            Loader(),
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          const Center(
                                                                        child: Text(
                                                                            ""),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: size
                                                                            .width *
                                                                        0.025,
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      if (history.isOutStation == 1 &&
                                                                          history.isCancelled !=
                                                                              1 &&
                                                                          history.isCompleted !=
                                                                              1)
                                                                        MyText(
                                                                          text: (history.driverDetail != null)
                                                                              ? AppLocalizations.of(context)!.assigned
                                                                              : AppLocalizations.of(context)!.unAssigned,
                                                                          textStyle: Theme.of(context)
                                                                              .textTheme
                                                                              .labelMedium!
                                                                              .copyWith(fontWeight: FontWeight.w600, color: (history.driverDetail != null) ? AppColors.green : AppColors.red),
                                                                        ),
                                                                      MyText(
                                                                        text: history
                                                                            .vehicleTypeName,
                                                                        textStyle: Theme.of(context)
                                                                            .textTheme
                                                                            .labelMedium,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                    (history.isOutStation != 1)
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              MyText(
                                                                text: history
                                                                            .isCompleted ==
                                                                        1
                                                                    ? AppLocalizations.of(
                                                                            context)!
                                                                        .completed
                                                                    : history.isCancelled ==
                                                                            1
                                                                        ? AppLocalizations.of(context)!
                                                                            .cancelled
                                                                        : history.isLater ==
                                                                                true
                                                                            ? (history.isRental == false)
                                                                                ? AppLocalizations.of(context)!.upcoming
                                                                                : 'Rental ${history.rentalPackageName.toString()}'
                                                                            : '',
                                                                textStyle: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelMedium!
                                                                    .copyWith(
                                                                      color: history.isCompleted ==
                                                                              1
                                                                          ? AppColors
                                                                              .green
                                                                          : history.isCancelled == 1
                                                                              ? AppColors.red
                                                                              : history.isLater == true
                                                                                  ? AppColors.secondaryDark
                                                                                  : Theme.of(context).primaryColor,
                                                                    ),
                                                              ),
                                                              MyText(
                                                                  text: (history
                                                                              .isBidRide ==
                                                                          1)
                                                                      ? '${history.requestedCurrencySymbol} ${history.acceptedRideFare}'
                                                                      : (history.isCompleted ==
                                                                              1)
                                                                          ? '${history.requestBill.data.requestedCurrencySymbol} ${history.requestBill.data.totalAmount}'
                                                                          : '${history.requestedCurrencySymbol} ${history.requestEtaAmount}'),
                                                            ],
                                                          )
                                                        : Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              MyText(
                                                                text: (history.laterRide ==
                                                                            true &&
                                                                        history.isOutStation ==
                                                                            1)
                                                                    ? history
                                                                        .tripStartTime
                                                                    : (history.laterRide ==
                                                                                true &&
                                                                            history.isOutStation !=
                                                                                1)
                                                                        ? history
                                                                            .tripStartTimeWithDate
                                                                        : history.isCompleted ==
                                                                                1
                                                                            ? history.convertedCompletedAt
                                                                            : history.isCancelled == 1
                                                                                ? history.convertedCancelledAt
                                                                                : history.convertedCreatedAt,
                                                                textStyle: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelMedium,
                                                              ),
                                                              MyText(
                                                                text: history
                                                                    .returnTime,
                                                                textStyle: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelMedium,
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    size.width *
                                                                        0.025,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  MyText(
                                                                    text: (history.paymentOpt ==
                                                                            '1')
                                                                        ? AppLocalizations.of(context)!
                                                                            .cash
                                                                        : (history.paymentOpt ==
                                                                                '2')
                                                                            ? AppLocalizations.of(context)!.wallet
                                                                            : (history.paymentOpt == '0')
                                                                                ? AppLocalizations.of(context)!.card
                                                                                : '',
                                                                    textStyle: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyLarge!
                                                                        .copyWith(
                                                                          color:
                                                                              Theme.of(context).primaryColorDark,
                                                                        ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: size
                                                                            .width *
                                                                        0.025,
                                                                  ),
                                                                  MyText(
                                                                    text: (history.isOutStation ==
                                                                            1)
                                                                        ? '${history.requestedCurrencySymbol} ${history.offerredRideFare}'
                                                                        : (history.isBidRide ==
                                                                                1)
                                                                            ? '${history.requestedCurrencySymbol} ${history.acceptedRideFare}'
                                                                            : (history.isCompleted == 1)
                                                                                ? '${history.requestBill.data.requestedCurrencySymbol} ${history.requestBill.data.totalAmount}'
                                                                                : '${history.requestedCurrencySymbol} ${history.requestEtaAmount}',
                                                                    textStyle: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyLarge!
                                                                        .copyWith(
                                                                          color:
                                                                              Theme.of(context).primaryColorDark,
                                                                        ),
                                                                  ),
                                                                ],
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
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        if (context.read<AccBloc>().loadMore)
                          Center(
                            child: SizedBox(
                                height: size.width * 0.08,
                                width: size.width * 0.08,
                                child: const CircularProgressIndicator()),
                          ),
                        SizedBox(height: size.width * 0.2),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
