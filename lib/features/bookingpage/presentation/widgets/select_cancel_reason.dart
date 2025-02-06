import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/core/utils/custom_textfield.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_navigation_icon.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/booking_bloc.dart';

class SelectCancelReasonList extends StatelessWidget {
  const SelectCancelReasonList({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom:  MediaQuery.viewInsetsOf(context).bottom),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.width * 0.05),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).systemGestureInsets.top,
                      ),
                      child: NavigationIconWidget(
                        isShadowWidget: true,
                        icon: Icon(
                          Icons.arrow_back,
                          size: size.width * 0.07,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onTap: () {
                          context.read<BookingBloc>().cancelReasonClicked = false;
                          context.read<BookingBloc>().add(UpdateEvent());
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(height: size.width * 0.1),
                    SizedBox(
                        width: size.width * 0.83,
                        child:  MyText(
                            text: AppLocalizations.of(context)!.selectCancelReason)),
                    SizedBox(height: size.width * 0.05),
                    ListView.builder(
                        itemCount:
                            context.read<BookingBloc>().cancelReasonsList.length,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final reason = context
                              .read<BookingBloc>()
                              .cancelReasonsList
                              .elementAt(index);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.5)),
                            ),
                            child: Theme(
                              data: ThemeData(
                                unselectedWidgetColor:
                                    Theme.of(context).primaryColorDark,
                              ),
                              child: RadioListTile(
                                value: reason.reason,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: Theme.of(context).primaryColorDark,
                                groupValue: context
                                    .read<BookingBloc>()
                                    .selectedCancelReason,
                                onChanged: (value) {
                                  context
                                      .read<BookingBloc>()
                                      .selectedCancelReason = value!;
                                  context.read<BookingBloc>().add(UpdateEvent());
                                },
                                title: MyText(
                                  text: reason.reason,
                                  maxLines: 2,
                                  textStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          );
                        }),
                    if(context
                        .read<BookingBloc>()
                        .cancelReasonsList
                        .isNotEmpty
                    )
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.5)),
                        ),
                      child: Theme(
                                data: ThemeData(
                                  unselectedWidgetColor:
                                      Theme.of(context).primaryColorDark,
                                ),
                                child: RadioListTile(
                                  value: 'Others',
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  activeColor: Theme.of(context).primaryColorDark,
                                  groupValue: context
                                      .read<BookingBloc>()
                                      .selectedCancelReason,
                                  onChanged: (value) {
                                    context
                                        .read<BookingBloc>()
                                        .selectedCancelReason = value!;
                                    context.read<BookingBloc>().add(UpdateEvent());
                                  },
                                  title: MyText(
                                    text: AppLocalizations.of(context)!.others,
                                    maxLines: 2,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                    ),
                    if(context.read<BookingBloc>().selectedCancelReason == 'Others')...[                  
                    CustomTextField(controller: context.read<BookingBloc>().otherReasonController,
                    maxLine: 5,
                    filled: true,
                    hintText: AppLocalizations.of(context)!.otherReason,
                    ),],        
                    SizedBox(height: size.width * 0.05),
                    Center(
                      child: CustomButton(
                          buttonName: AppLocalizations.of(context)!.cancelRide,
                          buttonColor: (context
                                  .read<BookingBloc>()
                                  .selectedCancelReason
                                  .isNotEmpty)
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).primaryColorLight,
                          onTap: () {
                            if ((context
                                .read<BookingBloc>()
                                .selectedCancelReason
                                .isNotEmpty && context
                                            .read<BookingBloc>()
                                            .selectedCancelReason !=
                                        'Others') || ((context
                                        .read<BookingBloc>()
                                        .selectedCancelReason ==
                                    'Others') && context
                                        .read<BookingBloc>()
                                        .otherReasonController
                                        .text.isNotEmpty)) {
                              Navigator.pop(context);
                              context.read<BookingBloc>().add(
                                    BookingCancelRequestEvent(
                                        requestId: context
                                            .read<BookingBloc>()
                                            .requestData!
                                            .id,
                                        reason:(context.read<BookingBloc>().selectedCancelReason == 'Others') ?  context.read<BookingBloc>().otherReasonController.text
                                            : context
                                            .read<BookingBloc>()
                                            .selectedCancelReason),
                                  );
                              context.read<BookingBloc>().add(
                                  TripRideCancelEvent(isCancelByDriver: false));
                }
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
