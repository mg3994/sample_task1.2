import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_dialoges.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../application/acc_bloc.dart';
import '../widgets/page_options.dart';
import '../widgets/top_bar.dart';
import 'delete_account.dart';
import 'faq_page.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = '/settingsPage';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()..add(AccGetDirectionEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) async {
          if (state is DeleteAccountLoadingState) {
            CustomLoader.loader(context);
          } else if (state is DeleteAccountFailureState) {
            CustomLoader.dismiss(context);
          } else if (state is LogoutSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
            await AppSharedPreference.setToken('');
          } else if (state is DeleteAccountSuccess) {
            CustomLoader.dismiss(context);
            Navigator.pushNamed(context, DeleteAccount.routeName);
            await AppSharedPreference.setLoginStatus(false);
            await AppSharedPreference.setToken('');
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Directionality(
              textDirection: context.read<AccBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                body: TopBarDesign(
                  isHistoryPage: false,
                  title: AppLocalizations.of(context)!.settings,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        PageOptions(
                          optionName: AppLocalizations.of(context)!.faq,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              FaqPage.routeName,
                            );
                          },
                        ),
                        PageOptions(
                          optionName: AppLocalizations.of(context)!
                              .privacyPolicyAccounts,
                          onTap: () async {
                            const browseUrl = AppConstants.privacyPolicy;
                            if (browseUrl.isNotEmpty) {
                              await launchUrl(Uri.parse(browseUrl));
                            } else {
                              throw 'Could not launch $browseUrl';
                            }
                          },
                        ),
                        PageOptions(
                          optionName: AppLocalizations.of(context)!.logout,
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierColor: Theme.of(context).shadowColor,
                              builder: (BuildContext _) {
                                return BlocProvider.value(
                                  value: BlocProvider.of<AccBloc>(context),
                                  child: CustomDoubleButtonDialoge(
                                    title: AppLocalizations.of(context)!
                                        .comeBackSoon,
                                    content: AppLocalizations.of(context)!
                                        .logoutText,
                                    noBtnName: AppLocalizations.of(context)!.no,
                                    yesBtnName:
                                        AppLocalizations.of(context)!.yes,
                                    yesBtnFunc: () {
                                      context
                                          .read<AccBloc>()
                                          .add(LogoutEvent());
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        PageOptions(
                          optionName:
                              AppLocalizations.of(context)!.deleteAccount,
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierColor: Theme.of(context).shadowColor,
                              builder: (BuildContext _) {
                                return BlocProvider.value(
                                  value: BlocProvider.of<AccBloc>(context),
                                  child: CustomSingleButtonDialoge(
                                    title:
                                        '${AppLocalizations.of(context)!.deleteAccount} ?',
                                    content: AppLocalizations.of(context)!
                                        .deleteText,
                                    btnName: AppLocalizations.of(context)!
                                        .deleteAccount,
                                    onTap: () {
                                      context
                                          .read<AccBloc>()
                                          .add(DeleteAccountEvent());
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        }),
      ),
    );
  }
}
