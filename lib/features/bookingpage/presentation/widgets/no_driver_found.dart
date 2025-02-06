import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/booking_bloc.dart';

class NoDriverFoundWidget extends StatelessWidget {
  const NoDriverFoundWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return Container(
          width: size.width,
          height: size.height * 0.3,
          padding: EdgeInsets.all(size.width * 0.05),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              MyText(
                  text: AppLocalizations.of(context)!.noDriverFound,
                  textStyle: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: size.height * 0.1),
              Center(
                child: CustomButton(
                  width: size.width,
                  buttonColor: Theme.of(context).primaryColor,
                  buttonName: AppLocalizations.of(context)!.okText,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
