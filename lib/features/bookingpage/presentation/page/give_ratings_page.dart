import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_snack_bar.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../application/booking_bloc.dart';

class RatingsPage extends StatelessWidget {
  static const String routeName = '/ratingsPage';
  final RatingsPageArguments arg;
  const RatingsPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
        create: (context) => BookingBloc(),
        child: BlocListener<BookingBloc, BookingState>(
          listener: (context, state) async {
            if (state is BookingUserRatingsSuccessState) {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            } else if (state is LogoutState) {
              Navigator.pushNamedAndRemoveUntil(
                  context, AuthPage.routeName, (route) => false);
              await AppSharedPreference.setLoginStatus(false);
            }
          },
          child: BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: size.width * 0.2,
                        width: size.width * 0.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Theme.of(context).dividerColor),
                        child: (arg.driverData.profilePicture.isEmpty)
                            ? const Icon(
                                Icons.person,
                                size: 50,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: CachedNetworkImage(
                                  imageUrl: arg.driverData.profilePicture,
                                  height: size.width * 0.15,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => const Center(
                                    child: Loader(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Text(""),
                                  ),
                                ),
                              ), 
                      ),
                      SizedBox(height: size.width * 0.05),
                      MyText(
                        text: AppLocalizations.of(context)!.lastRideReview.replaceAll('*', arg.driverData.name),
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: size.width * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) {
                            return InkWell(
                              onTap: () {
                                context.read<BookingBloc>().add(
                                    BookingRatingsSelectEvent(
                                        selectedIndex: index + 1));
                              },
                              child: Icon(Icons.star,
                                  color: (index + 1 <=
                                              context
                                                  .read<BookingBloc>()
                                                  .selectedRatingsIndex &&
                                          context
                                                  .read<BookingBloc>()
                                                  .selectedRatingsIndex !=
                                              0)
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).disabledColor,
                                  size: 30),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: size.width * 0.05),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomTextField(
                          controller:
                              context.read<BookingBloc>().feedBackController,
                          filled: true,
                          hintText: '${AppLocalizations.of(context)!.leaveFeedback}(${AppLocalizations.of(context)!.optional})',
                          maxLine: 5,
                        ),
                      ),
                      SizedBox(height: size.width * 0.2),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CustomButton(
                            width: size.width,
                            buttonColor: Theme.of(context).primaryColor,
                            buttonName: AppLocalizations.of(context)!.submit,
                            onTap: () {
                              if (context
                                      .read<BookingBloc>()
                                      .selectedRatingsIndex >
                                  0) {
                                context.read<BookingBloc>().add(
                                      BookingUserRatingsEvent(
                                          requestId: arg.requestId,
                                          ratings:
                                              '${context.read<BookingBloc>().selectedRatingsIndex}',
                                          feedBack: context
                                              .read<BookingBloc>()
                                              .feedBackController
                                              .text),
                                    );
                              } else {
                                showToast(message: AppLocalizations.of(context)!.pleaseGiveRatings);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
