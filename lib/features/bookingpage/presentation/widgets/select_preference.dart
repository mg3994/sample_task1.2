import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/booking_bloc.dart';

Widget selectPreference(BuildContext context, Size size) {
  return StatefulBuilder(
    builder: (_, set) {
      return Container(
        width: size.width,
        padding: EdgeInsets.all(size.width * 0.05),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.preference,
              textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).primaryColorDark,fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: size.width * 0.05),
            Theme(
              data: ThemeData(
                unselectedWidgetColor: Theme.of(context).primaryColorDark,
              ),
              child: CheckboxListTile(
                  value: context.read<BookingBloc>().luggagePreference,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    set(() {
                      context.read<BookingBloc>().luggagePreference = value!;
                      context.read<BookingBloc>().add(UpdateEvent());
                    });
                  },
                  title: MyText(
                    text: AppLocalizations.of(context)!.luggage,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  )),
            ),
            Theme(
              data: ThemeData(
                unselectedWidgetColor: Theme.of(context).primaryColorDark,
              ),
              child: CheckboxListTile(
                  value: context.read<BookingBloc>().petPreference,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    set(() {
                      context.read<BookingBloc>().petPreference = value!;
                      context.read<BookingBloc>().add(UpdateEvent());
                    });
                  },
                  title: MyText(
                    text: AppLocalizations.of(context)!.pet,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      );
    },
  );
}
