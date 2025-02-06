import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/common/app_constants.dart';
import 'package:restart_tagxi/features/account/presentation/pages/outstation_page.dart';
import '../../../../common/app_arguments.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/domain/models/user_details_model.dart';
import '../../../language/presentation/page/choose_language_page.dart';
import '../../application/acc_bloc.dart';
import '../widgets/page_options.dart';
import '../widgets/profile_design.dart';
import 'admin_chat.dart';
import 'complaint_list.dart';
import 'edit_page.dart';
import 'fav_location.dart';
import 'history_page.dart';
import 'notification_page.dart';
import 'referral_page.dart';
import 'settings_page.dart';
import 'sos_page.dart';
import 'wallet_page.dart';

class AccountPage extends StatelessWidget {
  static const String routeName = '/accountPage';
  final AccountPageArguments arg;

  const AccountPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(UserDataInitEvent(userDetails: arg.userData)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {},
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return (context.read<AccBloc>().userData != null)
              ? Directionality(
                  textDirection: context.read<AccBloc>().textDirection == 'rtl'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Scaffold(
                    body: ProfileWidget(
                      isEditPage: false,
                      user: context.read<AccBloc>().userData!,
                      showWallet: context
                              .read<AccBloc>()
                              .userData!
                              .showWalletFeatureOnMobileApp ==
                          '1',
                      walletBalance: (context
                                  .read<AccBloc>()
                                  .userData!
                                  .showWalletFeatureOnMobileApp ==
                              '1')
                          ? '${context.read<AccBloc>().userData!.wallet.data.currencySymbol} ${context.read<AccBloc>().userData!.wallet.data.amountBalance}'
                          : '',
                      trips: context
                          .read<AccBloc>()
                          .userData!
                          .completedRideCount
                          .toString(),
                      ratings: context.read<AccBloc>().userData!.rating,
                      profileUrl:
                          context.read<AccBloc>().userData!.profilePicture,
                      userName: context.read<AccBloc>().userData!.name,
                      child: SizedBox(
                        height: size.height * 0.65,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: size.width * 0.2),
                                MyText(
                                    text:
                                        AppLocalizations.of(context)!.myAccount,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontSize:
                                                AppConstants().subHeaderSize)),
                                PageOptions(
                                  optionName: AppLocalizations.of(context)!
                                      .personalInformation,
                                  onTap: () {
                                    Navigator.pushNamed(

                                            context, EditPage.routeName,
                                            arguments: EditPageArguments(
                                                userData: context
                                                    .read<AccBloc>()
                                                    .userData!))
                                        .then((value) {
                                      if (!context.mounted) return;
                                      if (value != null) {
                                        // Update the userData with the returned value
                                        context.read<AccBloc>().userData =
                                            value as UserDetail;
                                        // Dispatch an event to force a state rebuild with updated data
                                        context
                                            .read<AccBloc>()
                                            .add(AccUpdateEvent());
                                      }
                                    });
                                  },
                                ),
                                PageOptions(
                                  optionName: AppLocalizations.of(context)!
                                      .notifications,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, NotificationPage.routeName);
                                  },
                                ),
                                PageOptions(
                                  optionName:
                                      AppLocalizations.of(context)!.history,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, HistoryPage.routeName);
                                  },
                                ),
                                if (context
                                        .read<AccBloc>()
                                        .userData!
                                        .showOutstationRideFeature ==
                                    '1')
                                  PageOptions(
                                    optionName: AppLocalizations.of(context)!
                                        .outStation,
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          OutstationHistoryPage.routeName,
                                          arguments:
                                              OutstationHistoryPageArguments(
                                                  isFromBooking: false));
                                    },
                                  ),
                                if (context
                                        .read<AccBloc>()
                                        .userData!
                                        .showWalletFeatureOnMobileApp ==
                                    '1')
                                  PageOptions(
                                    optionName:
                                        AppLocalizations.of(context)!.payment,
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, WalletHistoryPage.routeName,
                                          arguments: WalletPageArguments(
                                              userData: context
                                                  .read<AccBloc>()
                                                  .userData!));
                                    },
                                  ),
                                PageOptions(
                                  optionName:
                                      AppLocalizations.of(context)!.referEarn,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      ReferralPage.routeName,
                                      arguments: ReferralArguments(
                                          title: AppLocalizations.of(context)!
                                              .referEarn,
                                          userData: context
                                              .read<AccBloc>()
                                              .userData!),
                                    );
                                  },
                                ),
                                PageOptions(
                                  optionName: AppLocalizations.of(context)!
                                      .changeLanguage,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      ChooseLanguagePage.routeName,
                                      arguments: ChooseLanguageArguments(
                                          isInitialLanguageChange: false),
                                    ).then(
                                      (value) {
                                        if (!context.mounted) return;
                                        context
                                            .read<AccBloc>()
                                            .add(AccGetDirectionEvent());
                                      },
                                    );
                                  },
                                ),
                                PageOptions(
                                  optionName: AppLocalizations.of(context)!
                                      .favoriteLocation,
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                            FavoriteLocationPage.routeName,
                                            arguments:
                                                FavouriteLocationPageArguments(
                                                    userData: context
                                                        .read<AccBloc>()
                                                        .userData!))
                                        .then(
                                      (value) {
                                        if (!context.mounted) return;
                                        if (value != null) {
                                          context.read<AccBloc>().userData =
                                              value as UserDetail;
                                          context
                                              .read<AccBloc>()
                                              .add(AccUpdateEvent());
                                        }
                                      },
                                    );
                                  },
                                ),
                                PageOptions(
                                  optionName: AppLocalizations.of(context)!.sos,
                                  onTap: () {
                                    Navigator.pushNamed(
                                            context, SosPage.routeName,
                                            arguments: SOSPageArguments(
                                                sosData: context
                                                    .read<AccBloc>()
                                                    .userData!
                                                    .sos
                                                    .data))
                                        .then(
                                      (value) {
                                        if (!context.mounted) return;
                                        if (value != null) {
                                          final sos = value as List<SOSDatum>;
                                          context.read<AccBloc>().sosdata = sos;
                                          context
                                                  .read<AccBloc>()
                                                  .userData!
                                                  .sos
                                                  .data =
                                              context.read<AccBloc>().sosdata;
                                          context
                                              .read<AccBloc>()
                                              .add(AccUpdateEvent());
                                        }
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                MyText(
                                  text: AppLocalizations.of(context)!.general,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontSize:
                                              AppConstants().subHeaderSize),
                                ),
                                PageOptions(
                                  optionName:
                                      AppLocalizations.of(context)!.chatWithUs,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AdminChat.routeName,
                                        arguments: AdminChatPageArguments(
                                            userData: context
                                                .read<AccBloc>()
                                                .userData!));
                                  },
                                ),
                                PageOptions(
                                  optionName: AppLocalizations.of(context)!
                                      .makeComplaint,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, ComplaintListPage.routeName,
                                        arguments: ComplaintListPageArguments(
                                            choosenHistoryId: ''));
                                  },
                                ),
                                PageOptions(
                                  optionName:
                                      AppLocalizations.of(context)!.settings,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, SettingsPage.routeName);
                                  },
                                ),
                                SizedBox(height: size.width * 0.1),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const Scaffold(
                  body: Loader(),
                );
        }),
      ),
    );
  }
}
