import 'package:flutter/material.dart';
import '../../common/common.dart';

class CustomBackground extends StatelessWidget {
  final Widget? child;
  const CustomBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            AppImages.backGroundImage,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: child,
    );
  }
}
