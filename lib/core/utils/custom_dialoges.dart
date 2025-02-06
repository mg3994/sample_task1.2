import 'package:flutter/material.dart';

import '../../common/common.dart';
import 'custom_button.dart';
import 'custom_text.dart';

class CustomSingleButtonDialoge extends StatelessWidget {
  final String title;
  final String content;
  final String btnName;
  final Color? btnNameColor;
  final Color? btnColor;
  final Function()? onTap;

  const CustomSingleButtonDialoge(
      {super.key,
      required this.title,
      required this.content,
      required this.btnName,
      this.btnNameColor,
      this.btnColor,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: MyText(
        text: title,
        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
      ),
      content: MyText(
        text: content,
        maxLines: 4,
      ),
      actions: [
        CustomButton(
          buttonName: btnName,
          borderRadius: 5,
          width: size.width,
          height: size.width * 0.12,
          buttonColor: btnColor,
          textColor: btnNameColor ?? AppColors.white,
          onTap: onTap ?? () {},
        )
      ],
    );
  }
}

class CustomDoubleButtonDialoge extends StatelessWidget {
  final String title;
  final String content;
  final String yesBtnName;
  final String noBtnName;
  final Color? yesBtnTextColor;
  final Color? noBtnTextColor;
  final Color? yesBtnColor;
  final Color? noBtnColor;
  final Function()? yesBtnFunc;
  final Function()? noBtnFunc;

  const CustomDoubleButtonDialoge({
    super.key,
    required this.title,
    required this.content,
    required this.yesBtnName,
    required this.noBtnName,
    this.yesBtnTextColor,
    this.noBtnTextColor,
    this.yesBtnColor,
    this.noBtnColor,
    this.yesBtnFunc,
    this.noBtnFunc,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: MyText(
        text: title,
        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
      ),
      content: MyText(
        text: content,
        textStyle: Theme.of(context).textTheme.bodyMedium,
        maxLines: 2,
      ),
      actionsPadding: EdgeInsets.all(size.width * 0.04),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        CustomButton(
          buttonName: noBtnName,
          borderRadius: 5,
          width: size.width * 0.3,
          height: size.width * 0.12,
          isBorder: true,
          buttonColor: noBtnColor ?? Theme.of(context).scaffoldBackgroundColor,
          textColor: noBtnTextColor ?? AppColors.primary,
          onTap: noBtnFunc ??
              () {
                Navigator.pop(context);
              },
        ),
        CustomButton(
          buttonName: yesBtnName,
          borderRadius: 5,
          width: size.width * 0.3,
          height: size.width * 0.12,
          buttonColor: yesBtnColor ?? Theme.of(context).primaryColor,
          textColor: yesBtnTextColor ?? AppColors.white,
          onTap: yesBtnFunc ?? () {},
        )
      ],
    );
  }
}
