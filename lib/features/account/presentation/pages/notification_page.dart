import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/app_images.dart';
import '../../../../core/utils/custom_dialoges.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/acc_bloc.dart';
import '../widgets/notification_page_shimmer.dart';
import '../widgets/top_bar.dart';

class NotificationPage extends StatelessWidget {
  static const String routeName = '/notification';

  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(NotificationPageInitEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          } else if (state is NotificationDeletedSuccess ||
              state is NotificationClearedSuccess) {
            context.read<AccBloc>().add(NotificationGetEvent());
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Directionality(
            textDirection: context.read<AccBloc>().textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              body: TopBarDesign(
                controller: context.read<AccBloc>().scrollController,
                isHistoryPage: false,
                title: AppLocalizations.of(context)!.notifications,
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<AccBloc>().scrollController.dispose();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (context
                        .read<AccBloc>()
                        .notificationDatas
                        .isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                              text: AppLocalizations.of(context)!.notifications,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 18),
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext _) {
                                    return BlocProvider.value(
                                        value:
                                            BlocProvider.of<AccBloc>(context),
                                        child: CustomDoubleButtonDialoge(
                                          title: AppLocalizations.of(context)!
                                              .clearNotifications,
                                          content: AppLocalizations.of(context)!
                                              .clearNotificationsText,
                                          yesBtnName:
                                              AppLocalizations.of(context)!
                                                  .confirm,
                                          noBtnName:
                                              AppLocalizations.of(context)!
                                                  .cancel,
                                          yesBtnFunc: () {
                                            context.read<AccBloc>().add(
                                                ClearAllNotificationsEvent());
                                          },
                                          noBtnFunc: () {
                                            Navigator.pop(context);
                                          },
                                        ));
                                  },
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.clearAll,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.width * 0.05),
                    ],
                    if (context.read<AccBloc>().isLoading)
                      NotificationShimmer(
                        size: size,
                      ),
                    if (!context.read<AccBloc>().isLoading &&
                        context.read<AccBloc>().notificationDatas.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.notificationsNoData,
                                height: size.width,
                              ),
                              MyText(
                                maxLines: 2,
                                text: AppLocalizations.of(context)!
                                    .noNotification,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              context.read<AccBloc>().notificationDatas.length,
                          itemBuilder: (_, index) {
                            final notification = context
                                .read<AccBloc>()
                                .notificationDatas
                                .elementAt(index);
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: size.width * 0.05),
                                  padding: EdgeInsets.all(size.width * 0.025),
                                  decoration: BoxDecoration(
                                      color:
                                          AppColors.darkGrey.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: size.width * 0.0025,
                                          color: AppColors.darkGrey)),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.notifications,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  size: 18,
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.02,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      MyText(
                                                        text:
                                                            notification.title,
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium,
                                                        maxLines: 5,
                                                      ),
                                                      MyText(
                                                        text: notification.body,
                                                        textStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .disabledColor),
                                                        maxLines: 5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  MyText(
                                                    text: notification
                                                        .convertedCreatedAt
                                                        .split(' ')[0],
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor),
                                                  ),
                                                  MyText(
                                                    text: notification
                                                        .convertedCreatedAt
                                                        .split(' ')[1],
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: size.width * 0.01,
                                              ),
                                              Container(
                                                  height: size.width * 0.1,
                                                  width: size.width * 0.002,
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                              SizedBox(
                                                width: size.width * 0.01,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext _) {
                                                      return BlocProvider.value(
                                                        value: BlocProvider.of<
                                                            AccBloc>(context),
                                                        child:
                                                            CustomSingleButtonDialoge(
                                                          title: AppLocalizations
                                                                  .of(context)!
                                                              .deleteNotification,
                                                          content: AppLocalizations
                                                                  .of(context)!
                                                              .deleteNotificationText,
                                                          btnName:
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .confirm,
                                                          onTap: () {
                                                            context
                                                                .read<AccBloc>()
                                                                .add(DeleteNotificationEvent(
                                                                    id: notification
                                                                        .id));
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Icon(
                                                    Icons.cancel_rounded,
                                                    color: Theme.of(context)
                                                        .disabledColor),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      notification.image != null &&
                                              notification.image!.isNotEmpty
                                          ? Column(
                                              children: [
                                                SizedBox(
                                                  height: size.height * 0.01,
                                                ),
                                                CachedNetworkImage(
                                                  imageUrl: notification.image!,
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
                                              ],
                                            )
                                          : const SizedBox()
                                    ],
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
          );
        }),
      ),
    );
  }
}
