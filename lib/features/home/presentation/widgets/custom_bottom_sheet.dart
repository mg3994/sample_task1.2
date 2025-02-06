import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/home_bloc.dart';

class CustomBottom extends StatefulWidget {
  final Widget? child;
  const CustomBottom({
    super.key,
    this.child,
  });

  @override
  CustomBottomState createState() => CustomBottomState();
}

class CustomBottomState extends State<CustomBottom>
    with TickerProviderStateMixin {
  Offset _offset = const Offset(0, 250);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return GestureDetector(
          onPanUpdate: (details) {
            double currentHeight = _offset.dy - details.delta.dy;
            if (currentHeight > 0) {
              _offset = Offset(0, currentHeight);
            }
            context.read<HomeBloc>().add(UpdateEvent());
          },
          onPanEnd: (details) {
            context.read<HomeBloc>().add(UpdateEvent());
          },
          child: SafeArea(
            child: Stack(
              children: [
                BottomSheet(
                  onClosing: () {},
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  animationController: AnimationController(
                      animationBehavior: AnimationBehavior.preserve,
                      vsync: this,
                      duration: const Duration(microseconds: 300)),
                  builder: (context) => Container(
                    height: _offset.dy,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
                Positioned(
                  child: widget.child!,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
