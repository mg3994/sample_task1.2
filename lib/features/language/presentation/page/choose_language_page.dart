import 'package:flutter/material.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_background.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../landing/presentation/page/landing_page.dart';
import '../../application/language_bloc.dart';
import '../../../../app/localization.dart';
import '../../domain/models/language_listing_model.dart';

class ChooseLanguagePage extends StatelessWidget {
  static const String routeName = '/chooseLanguage';
  final ChooseLanguageArguments arg;

  const ChooseLanguagePage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return builderList(size);
  }

  Widget builderList(Size size) {
    return BlocProvider(
      create: (context) => LanguageBloc()
        ..add(LanguageInitialEvent())
        ..add(LanguageGetEvent(
            isInitialLanguageChange: arg.isInitialLanguageChange)),
      child: BlocListener<LanguageBloc, LanguageState>(
        listener: (context, state) {
          if (state is LanguageInitialState) {
            CustomLoader.loader(context);
          } else if (state is LanguageLoadingState) {
            CustomLoader.loader(context);
          } else if (state is LanguageSuccessState) {
            CustomLoader.dismiss(context);
          } else if (state is LanguageFailureState) {
            CustomLoader.dismiss(context);
          } else if (state is LanguageUpdateState) {
            // Reload the app with the selected language
            if (arg.isInitialLanguageChange) {
              Navigator.pushNamedAndRemoveUntil(
                  context, LandingPage.routeName, (route) => false);
            } else {
              Navigator.pop(context);
            }
          }
        },
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return Scaffold(
              body: SafeArea(
                child: CustomBackground(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.width * 0.05),
                        Row(
                          children: [
                            (arg.isInitialLanguageChange)
                                ? const SizedBox()
                                : IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      context.read<LocalizationBloc>().add(
                                          LocalizationInitialEvent(
                                            isDark: Theme.of(context)
                                                      .brightness ==
                                                  Brightness.dark,
                                              locale: Locale(context
                                                  .read<LanguageBloc>()
                                                  .choosedLanguage)));
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                      color: AppColors.black,
                                      size: 20,
                                    ),
                                  ),
                            MyText(
                                text: AppLocalizations.of(context)!
                                    .chooseLanguage,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: AppColors.black,
                                      fontSize: 20,
                                    )),
                          ],
                        ),
                        SizedBox(height: size.width * 0.02),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                buildLanguageList(
                                    size, AppConstants.languageList)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.width * 0.05,
                        ),
                        confirmButton(size, context),
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

// Language List
  Widget buildLanguageList(Size size, List<LocaleLanguageList> languageList) {
    return languageList.isNotEmpty
        ? RawScrollbar(
            radius: const Radius.circular(20),
            child: ListView.builder(
              itemCount: languageList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
                  child: InkWell(
                    onTap: () {
                      context.read<LanguageBloc>().add(
                          LanguageSelectEvent(selectedLanguageIndex: index));
                      context.read<LocalizationBloc>().add(
                          LocalizationInitialEvent(
                            isDark: Theme.of(context).brightness ==
                                  Brightness.dark,
                              locale: Locale(languageList[index].lang)));
                    },
                    child: Container(
                      height: 50,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color:
                                (context.read<LanguageBloc>().selectedIndex ==
                                        index)
                                    ? AppColors.black
                                    : AppColors.white,
                            width:
                                (context.read<LanguageBloc>().selectedIndex ==
                                        index)
                                    ? 2.0
                                    : 1.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: MyText(
                            text: languageList[index].name,
                            textStyle:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: AppColors.black,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : const SizedBox();
  }

  Widget confirmButton(Size size, BuildContext context) {
    return Center(
      child: CustomButton(
        buttonName: AppLocalizations.of(context)!.confirm,
        height: size.width * 0.15,
        width: size.width * 0.85,
        onTap: () async {
          final selectedIndex = context.read<LanguageBloc>().selectedIndex;
          context.read<LanguageBloc>().add(LanguageSelectUpdateEvent(
              selectedLanguage:
                  AppConstants.languageList.elementAt(selectedIndex).lang));
        },
      ),
    );
  }
}
