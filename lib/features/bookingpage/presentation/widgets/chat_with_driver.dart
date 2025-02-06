import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../application/booking_bloc.dart';
import '../../domain/models/chat_history_model.dart';

class ChatWithDriverWidget extends StatelessWidget {
  static const String routeName = '/driverChat';

  const ChatWithDriverWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
      return Scaffold(
        body: Stack(
          children: [
            Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: const DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage(AppImages.map),
                ),
              ),
              child: Column(
                children: [
                  SafeArea(
                    child: SizedBox(
                      height: size.width * 0.45,
                      width: size.width,
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: MediaQuery.of(context)
                                              .systemGestureInsets
                                              .top),
                                      child: Container(
                                        height: size.height * 0.08,
                                        width: size.width * 0.08,
                                        decoration: const BoxDecoration(
                                          color: AppColors.white,
                                          shape: BoxShape.circle,
                                          boxShadow:  [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(5.0, 5.0),
                                              blurRadius: 10.0,
                                              spreadRadius: 2.0,
                                            ),
                                          ],
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          highlightColor: Theme.of(context)
                                              .disabledColor
                                              .withOpacity(0.1),
                                          splashColor: Theme.of(context)
                                              .disabledColor
                                              .withOpacity(0.2),
                                          hoverColor: Theme.of(context)
                                              .disabledColor
                                              .withOpacity(0.05),
                                          child: const Icon(
                                            CupertinoIcons.back,
                                            size: 20,
                                            color:
                                                AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyText(
                                        text: context
                                            .read<BookingBloc>()
                                            .driverData!
                                            .name,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: AppColors.white,
                                            ),
                                      ),
                                      Container(
                                        height: size.width * 0.13,
                                        width: size.width * 0.13,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: Theme.of(context)
                                                .disabledColor
                                                .withOpacity(0.2)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: CachedNetworkImage(
                                            imageUrl: context
                                                .read<BookingBloc>()
                                                .driverData!
                                                .profilePicture,
                                            fit: BoxFit.fill,
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
                                      ),
                                    ],
                                  ),
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
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: size.width * 0.05,
                            ),
                            Expanded(
                                child: SingleChildScrollView(
                              controller: context
                                  .read<BookingBloc>()
                                  .chatScrollController,
                              child: Column(
                                children: [
                                  chatHistoryData(
                                      size,
                                      context
                                          .read<BookingBloc>()
                                          .chatHistoryList),
                                ],
                              ),
                            )),
                            SizedBox(height: size.width * 0.05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: context
                                        .read<BookingBloc>()
                                        .chatController,
                                    hintText: AppLocalizations.of(context)!.typeMessage,
                                    // maxLine: 4,
                                  ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                InkWell(
                                    onTap: () {
                                      if (context
                                          .read<BookingBloc>()
                                          .chatController
                                          .text
                                          .isNotEmpty) {
                                        context.read<BookingBloc>().add(
                                            SendChatMessageEvent(
                                                message: context
                                                    .read<BookingBloc>()
                                                    .chatController
                                                    .text,
                                                requestId: context
                                                    .read<BookingBloc>()
                                                    .requestData!
                                                    .id));
                                        context
                                            .read<BookingBloc>()
                                            .chatController
                                            .clear();
                                      }
                                    },
                                    child: Icon(Icons.send,
                                        color:
                                            Theme.of(context).primaryColorDark))
                              ],
                            ),
                            SizedBox(
                              height: size.width * 0.05,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget chatHistoryData(Size size, List<ChatHistoryData> chatList) {
    return chatList.isNotEmpty
        ? RawScrollbar(
            radius: const Radius.circular(20),
            child: ListView.builder(
              itemCount: chatList.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<BookingBloc>().chatScrollController.animateTo(
                      context
                          .read<BookingBloc>()
                          .chatScrollController
                          .position
                          .maxScrollExtent,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                });
                return (context.read<BookingBloc>().userData != null)
                    ? Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: size.width * 0.01),
                            width: size.width * 0.9,
                            alignment: (chatList[index].userId ==
                                    context.read<BookingBloc>().userData!.id)
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: (chatList[index].userId ==
                                      context.read<BookingBloc>().userData!.id)
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Card(
                                  elevation: 5,
                                  child: Container(
                                    width: size.width * 0.5,
                                    padding: EdgeInsets.all(size.width * 0.03),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: (chatList[index].userId ==
                                                  context
                                                      .read<BookingBloc>()
                                                      .userData!
                                                      .id)
                                              ? Radius.circular(
                                                  size.width * 0.02)
                                              : const Radius.circular(0),
                                          topRight: (chatList[index].userId ==
                                                  context
                                                      .read<BookingBloc>()
                                                      .userData!
                                                      .id)
                                              ? const Radius.circular(0)
                                              : Radius.circular(
                                                  size.width * 0.02),
                                          bottomRight: Radius.circular(
                                              size.width * 0.02),
                                          bottomLeft: Radius.circular(
                                              size.width * 0.02),
                                        ),
                                        color: (chatList[index].userId ==
                                                context
                                                    .read<BookingBloc>()
                                                    .userData!
                                                    .id)
                                            ? (Theme.of(context).brightness==Brightness.dark)?const Color(
                                                                  0xffE7EDEF):AppColors.black
                                                              : const Color(
                                                                  0xffE7EDEF)),
                                    child: MyText(
                                      text: chatList[index].message,
                                      maxLines: 5,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: (chatList[index].userId ==
                                                context
                                                    .read<BookingBloc>()
                                                    .userData!
                                                    .id)?(Theme.of(context).brightness==Brightness.dark)?AppColors.black:AppColors.white:AppColors.black),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: size.width * 0.01,
                                ),
                                MyText(
                                  text: chatList[index].convertedCreatedAt,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Theme.of(context).disabledColor),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : const Scaffold(
                        body: Loader(),
                      );
              },
            ),
          )
        : const SizedBox();
  }
}
