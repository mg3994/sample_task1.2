import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:restart_tagxi/core/utils/custom_button.dart";
import "package:restart_tagxi/features/account/presentation/widgets/top_bar.dart";
import "package:shimmer/shimmer.dart";
import "../../../../common/common.dart";
import "../../../../core/utils/custom_loader.dart";
import "../../../../core/utils/custom_text.dart";
import "../../../../l10n/app_localizations.dart";
import "../../application/acc_bloc.dart";

class OutStationOfferedPage extends StatelessWidget {
  static const String routeName = '/outStationOfferedPage';
  final OutStationOfferedPageArguments args;
  const OutStationOfferedPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(OutstationGetEvent(id: args.requestId)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          } else if (state is AccDataLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is AccDataLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is RequestCancelState) {
            Navigator.pop(context);
          } else if (state is OutstationAcceptState) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Directionality(
              textDirection: context.read<AccBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                  // bottomNavigationBar: cancelRide(context, size),
                  body: TopBarDesign(
                controller: context.read<AccBloc>().scrollController,
                isHistoryPage: false,
                title: AppLocalizations.of(context)!.offeredRide,
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<AccBloc>().scrollController.dispose();
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    offset: const Offset(0, 0),
                                    blurRadius: 1,
                                    spreadRadius: 1)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyText(
                                    text: AppLocalizations.of(context)!
                                        .myOfferedFare,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!),
                                MyText(
                                    text:
                                        '${args.currencySymbol} ${args.offeredFare}',
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: size.width * 0.03),
                        if (context.read<AccBloc>().outstation.isEmpty &&
                            context.read<AccBloc>().outStationBidStream !=
                                null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Theme.of(context).primaryColor,
                                direction: ShimmerDirection.rtl,
                                child: Container(
                                  width: size.width * 0.45,
                                  height: size.width * 0.02,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Theme.of(context).primaryColor,
                                direction: ShimmerDirection.ltr,
                                child: Container(
                                  width: size.width * 0.45,
                                  height: size.width * 0.02,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).disabledColor,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.width * 0.03),
                        ],
                        if (context.read<AccBloc>().outstation.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MyText(
                                text:
                                    AppLocalizations.of(context)!.chooseAdriver,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        SizedBox(height: size.width * 0.02),
                        if (context.read<AccBloc>().outstation.isEmpty)
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: size.width * 0.1),
                                  Image.asset(
                                    AppImages.noOutstation,
                                    height: 200,
                                    width: 200,
                                  ),
                                  const SizedBox(height: 10),
                                  MyText(
                                    text: AppLocalizations.of(context)!
                                        .noBidRideContent,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color:
                                              Theme.of(context).disabledColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: size.width * 0.05),
                        if (context.read<AccBloc>().outstation.isNotEmpty)
                          SizedBox(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount:
                                  context.read<AccBloc>().outstation.length,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final driver = context
                                    .read<AccBloc>()
                                    .outstation
                                    .elementAt(index);
                                return Container(
                                  width: size.width,
                                  decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Theme.of(context).shadowColor,
                                            offset: const Offset(0, 0),
                                            blurRadius: 1,
                                            spreadRadius: 1)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                MyText(
                                                  text: args.currencySymbol +
                                                      driver['price'],
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorDark,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: size.width * 0.02),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      width: size.width * 0.1,
                                                      height: size.width * 0.1,
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: CachedNetworkImage(
                                                        imageUrl: driver[
                                                            'driver_img'],
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(
                                                          child: Loader(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Center(
                                                          child: Text(""),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    width: size.width * 0.05),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          MyText(
                                                            text: driver[
                                                                'driver_name'],
                                                            maxLines: 1,
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.02),
                                                          const Icon(
                                                              Icons
                                                                  .star_border_purple500_rounded,
                                                              color: AppColors
                                                                  .goldenColor),
                                                          SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.01),
                                                          MyText(
                                                            text: driver[
                                                                'rating'],
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColorDark,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            size.width * 0.01,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          MyText(
                                                            text:
                                                                '${driver['vehicle_make']}',
                                                            maxLines: 1,
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          MyText(
                                                            text:
                                                                '${context.read<AccBloc>().outStationDriver.elementAt(index)} km',
                                                            maxLines: 1,
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: size.width * 0.03),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CustomButton(
                                                  onTap: () {
                                                    context.read<AccBloc>().add(
                                                        OutstationAcceptOrDeclineEvent(
                                                            id: args.requestId,
                                                            offeredRideFare:
                                                                args.offeredFare,
                                                            isAccept: false,
                                                            driver: driver));
                                                  },
                                                  // isBorder: true,
                                                  buttonName:
                                                      AppLocalizations.of(
                                                              context)!
                                                          .decline,
                                                  width: size.width * 0.4,
                                                  buttonColor: Theme.of(context)
                                                      .disabledColor
                                                      .withOpacity(0.2),
                                                  textColor: Theme.of(context)
                                                      .primaryColorDark,
                                                ),
                                                CustomButton(
                                                  onTap: () {
                                                    context.read<AccBloc>().add(
                                                        OutstationAcceptOrDeclineEvent(
                                                            id: args.requestId,
                                                            offeredRideFare:
                                                                args.offeredFare,
                                                            isAccept: true,
                                                            driver: driver));
                                                  },
                                                  buttonName:
                                                      AppLocalizations.of(
                                                              context)!
                                                          .accept,
                                                  width: size.width * 0.4,
                                                  buttonColor: AppColors.green,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(height: size.width * 0.02);
                              },
                            ),
                          ),
                        SizedBox(height: size.width * 0.03),
                        CustomButton(
                          onTap: () {
                            context.read<AccBloc>().add(
                                  RideLaterCancelRequestEvent(
                                      requestId: args.requestId),
                                );
                          },
                          // isBorder: true,
                          borderRadius: 30,
                          buttonName: AppLocalizations.of(context)!.cancelRide,
                          width: size.width * 0.8,
                          buttonColor: AppColors.red,
                          textColor: AppColors.white,
                        ),
                        SizedBox(height: size.width * 0.05),
                      ],
                    ),
                  ),
                ),
              )));
        }),
      ),
    );
  }

  Widget cancelRide(BuildContext context, Size size) {
    return StatefulBuilder(builder: (_, add) {
      return Container(
        padding: MediaQuery.of(context).viewInsets,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.05),
                topRight: Radius.circular(size.width * 0.05))),
        width: size.width,
        child: Container(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                  width: size.width * 0.5,
                  buttonName: AppLocalizations.of(context)!.cancel,
                  onTap: () {
                    context.read<AccBloc>().add(
                          RideLaterCancelRequestEvent(
                              requestId: args.requestId),
                        );
                  }),
            ],
          ),
        ),
      );
    });
  }
}
