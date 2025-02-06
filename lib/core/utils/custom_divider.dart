import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  const CustomDivider({super.key, this.height, this.width, this.color});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: width ?? size.width * 0.13,
        height: height ?? size.width * 0.01,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(size.width * 0.05),
        ),
      ),
    );
  }
}

class VerticalDotDividerWidget extends StatelessWidget {
  const VerticalDotDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 3,
          width: 1,
          color: Colors.black,
        ),
        Container(
          height: 3,
          width: 1,
          color: Colors.white,
        ),
        Container(
          height: 3,
          width: 1,
          color: Colors.black,
        ),
        Container(
          height: 3,
          width: 1,
          color: Colors.white,
        ),
        Container(
          height: 3,
          width: 1,
          color: Colors.black,
        ),
      ],
    );
  }
}

class HorizontalDotDividerWidget extends StatelessWidget {
  const HorizontalDotDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        25,
        (index) {
          return Container(
            margin: EdgeInsets.only(right: size.width * 0.01),
            height: size.width * 0.005,
            width: size.width * 0.02,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColorDark.withOpacity(0.3),
            ),
          );
        },
      ),
    );
  }
}
