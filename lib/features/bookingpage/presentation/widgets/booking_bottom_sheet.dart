import 'package:flutter/material.dart';

class BookingCustomBottom extends StatefulWidget {
  final Widget? child;
  final double maxHeight;
  final double minHeight;
  const BookingCustomBottom(
      {super.key,
      this.child,
      required this.maxHeight,
      required this.minHeight});

  @override
  BookingCustomBottomState createState() => BookingCustomBottomState();
}

class BookingCustomBottomState extends State<BookingCustomBottom> {
  late double minHeight;
  late double maxHeight;
  late Offset _offset;

  @override
  void initState() {
    minHeight = widget.minHeight;
    maxHeight = widget.maxHeight;
    _offset = Offset(0, widget.minHeight);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        _offset = Offset(0, _offset.dy - details.delta.dy);
        if (details.delta.dy < widget.minHeight) {
          _offset = Offset(0, _offset.dy);
        } else if (details.delta.dy > widget.maxHeight) {
          _offset = Offset(0, widget.maxHeight);
        }
        setState(() {});
      },
      onPanEnd: (details) {
        // if (details.localPosition.dy < widget.minHeight) {
        //   _offset = Offset(0, widget.minHeight);
        // }
        if (details.localPosition.dy > widget.maxHeight) {
          _offset = Offset(0, details.localPosition.dy);
        }
        setState(() {});
      },
      child: AnimatedContainer(
        duration: Duration.zero,
        curve: Curves.fastOutSlowIn,
        height: _offset.dy,
        constraints: BoxConstraints(
          maxHeight: maxHeight,
          minHeight: minHeight,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10)
            ]),
        child: widget.child,
      ),
    );
  }
}
