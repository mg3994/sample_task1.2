import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../app/localization.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/domain/models/user_details_model.dart';
import '../../application/acc_bloc.dart';

class ProfileWidget extends StatelessWidget {
  final bool isEditPage;
  final String profileUrl;
  final bool showWallet;
  final String walletBalance;
  final String userName;
  final String ratings;
  final String trips;
  final Widget? child;
  final UserDetail user;
  final void Function()? backOnTap;

  const ProfileWidget({
    super.key,
    required this.isEditPage,
    required this.profileUrl,
    required this.showWallet,
    required this.walletBalance,
    required this.userName,
    required this.ratings,
    required this.trips,
    this.child,
    this.backOnTap,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border(
              bottom: BorderSide(color: Theme.of(context).primaryColorLight),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                offset: const Offset(5.0, 5.0),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: size.height * 0.05),
              InkWell(
                onTap: backOnTap ??
                    () {
                      Navigator.pop(context, user);
                    },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: size.width * 0.1,
                          width: size.width * 0.1,
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child: const Icon(CupertinoIcons.back,
                              // color: Theme.of(context).primaryColorLight,
                              color: AppColors.whiteText),
                        ),
                        Text(
                          !isEditPage
                              ? AppLocalizations.of(context)!.back.toLowerCase()
                              : AppLocalizations.of(context)!.personalInformation,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              // color: Theme.of(context).primaryColorLight,
                              color: AppColors.whiteText,fontSize: 20),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Transform.scale(
                        scaleX: size.width * 0.003,
                        scaleY: size.width * 0.0026,
                        child: Switch(
                          value: context.read<AccBloc>().isDarkTheme,
                          activeColor: Theme.of(context).primaryColorDark,
                          activeTrackColor: Theme.of(context).primaryColorDark,
                          inactiveTrackColor:
                              Theme.of(context).primaryColorDark,
                          activeThumbImage: const AssetImage(AppImages.sun),
                          inactiveThumbImage : const AssetImage(AppImages.moon),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (value) async {
                            context.read<AccBloc>().isDarkTheme = value;
                            final locale = await AppSharedPreference
                                .getSelectedLanguageCode();
                            if (!context.mounted) return;
                            context.read<LocalizationBloc>().add(
                                LocalizationInitialEvent(
                                    isDark: value, locale: Locale(locale)));
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: size.width * 0.1,
                      backgroundColor: Theme.of(context).dividerColor,
                      backgroundImage: context
                              .read<AccBloc>()
                              .userData!
                              .profilePicture
                              .isNotEmpty
                          ? NetworkImage(
                              context.read<AccBloc>().userData!.profilePicture)
                          : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isEditPage)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () => _showImageSourceSheet(context),
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.edit,
                                        size: 15,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: MyText(
                      text: userName,
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(
                              color: AppColors.white,
                              fontSize: AppConstants().headerSize),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: (!isEditPage) ? size.height * 0.3 : size.height * 0.25,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: child,
          ),
        ),
        if (!isEditPage)
          Positioned(
            top: size.height * 0.25,
            left: size.width * 0.05,
            right: size.width * 0.05,
            child: Container(
              height: size.width * 0.21,
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).shadowColor,
                        spreadRadius: 2.0,
                        blurRadius: 2.0)
                  ]),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8, vertical: size.width * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (showWallet) ...[
                        SizedBox(
                          width: size.width * 0.8 / 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyText(
                                  text: AppLocalizations.of(context)!
                                      .walletBalance,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .disabledColor
                                              .withOpacity(0.5),
                                          fontSize: 14)),
                              MyText(
                                  text: walletBalance,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          // color: Theme.of(context).primaryColor
                                          color: Theme.of(context)
                                              .primaryColorDark)),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: size.width * 0.02),
                          child: VerticalDivider(
                              color: Theme.of(context).dividerColor),
                        ),
                      ],
                      SizedBox(
                        width: showWallet
                            ? size.width * 0.8 / 3.5
                            : size.width * 0.8 / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(
                                text: AppLocalizations.of(context)!.ratings,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.5),
                                        fontSize: 14)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText(
                                    text: ratings,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .primaryColorDark)),
                                Icon(
                                  Icons.star,
                                  color: Theme.of(context).primaryColorDark,
                                  size: 16,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.width * 0.02),
                        child: VerticalDivider(
                            color: Theme.of(context).dividerColor),
                      ),
                      SizedBox(
                        width: showWallet
                            ? size.width * 0.8 / 3
                            : size.width * 0.8 / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(
                                text: AppLocalizations.of(context)!.totalRides,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.5),
                                        fontSize: 14)),
                            MyText(
                                text: trips,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .primaryColorDark)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).splashColor,
      builder: (_) => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 1,
                  spreadRadius: 1)
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                size: 20,
                color: Theme.of(context).primaryColorDark,
              ),
              title: MyText(
                text: AppLocalizations.of(context)!.cameraText,
                textStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).primaryColorDark),
              ),
              onTap: () {
                Navigator.pop(context);
                _updateProfileImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library,
                size: 20,
                color: Theme.of(context).primaryColorDark,
              ),
              title: MyText(
                text: AppLocalizations.of(context)!.galleryText,
                textStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).primaryColorDark),
              ),
              onTap: () {
                Navigator.pop(context);
                _updateProfileImage(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfileImage(
      BuildContext context, ImageSource source) async {
    final AccBloc accBloc = context.read<AccBloc>();

    accBloc.add(UpdateImageEvent(
      name: accBloc.userData!.name,
      email: accBloc.userData!.email,
      gender: accBloc.userData!.gender,
      source: source,
    ));
    accBloc.add(AccUpdateEvent());
  }
}
