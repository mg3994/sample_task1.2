import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/core/network/extensions.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../auth/application/auth_bloc.dart';
import '../../application/acc_bloc.dart';
import '../widgets/circle_ui.dart';

class ReferralPage extends StatelessWidget {
  final ReferralArguments args;

  static const String routeName = '/ReferralPage';

  const ReferralPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()..add(AccGetDirectionEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            CustomLoader.loader(context);
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Directionality(
            textDirection: context.read<AccBloc>().textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            CupertinoIcons.back,
                            size: 20,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        MyText(
                          text: args.title,
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                        )
                      ],
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          width: size.width,
                          height: size.height * 0.6,
                          child: Column(
                            children: [
                              const Image(
                                image: AssetImage(AppImages.referral),
                              ),
                              MyText(
                                text: args.userData
                                    .referralComissionString, // Display,
                                textAlign: TextAlign.center,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        const Positioned(
                            left: -80, top: -70, child: CircleOne()),
                        const Positioned(
                            left: 40, top: -130, child: CircleTwo()),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.width * 0.05,
                          ),
                          MyText(
                            text: AppLocalizations.of(context)!
                                .shareYourInviteCode,
                            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20),
                          ),
                          SizedBox(height: size.width * 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                text: args.userData.refferalCode,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context).disabledColor,fontSize: 18),
                              ),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: args.userData.refferalCode));
                                  context.showSnackBar(
                                      color: Theme.of(context).primaryColorDark,
                                      message: AppLocalizations.of(context)!
                                          .referralCodeCopy);
                                },
                                child: Icon(
                                  Icons.copy,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.width * 0.03,
                          ),
                          Divider(
                            height: 1,
                            color: Theme.of(context).disabledColor,
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    CustomButton(
                        buttonName: AppLocalizations.of(context)!.invite,
                        onTap: () async {
                          await Share.share(AppLocalizations.of(context)!
                              .referralInviteText
                              .replaceAll('****', args.userData.refferalCode)
                              .replaceAll('**', AppConstants.title));
                        }),
                    SizedBox(
                      height: size.width * 0.1,
                    ),
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
