import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../auth/application/auth_bloc.dart';
import '../../application/acc_bloc.dart';
import '../../domain/models/walletpage_model.dart';
import '../widgets/wallet_history_shimmer.dart';
import 'paymentgateways.dart';
import 'web_view_page.dart';

class WalletHistoryPage extends StatelessWidget {
  static const String routeName = '/walletHistory';
  final WalletPageArguments arg;

  const WalletHistoryPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()..add(WalletPageInitEvent(arg: arg)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            CustomLoader.loader(context);
          }
          if (state is MoneyTransferedSuccessState) {
            Navigator.pop(context);
          }
          if (state is AddMoneyWebViewUrlState) {
            Navigator.pushNamed(
              context,
              WebViewPage.routeName,
            );
          }
          if (state is WalletPageReUpdateState) {
            Navigator.pushNamed(
              context,
              PaymentGatwaysPage.routeName,
              arguments: PaymentGateWayPageArguments(
                currencySymbol: state.currencySymbol,
                from: '',
                requestId: state.requestId,
                money: state.money,
                url: state.url,
                userId: state.userId,
              ),
            ).then((value) {
              if (!context.mounted) return;
              if (value != null && value == true) {
                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Prevents closing the dialog by tapping outside
                  builder: (_) {
                    return AlertDialog(
                      content: SizedBox(
                        height: size.height * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppImages.paymentSuccess,
                              fit: BoxFit.contain,
                              width: size.width * 0.5,
                            ),
                            SizedBox(height: size.width * 0.02),
                            Text(
                              AppLocalizations.of(context)!.paymentSuccess,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: size.width * 0.02),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context.read<AccBloc>().add(
                                      GetWalletHistoryListEvent(
                                          pageIndex: context
                                              .read<AccBloc>()
                                              .walletPaginations!
                                              .pagination
                                              .currentPage),
                                    );
                              },
                              child: Text(AppLocalizations.of(context)!.okText),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Prevents closing the dialog by tapping outside
                  builder: (_) {
                    return AlertDialog(
                      content: SizedBox(
                        height: size.height * 0.45,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppImages.paymentFail,
                              fit: BoxFit.contain,
                              width: size.width * 0.4,
                            ),
                            SizedBox(height: size.width * 0.02),
                            Text(
                              AppLocalizations.of(context)!.paymentFailed,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: size.width * 0.02),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(AppLocalizations.of(context)!.okText),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            });
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Stack(
              children: [
                SizedBox(
                  height: size.height,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.width * 0.5,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).padding.top,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: size.height * 0.08,
                                    width: size.width * 0.08,
                                    margin: EdgeInsets.only(
                                        left: size.width * 0.05,
                                        right: size.width * 0.05),
                                    decoration: const BoxDecoration(
                                      color: AppColors.whiteText,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(5.0, 5.0),
                                          blurRadius: 10.0,
                                          spreadRadius: 2.0,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.back,
                                        size: 20,
                                        color: AppColors.blackText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.width * 0.25,
                                width: size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    MyText(
                                        text: AppLocalizations.of(context)!
                                            .walletBalance,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 18)),
                                    // if (context.read<AccBloc>().walletResponse != null)
                                    if (context.read<AccBloc>().isLoading &&
                                        !context.read<AccBloc>().loadMore)
                                      SizedBox(
                                        height: size.width * 0.06,
                                        width: size.width * 0.06,
                                        child: const Loader(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    if (context
                                            .read<AccBloc>()
                                            .walletResponse !=
                                        null)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MyText(
                                              text:
                                                  '${context.read<AccBloc>().walletResponse!.walletBalance.toString()} ${context.read<AccBloc>().walletResponse!.currencySymbol.toString()}',
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge!
                                                  .copyWith(
                                                      color: Colors.white)),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: size.width,
                          padding: EdgeInsets.all(size.width * 0.05),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.width * 0.075,
                              ),
                              Row(
                                children: [
                                  MyText(
                                    text: AppLocalizations.of(context)!
                                        .recentTransactions,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.width * 0.025),
                              if (context.read<AccBloc>().isLoading &&
                                  context.read<AccBloc>().firstLoad)
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: 8,
                                    itemBuilder: (context, index) {
                                      return ShimmerWalletHistory(size: size);
                                    },
                                  ),
                                ),
                              Expanded(
                                child: SingleChildScrollView(
                                  controller:
                                      context.read<AccBloc>().scrollController,
                                  child: Column(
                                    children: [
                                      buildWalletHistoryData(
                                        size,
                                        context
                                            .read<AccBloc>()
                                            .walletHistoryList,
                                        context,
                                      ),
                                      if (context
                                              .read<AccBloc>()
                                              .walletHistoryList
                                              .isNotEmpty &&
                                          context.read<AccBloc>().loadMore)
                                        Center(
                                          child: SizedBox(
                                              height: size.width * 0.08,
                                              width: size.width * 0.08,
                                              child:
                                                  const CircularProgressIndicator()),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: size.width * 0.45,
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          size.width * 0.05,
                          size.width * 0.025,
                          size.width * 0.05,
                          size.width * 0.025),
                      width: size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).shadowColor,
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 5)
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              context
                                  .read<AccBloc>()
                                  .walletAmountController
                                  .clear();
                              context.read<AccBloc>().addMoney = null;
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  enableDrag: false,
                                  isDismissible: true,
                                  backgroundColor:
                                      Theme.of(context).shadowColor,
                                  builder: (_) {
                                    return addMoneyWallet(context, size);
                                  });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyText(
                                    text:
                                        AppLocalizations.of(context)!.addMoney,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontSize: 16)),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                Container(
                                  height: size.width * 0.04,
                                  width: size.width * 0.04,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColorDark)),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.add,
                                      size: size.width * 0.03,
                                      color:
                                          Theme.of(context).primaryColorDark),
                                ),
                              ],
                            ),
                          ),
                          if (context.read<AccBloc>().userData != null &&
                              context
                                      .read<AccBloc>()
                                      .userData!
                                      .showWalletMoneyTransferFeatureOnMobileApp ==
                                  '1')
                            InkWell(
                              onTap: () {
                                context.read<AccBloc>().transferAmount.clear();
                                context
                                    .read<AccBloc>()
                                    .transferPhonenumber
                                    .clear();
                                context.read<AccBloc>().dropdownValue = 'user';
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    enableDrag: false,
                                    isDismissible: true,
                                    backgroundColor:
                                        Theme.of(context).shadowColor,
                                    builder: (_) {
                                      return transferMoney(context, size);
                                    });
                              },
                              child: Row(
                                children: [
                                  MyText(
                                      text: AppLocalizations.of(context)!
                                          .transferMoney,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColorDark,fontSize: 16)),
                                  SizedBox(
                                    width: size.width * 0.02,
                                  ),
                                  Container(
                                    height: size.width * 0.04,
                                    width: size.width * 0.04,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .primaryColorDark)),
                                    alignment: Alignment.center,
                                    child: Icon(Icons.arrow_downward,
                                        size: size.width * 0.03,
                                        color:
                                            Theme.of(context).primaryColorDark),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    )),
              ],
            ),
          );
          // }
          // return const Scaffold();
        }),
      ),
    );
  }

  Widget buildWalletHistoryData(Size size,
      List<WalletHistoryData> walletHistoryList, BuildContext context) {
    return walletHistoryList.isNotEmpty
        ? Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: RawScrollbar(
              radius: const Radius.circular(20),
              child: ListView.builder(
                shrinkWrap: true,
                // reverse: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: walletHistoryList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: size.width,
                        height: size.width * 0.175,
                        margin: EdgeInsets.only(bottom: size.width * 0.030),
                        padding: EdgeInsets.all(size.width * 0.025),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(width: 0.5, color: AppColors.darkGrey),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: size.width * 0.15,
                              width: size.width * 0.125,
                              decoration: BoxDecoration(
                                // color: Theme.of(context).primaryColorLight,
                                color: Theme.of(context).dividerColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: (walletHistoryList[index].remarks ==
                                      'Money Deposited')
                                  ? Image.asset(
                                      'assets/images/money_deposite.png',
                                      fit: BoxFit.contain,
                                      width: size.width * 0.065,
                                      color: AppColors.black,
                                    )
                                  : Image.asset(
                                      'assets/images/transfer-money.png',
                                      fit: BoxFit.contain,
                                      width: size.width * 0.065,
                                      color: AppColors.black,
                                    ),
                            ),
                            SizedBox(
                              width: size.width * 0.025,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyText(
                                      text: walletHistoryList[index].remarks,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  MyText(
                                      text: walletHistoryList[index].createdAt,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .disabledColor)),
                                ],
                              ),
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText(
                                    text:
                                        (walletHistoryList[index].isCredit == 0)
                                            ? '- '
                                            : '+ ',
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color: (walletHistoryList[index]
                                                        .isCredit ==
                                                    0)
                                                ? AppColors.red
                                                : AppColors.green,
                                            fontWeight: FontWeight.w600)),
                                MyText(
                                    text:
                                        '${walletHistoryList[index].currencySymbol} ${walletHistoryList[index].amount}',
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color: (walletHistoryList[index]
                                                        .isCredit ==
                                                    0)
                                                ? AppColors.red
                                                : AppColors.green,
                                            fontWeight: FontWeight.w600)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.walletNoData,
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 10),
                  MyText(
                    text: AppLocalizations.of(context)!.paymenyHistoryEmpty,
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).disabledColor, fontSize: 18),
                  ),
                  MyText(
                    text: AppLocalizations.of(context)!.paymenyHistoryEmptyText,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).disabledColor, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
  }

  Widget addMoneyWallet(BuildContext context, Size size) {
    return StatefulBuilder(builder: (_, add) {
      return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 1,
                blurRadius: 1,
              )
            ]),
        child: Container(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: size.width * 0.128,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 1.2, color: Theme.of(context).disabledColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: size.width * 0.15,
                      height: size.width * 0.128,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        color: Theme.of(context).disabledColor.withOpacity(0.1),
                      ),
                      alignment: Alignment.center,
                      child: MyText(
                          text: context
                              .read<AccBloc>()
                              .walletResponse!
                              .currencySymbol),
                    ),
                    SizedBox(
                      width: size.width * 0.05,
                    ),
                    Container(
                      height: size.width * 0.128,
                      width: size.width * 0.6,
                      alignment: Alignment.center,
                      child: TextField(
                        controller:
                            context.read<AccBloc>().walletAmountController,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            context.read<AccBloc>().addMoney = int.parse(value);
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              AppLocalizations.of(context)!.enterAmountHere,
                          hintStyle: const TextStyle(fontSize: 14),
                        ),
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: size.width * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      context.read<AccBloc>().walletAmountController.text =
                          '100';
                      context.read<AccBloc>().addMoney = 100;
                    },
                    child: Container(
                      height: size.width * 0.11,
                      width: size.width * 0.17,
                      // width: size.width *
                      //     0.275,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).disabledColor,
                              width: 1.2),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(6)),
                      alignment: Alignment.center,
                      child: MyText(
                          text:
                              '${context.read<AccBloc>().walletResponse!.currencySymbol.toString()}100'),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  InkWell(
                    onTap: () {
                      context.read<AccBloc>().walletAmountController.text =
                          '500';
                      context.read<AccBloc>().addMoney = 500;
                    },
                    child: Container(
                      height: size.width * 0.11,
                      width: size.width * 0.17,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).disabledColor,
                              width: 1.2),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(6)),
                      alignment: Alignment.center,
                      child: MyText(
                          text:
                              '${context.read<AccBloc>().walletResponse!.currencySymbol.toString()}500'),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  InkWell(
                    onTap: () {
                      context.read<AccBloc>().walletAmountController.text =
                          '1000';
                      context.read<AccBloc>().addMoney = 1000;
                    },
                    child: Container(
                      height: size.width * 0.11,
                      width: size.width * 0.17,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).disabledColor,
                              width: 1.2),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(6)),
                      alignment: Alignment.center,
                      child: MyText(
                          text:
                              '${context.read<AccBloc>().walletResponse!.currencySymbol.toString()}1000'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.width * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: size.width * 0.11,
                      width: size.width * 0.425,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: (Theme.of(context).brightness ==
                                      Brightness.light)
                                  ? Theme.of(context).primaryColor
                                  : AppColors.white,
                              width: 1.2),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(6)),
                      alignment: Alignment.center,
                      child: MyText(
                        text: AppLocalizations.of(context)!.cancel,
                        textStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: (Theme.of(context).brightness ==
                                          Brightness.light)
                                      ? Theme.of(context).primaryColor
                                      : AppColors.white,
                                ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (context
                              .read<AccBloc>()
                              .walletAmountController
                              .text
                              .isNotEmpty &&
                          context.read<AccBloc>().addMoney != null) {
                        Navigator.pop(context);
                        final confirmPayment = context.read<AccBloc>();
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: false,
                            enableDrag: true,
                            isDismissible: true,
                            builder: (_) {
                              return BlocProvider.value(
                                value: confirmPayment,
                                child: paymentGatewaysList(
                                    context,
                                    size,
                                    context
                                        .read<AccBloc>()
                                        .walletPaymentGatways),
                              );
                            });
                      }
                    },
                    child: Container(
                      height: size.width * 0.11,
                      width: size.width * 0.425,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(6)),
                      alignment: Alignment.center,
                      child: MyText(
                        text: AppLocalizations.of(context)!.addMoney,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.width * 0.05),
            ],
          ),
        ),
      );
    });
  }

  Widget transferMoney(BuildContext context, Size size) {
    return StatefulBuilder(builder: (_, add) {
      return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.05),
                topRight: Radius.circular(size.width * 0.05)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 1,
                blurRadius: 1,
              )
            ]),
        width: size.width,
        child: Container(
          padding: EdgeInsets.fromLTRB(size.width * 0.05, size.width * 0.05,
              size.width * 0.05, MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).disabledColor,
                      width: 1.2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Theme.of(context).disabledColor,
                    width: 1.2,
                    style: BorderStyle.solid,
                  )),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Theme.of(context).disabledColor,
                    width: 1.2,
                    style: BorderStyle.solid,
                  )),
                ),
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                value: context.read<AccBloc>().dropdownValue,
                onChanged: (String? newValue) {
                  context.read<AccBloc>().add(TransferMoneySelectedEvent(
                      selectedTransferAmountMenuItem: newValue!));
                },
                items: context.read<AccBloc>().dropdownItems,
              ),
              TextFormField(
                controller: context.read<AccBloc>().transferAmount,
                style: Theme.of(context).textTheme.bodyMedium,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enterAmountHere,
                  counterText: '',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).disabledColor,
                      width: 1.2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  prefixIcon: SizedBox(
                      height: size.width * 0.1,
                      width: size.width * 0.08,
                      child: Center(
                          child: MyText(text: arg.userData.currencySymbol))),
                  prefixIconConstraints: BoxConstraints(
                    maxWidth: size.width * 0.08,
                    maxHeight: size.width * 0.1,
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Theme.of(context).disabledColor,
                    width: 1.2,
                    style: BorderStyle.solid,
                  )),
                ),
              ),
              TextFormField(
                controller: context.read<AccBloc>().transferPhonenumber,
                style: Theme.of(context).textTheme.bodyMedium,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enterMobileNumber,
                  counterText: '',
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Theme.of(context).disabledColor,
                    width: 1.2,
                    style: BorderStyle.solid,
                  )),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Theme.of(context).disabledColor,
                    width: 1.2,
                    style: BorderStyle.solid,
                  )),
                  prefixIcon: SizedBox(
                      height: size.width * 0.1,
                      width: size.width * 0.08,
                      child: Center(
                          child: MyText(text: arg.userData.countryCode))),
                  prefixIconConstraints: BoxConstraints(
                    maxWidth: size.width * 0.08,
                    maxHeight: size.width * 0.1,
                  ),
                ),
              ),
              SizedBox(height: size.width * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: size.width * 0.11,
                      width: size.width * 0.425,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: (Theme.of(context).brightness ==
                                      Brightness.light)
                                  ? Theme.of(context).primaryColor
                                  : AppColors.white,
                              width: 1.2),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(6)),
                      alignment: Alignment.center,
                      child: MyText(
                        text: AppLocalizations.of(context)!.cancel,
                        textStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: (Theme.of(context).brightness ==
                                          Brightness.light)
                                      ? Theme.of(context).primaryColor
                                      : AppColors.white,
                                ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (context.read<AccBloc>().transferAmount.text == '' ||
                          context.read<AccBloc>().transferPhonenumber.text ==
                              '') {
                      } else {
                        context.read<AccBloc>().add(MoneyTransferedEvent(
                            transferAmount:
                                context.read<AccBloc>().transferAmount.text,
                            role: context.read<AccBloc>().dropdownValue,
                            transferMobile: context
                                .read<AccBloc>()
                                .transferPhonenumber
                                .text));
                        // Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: size.width * 0.11,
                      width: size.width * 0.425,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(6)),
                      alignment: Alignment.center,
                      child: MyText(
                        text:
                            AppLocalizations.of(context)!.transferMoney,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.width * 0.05),
            ],
          ),
        ),
      );
    });
  }

  Widget paymentGatewaysList(BuildContext context, Size size,
      List<PaymentGateway> walletPaymentGatways) {
    return BlocBuilder<AccBloc, AccState>(builder: (context, state) {
      return walletPaymentGatways.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: size.width * 0.05),
                  ListView.builder(
                    itemCount: walletPaymentGatways.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return (walletPaymentGatways[index].enabled == true)
                          ? Padding(
                              padding:
                                  EdgeInsets.only(bottom: size.width * 0.025),
                              child: InkWell(
                                onTap: () {
                                  context.read<AccBloc>().add(PaymentOnTapEvent(
                                      selectedPaymentIndex: index));
                                },
                                child: Container(
                                  width: size.width * 0.9,
                                  padding: EdgeInsets.all(size.width * 0.02),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 0.5,
                                          color:
                                              Theme.of(context).disabledColor)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: size.width * 0.1,
                                              width: size.width * 0.08,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    walletPaymentGatways[index]
                                                        .image,
                                                fit: BoxFit.contain,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child: Loader(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Center(
                                                  child: Text(""),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: size.width * 0.03),
                                            MyText(
                                                text:
                                                    walletPaymentGatways[index]
                                                        .gateway
                                                        .toString(),
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColorDark)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: size.width * 0.05,
                                        height: size.width * 0.05,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 1.5,
                                                color: Theme.of(context)
                                                    .primaryColorDark)),
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: size.width * 0.03,
                                          height: size.width * 0.03,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: (context
                                                          .read<AccBloc>()
                                                          .choosenPaymentIndex ==
                                                      index)
                                                  ? Theme.of(context)
                                                      .primaryColorDark
                                                  : Colors.transparent),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                  const Spacer(),
                  CustomButton(
                      buttonName: AppLocalizations.of(context)!.pay,
                      onTap: () async {
                        Navigator.pop(context);
                        context.read<AccBloc>().add(WalletPageReUpdateEvent(
                            currencySymbol: context
                                .read<AccBloc>()
                                .walletResponse!
                                .currencySymbol,
                            from: '',
                            requestId: '',
                            money: context.read<AccBloc>().addMoney.toString(),
                            url: walletPaymentGatways[context
                                    .read<AccBloc>()
                                    .choosenPaymentIndex!]
                                .url,
                            userId: context
                                .read<AccBloc>()
                                .userData!
                                .id
                                .toString()));
                      }),
                  SizedBox(height: size.width * 0.05)
                ],
              ),
            )
          : const SizedBox();
    });
  }
}
