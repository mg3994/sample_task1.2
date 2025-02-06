import 'package:flutter/material.dart';

import '../../common/common.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class CustomLoader {
  static Future loader(BuildContext context) async {
    if (navigatorKey.currentContext == null) {
      return Future.value();
    }
    return showDialog<dynamic>(
      context: context,
      barrierColor: Colors.white.withOpacity(0.8),
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const AlertDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Loader(),
        );
      },
    );
  }

  static void dismiss(BuildContext context) {
    if (navigatorKey.currentContext != null) {
      final navigator =
          Navigator.of(navigatorKey.currentContext!, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      }
    }
  }
}

class Loader extends StatefulWidget {
  final Color? color;
  const Loader({super.key, this.color});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with TickerProviderStateMixin {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: widget.color ?? AppColors.primary,
     ),);}
}