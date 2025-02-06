import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/acc_bloc.dart';

class PaymentGatwaysPage extends StatefulWidget {
  static const String routeName = '/paymentGatwayPage';
  final PaymentGateWayPageArguments arg;
  const PaymentGatwaysPage({super.key, required this.arg});

  @override
  State<PaymentGatwaysPage> createState() => _PaymentGatwaysPageState();
}

class _PaymentGatwaysPageState extends State<PaymentGatwaysPage> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return BlocProvider(
        create: (BuildContext context) => AccBloc()
          ..add(
            AddMoneyWebViewUrlEvent(
              currencySymbol: widget.arg.currencySymbol.toString(),
              from: widget.arg.from,
              money: widget.arg.money,
              url: widget.arg.url,
              userId: widget.arg.userId,
              requestId: widget.arg.requestId,
              context: context,
            ),
          )
          ..add(AccGetUserDetailsEvent()),
        child: BlocListener<AccBloc, AccState>(
          listener: (context, state) {
            if (Platform.isAndroid) {
              if (context.read<AccBloc>().paymentProcessComplete) {
                if (context.read<AccBloc>().paymentSuccess) {
                  Navigator.pop(context, true);
                } else {
                  // Navigator.pop(context,false);
                }
              }
            }
          },
          child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
            return Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: Stack(
                children: [
                  Container(
                    height: media.height,
                    width: media.width,
                    color: AppColors.white,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: Column(
                      children: [
                        if (context.read<AccBloc>().isArrow == true)
                          Container(
                            width: media.width,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(media.width * 0.05),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context,
                                    context.read<AccBloc>().paymentSuccess);
                              },
                              child: const Icon(Icons.arrow_back),
                            ),
                          ),
                        (context.read<AccBloc>().paymentUrl != null)
                            ? Expanded(
                                child: InAppWebView(
                                    key: context.read<AccBloc>().paymentKey,
                                    initialUrlRequest: URLRequest(
                                        url: WebUri(context
                                            .read<AccBloc>()
                                            .paymentUrl!)),
                                    initialSettings: InAppWebViewSettings(
                                      isInspectable: true,
                                    ),
                                    onWebViewCreated: (controller) => context
                                        .read<AccBloc>()
                                        .inAppWebViewController = controller,
                                    onPermissionRequest:
                                        (controller, request) async {
                                      return PermissionResponse(
                                        resources: request.resources,
                                        action: PermissionResponseAction.GRANT,
                                      );
                                    },
                                    onUpdateVisitedHistory:
                                        (controller, url, isReload) async {
                                      if (url != null) {
                                        if (url
                                            .toString()
                                            .contains('success')) {
                                          Navigator.pop(context, true);
                                          context
                                              .read<AccBloc>()
                                              .paymentProcessComplete = true;
                                          context
                                              .read<AccBloc>()
                                              .paymentSuccess = true;
                                        } else if (url
                                            .toString()
                                            .contains('failure')) {
                                          Navigator.pop(context, false);
                                          context
                                              .read<AccBloc>()
                                              .paymentProcessComplete = true;
                                          context
                                              .read<AccBloc>()
                                              .paymentSuccess = false;
                                        }
                                      }
                                    }),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  //payment success
                  (context.read<AccBloc>().paymentSuccess)
                      ? Positioned(
                          top: 0,
                          child: Container(
                            alignment: Alignment.center,
                            height: media.height * 1,
                            width: media.width * 1,
                            color: Colors.transparent.withOpacity(0.6),
                            child: Container(
                              padding: EdgeInsets.all(media.width * 0.05),
                              width: media.width * 0.9,
                              height: media.width * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      media.width * 0.03)),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/paymentsuccess.png',
                                    fit: BoxFit.contain,
                                    width: media.width * 0.5,
                                  ),
                                  MyText(
                                    text: AppLocalizations.of(context)!.success,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: media.width * 0.07,
                                  ),
                                  CustomButton(
                                    onTap: () {
                                      Navigator.pop(context, true);
                                    },
                                    buttonName:
                                        AppLocalizations.of(context)!.okText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          }),
        ));
  }
}
