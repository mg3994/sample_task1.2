import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final bool? isShadow;
  final Color? color;
  final double? borderRadius;
  final BoxBorder? border;
  const CustomContainer(
      {super.key,
      this.child,
      this.height,
      this.width,
      this.isShadow = true,
      this.color,
      this.borderRadius,
      this.border});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: height,
      width: width ?? size.width,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 5),
        border: border,
        boxShadow: (isShadow != null && isShadow!)
            ? [
                BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.13),
                    // color: Color(0x21000000),
                    offset: const Offset(0, 9),
                    spreadRadius: 0,
                    blurRadius: 30.7)
              ]
            : null,
      ),
      child: child,
    );
  }
}
