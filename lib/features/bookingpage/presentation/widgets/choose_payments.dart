import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/core/utils/custom_snack_bar.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../core/utils/custom_text.dart';
import '../../application/booking_bloc.dart';

Widget choosePaymentMethod(BuildContext context, Size size) {
  return StatefulBuilder(builder: (_, set) {
    return Container(
      width: size.width,
      height: size.width * 0.7,
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: AppLocalizations.of(context)!.choosePayment,
            textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).primaryColorDark,
                ),
          ),
          Expanded(
            child: Column(
              children: [
                Column(
                  children: List.generate(
                      context.read<BookingBloc>().paymentList.length, (index) {
                    return Theme(
                      data: ThemeData(
                        unselectedWidgetColor:
                            Theme.of(context).primaryColorDark,
                      ),
                      child: RadioListTile(
                        value: context.read<BookingBloc>().paymentList[index],
                        groupValue:
                            context.read<BookingBloc>().selectedPaymentType,
                        onChanged: (value) {
                          set(
                            () {
                              if (value.toString() == 'wallet') {
                                if (context
                                            .read<BookingBloc>()
                                            .paymentList[index] ==
                                        'wallet' &&
                                    context
                                            .read<BookingBloc>()
                                            .userData!
                                            .wallet
                                            .data
                                            .amountBalance >
                                        context
                                            .read<BookingBloc>()
                                            .selectedEtaAmount) {
                                  context
                                      .read<BookingBloc>()
                                      .selectedPaymentType = value.toString();
                                  context
                                      .read<BookingBloc>()
                                      .add(UpdateEvent());
                                  Navigator.pop(context);
                                } else {
                                  showToast(message: 'Low wallet balance');
                                }
                              } else {
                                context
                                    .read<BookingBloc>()
                                    .selectedPaymentType = value.toString();
                                context.read<BookingBloc>().add(UpdateEvent());
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
                        activeColor: Theme.of(context).primaryColorDark,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Row(
                          children: [
                            Icon(
                                context
                                            .read<BookingBloc>()
                                            .paymentList[index] ==
                                        'cash'
                                    ? Icons.payments_outlined
                                    : (context
                                                    .read<BookingBloc>()
                                                    .paymentList[index] ==
                                                'card' ||
                                            context
                                                    .read<BookingBloc>()
                                                    .paymentList[index] ==
                                                'onlne')
                                        ? Icons.credit_card_rounded
                                        : Icons.account_balance_wallet_outlined,
                                color: Theme.of(context).primaryColorDark),
                            SizedBox(width: size.width * 0.05),
                            MyText(
                              text: context
                                  .read<BookingBloc>()
                                  .paymentList[index],
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        subtitle: (context
                                    .read<BookingBloc>()
                                    .paymentList[index] ==
                                'wallet')
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.1),
                                child: MyText(
                                  text:
                                      '${context.read<BookingBloc>().userData!.wallet.data.currencySymbol} ${context.read<BookingBloc>().userData!.wallet.data.amountBalance}',
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color:
                                              Theme.of(context).primaryColorDark),
                                ),
                              )
                            : null,
                      ),
                    );
                  }),
                )
              ],
            ),
          )
        ],
      ),
    );
  });
}
