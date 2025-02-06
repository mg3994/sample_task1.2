// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:restart_tagxi/common/app_constants.dart';

import '../../../../core/utils/custom_text.dart';

// Account Page Navigation Widget
class PageOptions extends StatelessWidget {
  final String optionName;
  final Function()? onTap;
  final Color? color;
  final Icon? icon;
  final Widget? child;

  const PageOptions({
    super.key,
    required this.optionName,
    this.onTap,
    this.color,
    this.icon,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (onTap != null) {
                onTap!();
              }
            });
          },
          highlightColor: Theme.of(context).disabledColor.withOpacity(0.1),
          splashColor: Theme.of(context).disabledColor.withOpacity(0.2),
          hoverColor: Theme.of(context).disabledColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      MyText(
                        text: optionName,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                                color: Theme.of(context).disabledColor,
                                fontSize: AppConstants().headerSize),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: child,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Theme.of(context).disabledColor,
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ],
    );
  }
}
