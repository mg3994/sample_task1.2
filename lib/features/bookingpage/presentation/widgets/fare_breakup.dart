import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';

class FareBreakup extends StatelessWidget {
  final String text;
  final String price;
  final dynamic textcolor;
  final dynamic pricecolor;
  final dynamic fntweight;
  final dynamic showBorder;
  final dynamic padding;
  const FareBreakup(
      {super.key,
      required this.text,
      required this.price,
      this.textcolor,
      this.pricecolor,
      this.fntweight,
      this.showBorder,
      this.padding});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(
          top: padding ?? size.width * 0.025,
          bottom: padding ?? size.width * 0.025),
      decoration: BoxDecoration(
          border: (showBorder == null || showBorder == true)
              ? Border(
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.2)))
              : (showBorder == 'top')
                  ? Border(
                      top: BorderSide(
                          color: AppColors.textSelectionColor.withOpacity(0.5)))
                  : const Border()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            text: text,
            textStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: size.width * 0.04,
                // fontWeight: fntweight ?? FontWeight.w400,
                color: textcolor ?? Theme.of(context).disabledColor),
            //    size: Dts(context).fifteen,
            // weight: fweight ?? FontWeight.w400,
            // color: tcolor,
          ),
          MyText(
            text: price,
            textStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: size.width * 0.04,
                color: pricecolor ?? Theme.of(context).disabledColor),
            //    size: Dts(context).fifteen,
            // weight: fweight ?? FontWeight.w400,
            // color: tcolor,
          ),
        ],
      ),
    );
  }
}
