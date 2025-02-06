import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/booking_bloc.dart';

Widget filterEta(Size size, BuildContext currentContext) {
  final List permitList = [
    AppLocalizations.of(currentContext)!.national,
    AppLocalizations.of(currentContext)!.normal
  ];
  final List bodyTypeList = [
    AppLocalizations.of(currentContext)!.openBody,
    AppLocalizations.of(currentContext)!.packBody
  ];
  return BlocBuilder<BookingBloc, BookingState>(
    builder: (context, state) {
      return Stack(
        children: [
          Container(
            height: size.height * 0.7,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.width * 0.2),
                    if (context.read<BookingBloc>().transportType ==
                        'taxi') ...[
                      MyText(
                        text: AppLocalizations.of(context)!.capacity,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: size.width * 0.02),
                      MyText(
                        text:
                            AppLocalizations.of(context)!.capacityContent,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Theme.of(context).disabledColor),
                      ),
                      SizedBox(height: size.width * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              if (context.read<BookingBloc>().filterCapasity !=
                                  1) {
                                context.read<BookingBloc>().filterCapasity--;
                                context.read<BookingBloc>().add(UpdateEvent());
                              }
                            },
                            child: Container(
                              width: size.width * 0.2,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.all(size.width * 0.025),
                              child: MyText(
                                text: '-',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: size.width * 0.3,
                              child: Center(
                                child: MyText(
                                  text:
                                      '${context.read<BookingBloc>().filterCapasity}',
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                              )),
                          InkWell(
                            onTap: () {
                              context.read<BookingBloc>().filterCapasity++;
                              context.read<BookingBloc>().add(UpdateEvent());
                            },
                            child: Container(
                              width: size.width * 0.2,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.all(size.width * 0.025),
                              child: MyText(
                                text: '+',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.width * 0.02),
                      Divider(color: Theme.of(context).dividerColor),
                    ],
                    SizedBox(height: size.width * 0.02),
                    MyText(
                      text: AppLocalizations.of(context)!.category,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.width * 0.02),
                    MyText(
                      text: AppLocalizations.of(context)!.categoryContent,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).disabledColor),
                    ),
                    SizedBox(height: size.width * 0.02),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          context.read<BookingBloc>().categoryList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final category = context
                            .read<BookingBloc>()
                            .categoryList
                            .elementAt(index);
                        return Theme(
                          data: ThemeData(
                              unselectedWidgetColor:
                                  Theme.of(context).primaryColorDark,
                              listTileTheme: const ListTileThemeData(
                                horizontalTitleGap: 0.0,
                                contentPadding: EdgeInsets.zero,
                              )),
                          child: CheckboxListTile(
                            activeColor: Theme.of(context).primaryColor,
                            value: context
                                .read<BookingBloc>()
                                .filterCategory
                                .contains(category.id),
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            title: MyText(
                              text: category.name,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                            onChanged: (value) {
                              if (value!) {
                                context
                                    .read<BookingBloc>()
                                    .filterCategory
                                    .add(category.id);
                                context.read<BookingBloc>().add(UpdateEvent());
                              } else {
                                context
                                    .read<BookingBloc>()
                                    .filterCategory
                                    .removeWhere(
                                        (element) => element == category.id);
                                context.read<BookingBloc>().add(UpdateEvent());
                              }
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: size.width * 0.02),
                    if (context.read<BookingBloc>().transportType ==
                        'delivery') ...[
                      Divider(color: Theme.of(context).dividerColor),
                      SizedBox(height: size.width * 0.02),
                      MyText(
                        text: AppLocalizations.of(context)!.permit,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: size.width * 0.02),
                      MyText(
                        text: AppLocalizations.of(context)!.permitContent,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Theme.of(context).disabledColor),
                      ),
                      SizedBox(height: size.width * 0.02),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: permitList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Theme(
                            data: ThemeData(
                                unselectedWidgetColor:
                                    Theme.of(context).primaryColorDark,
                                listTileTheme: const ListTileThemeData(
                                  horizontalTitleGap: 0.0,
                                  contentPadding: EdgeInsets.zero,
                                )),
                            child: CheckboxListTile(
                              activeColor: Theme.of(context).primaryColor,
                              value: context
                                  .read<BookingBloc>()
                                  .filterPermit
                                  .contains(permitList[index]),
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              title: MyText(
                                text: permitList[index],
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                              onChanged: (value) {
                                if (value!) {
                                  context
                                      .read<BookingBloc>()
                                      .filterPermit
                                      .add(permitList[index]);
                                  context
                                      .read<BookingBloc>()
                                      .add(UpdateEvent());
                                } else {
                                  context
                                      .read<BookingBloc>()
                                      .filterPermit
                                      .removeWhere((element) =>
                                          element == permitList[index]);
                                  context
                                      .read<BookingBloc>()
                                      .add(UpdateEvent());
                                }
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: size.width * 0.02),
                      Divider(color: Theme.of(context).dividerColor),
                      SizedBox(height: size.width * 0.02),
                      MyText(
                        text: AppLocalizations.of(context)!.bodyType,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: size.width * 0.02),
                      MyText(
                        text: AppLocalizations.of(context)!.bodyTypeContent,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Theme.of(context).disabledColor),
                      ),
                      SizedBox(height: size.width * 0.05),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: bodyTypeList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Theme(
                            data: ThemeData(
                                unselectedWidgetColor:
                                    Theme.of(context).primaryColorDark,
                                listTileTheme: const ListTileThemeData(
                                  horizontalTitleGap: 0.0,
                                  contentPadding: EdgeInsets.zero,
                                )),
                            child: CheckboxListTile(
                              activeColor: Theme.of(context).primaryColor,
                              value: context
                                  .read<BookingBloc>()
                                  .filterBodyType
                                  .contains(bodyTypeList[index] ==
                                          AppLocalizations.of(context)!.packBody
                                      ? 'pack_body'
                                      : 'open_body'),
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              title: MyText(
                                text: bodyTypeList[index],
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                              onChanged: (value) {
                                if (value!) {
                                  context
                                      .read<BookingBloc>()
                                      .filterBodyType
                                      .add(bodyTypeList[index] ==
                                              AppLocalizations.of(context)!
                                                  .packBody
                                          ? 'pack_body'
                                          : 'open_body');
                                  context
                                      .read<BookingBloc>()
                                      .add(UpdateEvent());
                                } else {
                                  context
                                      .read<BookingBloc>()
                                      .filterBodyType
                                      .removeWhere((element) =>
                                          element ==
                                          (bodyTypeList[index] ==
                                                  AppLocalizations.of(context)!
                                                      .packBody
                                              ? 'pack_body'
                                              : 'open_body'));
                                  context
                                      .read<BookingBloc>()
                                      .add(UpdateEvent());
                                }
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: size.width * 0.02),
                    ],
                    SizedBox(height: size.width * 0.3),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: 0,
              // left: size.width * 0.04,
              // right: size.width * 0.04,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child:
                    Container(
                    width: size.width,
                    // height: size.width * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 2),
                              color: Theme.of(context).shadowColor)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: size.width * 0.03),
                          Center(
                            child: MyText(
                              text: AppLocalizations.of(context)!.applyFilter,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Icon(Icons.cancel,
                              color: Theme.of(context).primaryColor),
                        ],
                      ),
                    )),
              )),
          Positioned(
            bottom: 0,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: size.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      buttonName: AppLocalizations.of(context)!.reset,
                      isBorder: true,
                      width: size.width * 0.44,
                      buttonColor: Theme.of(context).scaffoldBackgroundColor,
                      textColor: Theme.of(context).primaryColor,
                      onTap: () {
                        context.read<BookingBloc>().applyFilterCapasity = 1;
                        context.read<BookingBloc>().applyFilterCategory = [];
                        context.read<BookingBloc>().applyFilterPermit = [];
                        context.read<BookingBloc>().applyFilterBodyType = [];

                        context.read<BookingBloc>().filterCapasity = 1;
                        context.read<BookingBloc>().filterCategory = [];
                        context.read<BookingBloc>().filterPermit = [];
                        context.read<BookingBloc>().filterBodyType = [];

                        context.read<BookingBloc>().isEtaFilter = false;
                        context.read<BookingBloc>().add(UpdateEvent());
                        Navigator.pop(context);
                      },
                    ),
                    CustomButton(
                      buttonName: AppLocalizations.of(context)!.apply,
                      width: size.width * 0.44,
                      onTap: () {
                        context.read<BookingBloc>().add(FilterApplyEvent(
                            filterCapasity:
                                context.read<BookingBloc>().filterCapasity,
                            filterCategory:
                                context.read<BookingBloc>().filterCategory,
                            filterPermit:
                                context.read<BookingBloc>().filterPermit,
                            filterBodyType:
                                context.read<BookingBloc>().filterBodyType));
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
