import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intel;
import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/booking_bloc.dart';

Widget scheduleRide(BuildContext context, Size size, BookingPageArguments arg,
    bool isReturnTime) {
  return StatefulBuilder(builder: (_, set) {
    return Container(
      width: size.width,
      height: size.width,
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: AppLocalizations.of(context)!.scheduleRide,
                textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).primaryColorDark,
                    ),
              ),
              if (context.read<BookingBloc>().scheduleDateTime.isNotEmpty &&
                  !arg.isOutstationRide)
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    context.read<BookingBloc>().showDateTime = '';
                    context.read<BookingBloc>().scheduleDateTime = '';
                    context.read<BookingBloc>().showReturnDateTime = '';
                    context.read<BookingBloc>().scheduleDateTimeForReturn = '';
                    context.read<BookingBloc>().add(UpdateEvent());
                  },
                  child: MyText(
                    text: AppLocalizations.of(context)!.reset,
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
                  ),
                ),
            ],
          ),
          SizedBox(height: size.width * 0.05),
          Container(
            height: size.width * 0.5,
            width: size.width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).disabledColor.withOpacity(0.3)),
            child: CupertinoDatePicker(
                minimumDate: isReturnTime
                    ? DateTime.tryParse(context.read<BookingBloc>().scheduleDateTime)!
                        .add(const Duration(days: 1))
                    : DateTime.now().add(Duration(
                        minutes: int.parse(
                            arg.userData.userCanMakeARideAfterXMiniutes))),
                initialDateTime: isReturnTime
                    ? DateTime.tryParse(context.read<BookingBloc>().scheduleDateTime)!
                        .add(const Duration(days: 1))
                    : DateTime.now().add(Duration(
                        minutes: int.parse(
                            arg.userData.userCanMakeARideAfterXMiniutes))),
                maximumDate: isReturnTime
                    ? DateTime.tryParse(
                            context.read<BookingBloc>().scheduleDateTime)!
                        .add(const Duration(days: 5))
                    : DateTime.now().add(const Duration(days: 4)),
                onDateTimeChanged: (val) {
                  debugPrint(val.toString().substring(0, 19));
                  final date =
                      intel.DateFormat('dd/MM/yyyy (hh:mm a)').format(val);
                  if (!isReturnTime) {
                    context.read<BookingBloc>().showDateTime = date;
                    context.read<BookingBloc>().scheduleDateTime =
                        val.toString();
                  } else {
                    context.read<BookingBloc>().showReturnDateTime = date;
                    context.read<BookingBloc>().scheduleDateTimeForReturn =
                        val.toString();
                  }
                }),
          ),
          SizedBox(height: size.width * 0.05),
          Center(
            child: CustomButton(
              width: size.width,
              buttonColor: Theme.of(context).primaryColor,
              buttonName: AppLocalizations.of(context)!.confirm,
              onTap: () {
                if (!isReturnTime) {
                  if (context.read<BookingBloc>().scheduleDateTime.isNotEmpty) {
                    context.read<BookingBloc>().add(UpdateEvent());
                  } else {
                    context.read<BookingBloc>().showDateTime = intel.DateFormat(
                            'dd/MM/yyyy (hh:mm a)')
                        .format(DateTime.now().add(Duration(
                            minutes: int.parse(
                                arg.userData.userCanMakeARideAfterXMiniutes))));
                    context.read<BookingBloc>().scheduleDateTime =
                        DateTime.now()
                            .add(Duration(
                                minutes: int.parse(arg
                                    .userData.userCanMakeARideAfterXMiniutes)))
                            .toString();
                    context.read<BookingBloc>().add(UpdateEvent());
                  }
                }else{
                   if (context.read<BookingBloc>().scheduleDateTimeForReturn.isNotEmpty) {
                    context.read<BookingBloc>().add(UpdateEvent());
                  } else {
                    context.read<BookingBloc>().showReturnDateTime = intel.DateFormat(
                            'dd/MM/yyyy (hh:mm a)')
                        .format(
                            DateTime.tryParse(context
                                    .read<BookingBloc>()
                                    .scheduleDateTime)!
                                .add(const Duration(days: 1)));
                    context.read<BookingBloc>().scheduleDateTimeForReturn =
                        DateTime.tryParse(
                                context.read<BookingBloc>().scheduleDateTime)!
                            .add(const Duration(days: 1))
                            .toString();
                    context.read<BookingBloc>().add(UpdateEvent());
                  }
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  });
}
