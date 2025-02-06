import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../core/utils/custom_text.dart';
import '../../application/booking_bloc.dart';

class EtaDetailsWidget extends StatelessWidget {
  final dynamic etaInfo;
  const EtaDetailsWidget({
    super.key,
    required this.etaInfo,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return Container(
          width: size.width,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.cancel,
                          color: Theme.of(context).disabledColor))
                ],
              ),
              SizedBox(height: size.width * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                            text: etaInfo
                                .name, //- ${etaInfo.currency.toString()} ${etaInfo.total.toString()}',
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        MyText(
                          text: etaInfo.description,
                          maxLines: 4,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Theme.of(context).disabledColor),
                        ),
                      ],
                    ),
                  ),
                  CachedNetworkImage(
                    imageUrl: (context.read<BookingBloc>().isRentalRide)
                        ? etaInfo.icon
                        : etaInfo.vehicleIcon,
                    width: size.width * 0.2,
                    height: size.width * 0.1,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Text(
                        "",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: size.width * 0.02),
              Divider(color: Theme.of(context).dividerColor),
              SizedBox(height: size.width * 0.01),
              if (context.read<BookingBloc>().isRentalRide) ...[
                Flexible(
                  child: MyText(
                    text: etaInfo.description,
                    textStyle: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                  ),
                ),
              ],
              if (!context.read<BookingBloc>().isRentalRide) ...[
                MyText(
                  text: AppLocalizations.of(context)!.rideFare,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).primaryColorDark,fontWeight: FontWeight.w600),
                ),
                SizedBox(height: size.width * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: '${AppLocalizations.of(context)!.baseDistancePrice} ',
                      textStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    MyText(
                      text: '${etaInfo.currency}${etaInfo.basePrice}',
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).primaryColorDark),
                    )
                  ],
                ),
                SizedBox(height: size.width * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text:
                          '${AppLocalizations.of(context)!.additional} \n${AppLocalizations.of(context)!.distancePrice} (${etaInfo.calculatedDistance}${etaInfo.unitInWords} x ${etaInfo.currency}${etaInfo.pricePerDistance})',
                      textStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    MyText(
                      text: '${etaInfo.currency}${etaInfo.distancePrice}',
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).primaryColorDark),
                    )
                  ],
                ),
                SizedBox(height: size.width * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text:
                          '${AppLocalizations.of(context)!.timePrice}(${etaInfo.time} mins x ${etaInfo.currency}${etaInfo.pricePerTime})',
                      textStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    MyText(
                      text: '${etaInfo.currency}${etaInfo.timePrice}',
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).primaryColorDark),
                    )
                  ],
                ),
                SizedBox(height: size.width * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text:
                          '${AppLocalizations.of(context)!.tax}(${etaInfo.tax}%)', //(${etaInfo.tax})
                      textStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    MyText(
                      text: '${etaInfo.currency}${etaInfo.taxAmount}',
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).primaryColorDark),
                    )
                  ],
                ),
                SizedBox(height: size.width * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: AppLocalizations.of(context)!.adminCommission,
                      textStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    MyText(
                      text:
                          '${etaInfo.currency}${etaInfo.withoutDiscountAdminCommision}',
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).primaryColorDark),
                    )
                  ],
                ),
                SizedBox(height: size.width * 0.02),
                Divider(color: Theme.of(context).dividerColor),
                SizedBox(height: size.width * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: AppLocalizations.of(context)!.total,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Theme.of(context).primaryColorDark),
                    ),
                    MyText(
                      text: '${etaInfo.currency} ${etaInfo.total.toString()}',
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Theme.of(context).primaryColorDark),
                    )
                  ],
                ),
              
              SizedBox(height: size.width * 0.01),
              Divider(color: Theme.of(context).dividerColor),
                SizedBox(height: size.width * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: size.width * 0.015,
                    width: size.width * 0.015,
                    margin: const EdgeInsets.only(top: 7),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColorDark),
                  ),
                  SizedBox(width: size.width * 0.01),
                  Flexible(
                    child: MyText(
                      text: AppLocalizations.of(context)!
                          .infoWaitingPrice
                          .replaceAll('***',
                              '${etaInfo.currency} ${etaInfo.pricePerTime}')
                          .replaceAll('*', '3'),
                     textStyle: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                    ),
                  ),
                ],
                ),
              ],
              SizedBox(height: size.width * 0.03),
            ],
          ),
        );
      },
    );
  }
}
