import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../core/utils/functions.dart';
import '../../../../l10n/app_localizations.dart';

class AuthBottomSheet extends StatefulWidget {
  final TextEditingController emailOrMobile;
  final dynamic continueFunc;
  final bool showLoginBtn;
  final bool isLoginByEmail;
  final Function()? onTapEvent;
  final Function(String)? onChangeEvent;
  final Function(String)? onSubmitEvent;
  final Function()? countrySelectFunc;
  final GlobalKey<FormState> formKey;
  final String dialCode;
  final String flagImage;
  final FocusNode focusNode;
  final bool isShowLoader;
  const AuthBottomSheet(
      {super.key,
      required this.emailOrMobile,
      required this.continueFunc,
      required this.showLoginBtn,
      required this.isLoginByEmail,
      this.onTapEvent,
      this.onChangeEvent,
      this.onSubmitEvent,
      required this.formKey,
      required this.dialCode,
      required this.flagImage,
      this.countrySelectFunc,
      required this.focusNode,
      required this.isShowLoader});

  @override
  State<StatefulWidget> createState() => AuthBottomSheetState();
}

class AuthBottomSheetState extends State<AuthBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.linearToEaseOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _continuePressed() {
    _controller.forward();
  }

  _closeDialog() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          height: widget.showLoginBtn ? size.height * 0.38 : size.height * 0.25,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                blurRadius: 5,
                spreadRadius: 1,
              )
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyText(
                      text:
                          '${AppLocalizations.of(context)!.welcome}, ${AppLocalizations.of(context)!.user}',
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 20),
                    ),
                    const SizedBox(width: 10),
                    SvgPicture.asset(AppImages.hi, height: 20, width: 25)
                  ],
                ),
                SizedBox(height: size.width * 0.05),
                MyText(
                  text:
                      '${AppLocalizations.of(context)!.email}/${AppLocalizations.of(context)!.mobile}',
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: size.width * 0.02),
                Form(
                  key: widget.formKey,
                  child: CustomTextField(
                    controller: widget.emailOrMobile,
                    filled: true,
                    focusNode: widget.focusNode,
                    hintText: AppLocalizations.of(context)!
                        .emailAddressOrMobileNumber,
                    prefixConstraints:
                        BoxConstraints(maxWidth: size.width * 0.2),
                    prefixIcon: !widget.isLoginByEmail
                        ? Center(
                            child: InkWell(
                              onTap: widget.countrySelectFunc,
                              child: Row(
                                children: [
                                  Container(
                                    height: 20,
                                    width: 25,
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Theme.of(context).disabledColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.flagImage,
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
                                  MyText(
                                    text: widget.dialCode,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : null,
                    onTap: widget.onTapEvent,
                    onSubmitted: widget.onSubmitEvent,
                    onChange: widget.onChangeEvent,
                    validator: (value) {
                      if (value!.isNotEmpty &&
                          !AppValidation.emailValidate(value) &&
                          !AppValidation.mobileNumberValidate(value)) {
                        return AppLocalizations.of(context)!.validEmailMobile;
                      } else if (value.isEmpty) {
                        return AppLocalizations.of(context)!.enterEmailMobile;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                // if (widget.showLoginBtn) ...[
                SizedBox(height: size.width * 0.05),
                Center(
                  child: CustomButton(
                    buttonName: AppLocalizations.of(context)!.continueN,
                    borderRadius: 18,
                    width: size.width,
                    height: size.width * 0.12,
                    textColor: AppColors.white,
                    buttonColor: (widget.emailOrMobile.text.isEmpty)
                        ? Theme.of(context).disabledColor.withOpacity(0.5)
                        : null,
                    onTap: () {
                      if (widget.formKey.currentState!.validate() &&
                          widget.emailOrMobile.text.isNotEmpty) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _continuePressed();
                      }
                    },
                  ),
                ),
                SizedBox(height: size.width * 0.02),
                SizedBox(
                  width: size.width,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      MyText(
                        text: '${AppLocalizations.of(context)!.byContinuing} ',
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                                color: AppColors.darkGrey,
                                fontWeight: FontWeight.normal),
                      ),
                      InkWell(
                        onTap: () async {
                          openUrl(AppConstants.termsCondition);
                        },
                        child: MyText(
                          text: '${AppLocalizations.of(context)!.terms} ',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.underline),
                        ),
                      ),
                      MyText(
                        text: AppLocalizations.of(context)!.and,
                        textStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: AppColors.darkGrey,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      InkWell(
                        onTap: () async {
                          openUrl(AppConstants.privacyPolicy);
                        },
                        child: MyText(
                          text:
                              '${AppLocalizations.of(context)!.privacyPolicy} ',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
                // ],
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    decoration: ShapeDecoration(
                        color: Theme.of(context).dialogBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Wrap(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              alignment : WrapAlignment.center,
                              children: [
                                if(!widget.isLoginByEmail)
                                MyText(
                                  text: widget.dialCode,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontSize: 20),
                                ),
                                SizedBox(width: size.width * 0.02),
                                MyText(
                                  text: widget.emailOrMobile.text,
                                  maxLines: 3,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontSize: 20),
                                ),
                              ],
                            ),
                          const SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  text:
                                      '${AppLocalizations.of(context)!.isThisCorrect} ',
                                ),
                                TextSpan(
                                  style: AppTextStyle.boldStyle(
                                    size: 16,
                                    weight: FontWeight.normal,
                                  ).copyWith(
                                      color: (Theme.of(context).brightness ==
                                              Brightness.light)
                                          ? AppColors.black
                                          : AppColors.white,
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.solid),
                                  text: AppLocalizations.of(context)!.edit,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _closeDialog,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            buttonName: AppLocalizations.of(context)!.continueN,
                            borderRadius: 18,
                            width: size.width,
                            height: size.width * 0.12,
                            isLoader: widget.isShowLoader,
                            onTap: widget.continueFunc,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
