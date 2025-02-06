import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/core/utils/custom_divider.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/booking_bloc.dart';

Widget packageList(BuildContext context, BookingPageArguments arg) {
  final size = MediaQuery.sizeOf(context);
  return BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: size.width,
          // height: size.height * 0.8,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(child: CustomDivider()),
                SizedBox(height: size.width * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (context.read<BookingBloc>().userData != null &&
                        context
                                .read<BookingBloc>()
                                .userData!
                                .enableModulesForApplications ==
                            'both')
                      MyText(
                        text: AppLocalizations.of(context)!.service,
                        textStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Theme.of(context).disabledColor,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          MyText(text: AppLocalizations.of(context)!.cancel,
                          textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16),),
                          const Icon(Icons.cancel_outlined,size:20)
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: size.width * 0.02),
                Row(
                  children: [
                    if ((arg.userData.enableModulesForApplications == 'both' ||
                            arg.userData.enableModulesForApplications ==
                                'taxi') &&
                        arg.userData.showTaxiRentalRide)
                      SizedBox(
                        width: size.width * 0.25,
                        child: Theme(
                          data: ThemeData(
                              listTileTheme: const ListTileThemeData(
                                contentPadding: EdgeInsets.zero,
                                horizontalTitleGap: 0,
                              ),
                              unselectedWidgetColor:
                                  Theme.of(context).primaryColorDark),
                          child: RadioListTile(
                            value: 'taxi',
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            activeColor: Theme.of(context).primaryColorDark,
                            groupValue:
                                context.read<BookingBloc>().transportType,
                            onChanged: (value) {
                              context.read<BookingBloc>().selectedPackageIndex =
                                  0;
                              context.read<BookingBloc>().transportType =
                                  value!;
                              context
                                  .read<BookingBloc>()
                                  .add(BookingRentalEtaRequestEvent(
                                    picklat: context
                                        .read<BookingBloc>()
                                        .pickUpAddressList
                                        .first
                                        .lat
                                        .toString(),
                                    picklng: context
                                        .read<BookingBloc>()
                                        .pickUpAddressList
                                        .first
                                        .lng
                                        .toString(),
                                    transporttype: value,
                                  ));
                              context.read<BookingBloc>().add(UpdateEvent());
                            },
                            title: MyText(
                                text: AppLocalizations.of(context)!.taxi,
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge),
                          ),
                        ),
                      ),
                    if ((arg.userData.enableModulesForApplications == 'both' ||
                            arg.userData.enableModulesForApplications ==
                                'delivery') &&
                        arg.userData.showDeliveryRentalRide)
                      SizedBox(
                        width: size.width * 0.35,
                        child: Theme(
                          data: ThemeData(
                              listTileTheme: const ListTileThemeData(
                                contentPadding: EdgeInsets.zero,
                                horizontalTitleGap: 0,
                              ),
                              unselectedWidgetColor:
                                  Theme.of(context).primaryColorDark),
                          child: RadioListTile(
                            value: 'delivery',
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            activeColor: Theme.of(context).primaryColorDark,
                            groupValue:
                                context.read<BookingBloc>().transportType,
                            onChanged: (value) {
                              context.read<BookingBloc>().selectedPackageIndex =
                                  0;
                              context.read<BookingBloc>().transportType =
                                  value!;
                              context
                                  .read<BookingBloc>()
                                  .add(BookingRentalEtaRequestEvent(
                                    picklat: context
                                        .read<BookingBloc>()
                                        .pickUpAddressList
                                        .first
                                        .lat
                                        .toString(),
                                    picklng: context
                                        .read<BookingBloc>()
                                        .pickUpAddressList
                                        .first
                                        .lng
                                        .toString(),
                                    transporttype: value,
                                  ));
                              context.read<BookingBloc>().add(UpdateEvent());
                            },
                            title: MyText(
                                text: AppLocalizations.of(context)!.delivery,
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: size.width * 0.02),
                if (context.read<BookingBloc>().userData != null &&
                    context
                            .read<BookingBloc>()
                            .userData!
                            .enableModulesForApplications ==
                        'both') ...[
                  const Divider(),
                  SizedBox(height: size.width * 0.02),
                ],
                MyText(
                  text: AppLocalizations.of(context)!.selectPackage,
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: size.width * 0.02),
                if (context
                    .read<BookingBloc>()
                    .rentalPackagesList
                    .isNotEmpty) ...[
                  Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.5,
                        child: ListView.separated(
                          itemCount: context
                              .read<BookingBloc>()
                              .rentalPackagesList
                              .length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final package = context
                                .read<BookingBloc>()
                                .rentalPackagesList
                                .elementAt(index);
                            return InkWell(
                              onTap: () {
                                context.read<BookingBloc>().add(
                                    BookingRentalPackageSelectEvent(
                                        selectedPackageIndex: index));
                              },
                              child: Container(
                                width: size.width * 0.99,
                                height: size.width * 0.2,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: (index ==
                                          context
                                              .read<BookingBloc>()
                                              .selectedPackageIndex) // Highlight the item now at the top
                                      ? AppColors.darkGrey.withOpacity(0.7)
                                      : Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.1),
                                  border: Border.all(
                                      color: (index ==
                                              context
                                                  .read<BookingBloc>()
                                                  .selectedPackageIndex) // Selected item at the top
                                          ? AppColors.darkGrey.withOpacity(0.7)
                                          : Colors.white),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(size.width * 0.01),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.44,
                                                child: MyText(
                                                  text: package.packageName,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.44,
                                                child: MyText(
                                                  text:
                                                      package.shortDescription,
                                                  maxLines: 2,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      MyText(
                                        text:
                                            '${package.currency.toString()} ${package.minPrice!.toStringAsFixed(1)} - ${package.currency.toString()} ${package.maxPrice!.toStringAsFixed(1)}',
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
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },
                        ),
                      ),
                      SizedBox(height: size.width * 0.2)
                    ],
                  ),
                ],
                if (context.read<BookingBloc>().rentalPackagesList.isEmpty)
                  Center(
                      child: MyText(
                    text: AppLocalizations.of(context)!.noDataAvailable,
                  )),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 1,
          child: Container(
            width: size.width,
            height: size.width * 0.2,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    width: size.width * 0.8,
                    height: size.width * 0.12,
                    buttonName: AppLocalizations.of(context)!.continueN,
                    onTap: () {
                      context.read<BookingBloc>().add(RentalPackageConfirmEvent(
                            picklat: context
                                .read<BookingBloc>()
                                .pickUpAddressList
                                .first
                                .lat
                                .toString(),
                            picklng: context
                                .read<BookingBloc>()
                                .pickUpAddressList
                                .first
                                .lng
                                .toString(),
                          ));
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  });
}
