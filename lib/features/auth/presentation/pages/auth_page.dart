import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_background.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../language/presentation/page/choose_language_page.dart';
import '../../application/auth_bloc.dart';
import '../../domain/models/country_list_model.dart';

import '../widgets/auth_bottom_sheet.dart';
import 'verify_page.dart';

class AuthPage extends StatelessWidget {
  static const String routeName = '/authPage';
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return builderList(size);
  }

  Widget builderList(Size size) {
    return BlocProvider(
      create: (context) => AuthBloc()
        ..add(GetDirectionEvent())
        ..add(CountryGetEvent())
        ..add(GetCommonModuleEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            CustomLoader.loader(context);
          } else if (state is AuthDataLoadingState) {
            CustomLoader.loader(context);
          } else if (state is AuthDataSuccessState) {
            CustomLoader.dismiss(context);
          } else if (state is VerifySuccessState) {
            Navigator.pushNamed(
              context,
              VerifyPage.routeName,
              arguments: VerifyArguments(
                mobileOrEmail:
                    context.read<AuthBloc>().emailOrMobileController.text,
                countryCode: context.read<AuthBloc>().dialCode,
                countryFlag: context.read<AuthBloc>().flagImage,
                isLoginByEmail: context.read<AuthBloc>().isLoginByEmail,
                userExist: context.read<AuthBloc>().userExist,
                countryList: context.read<AuthBloc>().countries,
                isOtpVerify: context.read<AuthBloc>().userExist ? false : true,
                isDemoLogin: false,
                isRefferalEarnings: context.read<AuthBloc>().isRefferalEarnings,
              ),
            );
          } else if (state is SignInWithDemoState) {
            Navigator.pushNamed(
              context,
              VerifyPage.routeName,
              arguments: VerifyArguments(
                mobileOrEmail:
                    context.read<AuthBloc>().emailOrMobileController.text,
                countryCode: context.read<AuthBloc>().dialCode,
                countryFlag: context.read<AuthBloc>().flagImage,
                isLoginByEmail: context.read<AuthBloc>().isLoginByEmail,
                userExist: false,
                countryList: context.read<AuthBloc>().countries,
                isOtpVerify: true,
                isDemoLogin: true,
                isRefferalEarnings: context.read<AuthBloc>().isRefferalEarnings,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return PopScope(
              canPop: false,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  context.read<AuthBloc>().formKey.currentState!.reset();
                  // context.read<AuthBloc>().showLoginBtn = false;
                },
                child: Directionality(
                  textDirection: context.read<AuthBloc>().textDirection == 'rtl'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Scaffold(
                    resizeToAvoidBottomInset: true,
                    body: authScreen(context),
                    bottomSheet: AuthBottomSheet(
                        formKey: context.read<AuthBloc>().formKey,
                        emailOrMobile:
                            context.read<AuthBloc>().emailOrMobileController,
                        continueFunc: () {
                          context.read<AuthBloc>().add(VerifyUserEvent());
                        },
                        focusNode: context.read<AuthBloc>().textFieldFocus,
                        // showLoginBtn: context.read<AuthBloc>().showLoginBtn,
                        showLoginBtn: true,
                        isLoginByEmail: context.read<AuthBloc>().isLoginByEmail,
                        countrySelectFunc: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: true,
                            context: context,
                            builder: (cont) {
                              return selectCountryBottomSheet(size,
                                  context.read<AuthBloc>().countries, context);
                            },
                          );
                        },
                        onTapEvent: () {
                          context
                              .read<AuthBloc>()
                              .add(EmailorMobileOnTapEvent());
                        },
                        onSubmitEvent: (p0) {
                          context
                              .read<AuthBloc>()
                              .add(EmailorMobileOnSubmitEvent());
                        },
                        onChangeEvent: (value) {
                          context
                              .read<AuthBloc>()
                              .add(EmailorMobileOnChangeEvent(value: value));
                        },
                        isShowLoader: context.read<AuthBloc>().isLoading,
                        dialCode: context.read<AuthBloc>().dialCode,
                        flagImage: context.read<AuthBloc>().flagImage),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget authScreen(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomBackground(
      child: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [                  
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ChooseLanguagePage.routeName,
                        arguments: ChooseLanguageArguments(
                            isInitialLanguageChange: false),
                      ).then(
                        (value) {
                          if (!context.mounted) return;
                          context.read<AuthBloc>().add(GetDirectionEvent());
                        },
                      );
                    },
                    child: Row(
                      children: [
                        MyText(
                            text: context.read<AuthBloc>().languageCode.toUpperCase(),
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                        Icon(Icons.language_outlined,
                            color: Theme.of(context).primaryColor),
                        Icon(Icons.arrow_drop_down,
                            color: Theme.of(context).primaryColor),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.6,
            child: Center(
              child: CarouselSlider(
                items: context.read<AuthBloc>().splashImages,
                options: CarouselOptions(
                  height: 400,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 2),
                  autoPlayAnimationDuration: const Duration(milliseconds: 300),
                  autoPlayCurve: Curves.easeInOut,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  StatefulBuilder selectCountryBottomSheet(
      Size size, List<Country> countries, BuildContext context) {
    return StatefulBuilder(
      builder: (cont, set) {
        return SafeArea(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: size.height * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 10),
                      MyText(
                        text: AppLocalizations.of(context)!.selectContry,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: MyText(
                          text: AppLocalizations.of(context)!.cancel,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomTextField(
                    controller: context.read<AuthBloc>().searchController,
                    borderRadius: 10,
                    onChange: (p0) => set(() {}),
                    onSubmitted: (p0) => set(() {}),
                    suffixConstraints:
                        BoxConstraints(maxWidth: size.width * 0.1),
                    suffixIcon: InkWell(
                      onTap: () => set(() {
                        context.read<AuthBloc>().searchController.clear();
                      }),
                      child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.cancel_outlined,
                            color: Theme.of(context).hintColor,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: size.height * 0.75,
                  child: ListView.builder(
                    itemCount: countries.length,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (con, index) {
                      var countryData = countries.elementAt(index);
                      if (countryData.name.toLowerCase().toString().contains(
                              context
                                  .read<AuthBloc>()
                                  .searchController
                                  .text
                                  .toLowerCase()
                                  .toString()) ||
                          countryData.dialCode.toString().contains(context
                              .read<AuthBloc>()
                              .searchController
                              .text
                              .toString())) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          child: InkWell(
                            onTap: () {
                              set(() {
                                context.read<AuthBloc>().dialCode =
                                    countryData.dialCode;
                                context.read<AuthBloc>().dialMaxLength =
                                    countryData.dialMaxLength;
                                context.read<AuthBloc>().flagImage =
                                    countryData.flag!;
                              });
                              context.read<AuthBloc>().searchController.clear();
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 30,
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: AppColors.darkGrey,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                      imageUrl: countryData.flag!,
                                      width: 30,
                                      height: 20,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: Text(
                                          "",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: size.width * 0.7,
                                  child: MyText(
                                    text: countryData.name,
                                    maxLines: 2,
                                  ),
                                ),
                                const Spacer(),
                                MyText(text: countryData.dialCode),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
