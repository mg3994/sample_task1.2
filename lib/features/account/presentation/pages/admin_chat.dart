import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/acc_bloc.dart';
import '../../domain/models/admin_chat_model.dart';
import '../widgets/top_bar.dart';

class AdminChat extends StatelessWidget {
  static const String routeName = '/adminchat';
  final AdminChatPageArguments arg;
  const AdminChat({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
      ..add(AdminChatInitEvent(arg: arg)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is SendAdminMessageSuccessState) {
            context.read<AccBloc>().add(GetAdminChatHistoryListEvent());
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Scaffold(
            body: TopBarDesign(
              isHistoryPage: false,
              title: AppLocalizations.of(context)!.adminChat,
              onTap: () {
                Navigator.of(context).pop();
                context.read<AccBloc>().chatStream!.cancel();
              },
              controller: context.read<AccBloc>().scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    buildAdminChatHistoryData(
                        context, size, context.read<AccBloc>().adminChatList),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.fromLTRB(
                  10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                width: size.width * 0.9,
                margin: EdgeInsets.only(bottom: size.width * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.darkGrey, 
                       width: 1.2),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.7,
                        child: TextField(
                          controller: context.read<AccBloc>().adminchatText,
                          decoration:  InputDecoration(
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)!.typeMessage,
                          ),
                          minLines: 1,
                          maxLines: 4,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (context
                              .read<AccBloc>()
                              .adminchatText
                              .text
                              .isNotEmpty) {
                            context.read<AccBloc>().add(
                                  SendAdminMessageEvent(
                                    newChat: context
                                            .read<AccBloc>()
                                            .adminChatList
                                            .isEmpty
                                        ? '0'
                                        : '1',
                                    message: context
                                        .read<AccBloc>()
                                        .adminchatText
                                        .text,
                                    chatId: context
                                            .read<AccBloc>()
                                            .adminChatList
                                            .isEmpty
                                        ? ""
                                        : context
                                            .read<AccBloc>()
                                            .adminChatList[0]
                                            .conversationId,
                                  ),
                                );
                            context.read<AccBloc>().adminchatText.clear();
                          }
                        },
                        child: const Icon(
                          Icons.send,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildAdminChatHistoryData(
      BuildContext context, Size size, List<ChatData> adminChatList) {  
    return adminChatList.isNotEmpty
        ? ListView.builder(
            itemCount: adminChatList.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<AccBloc>().scrollController.animateTo(
                    context
                        .read<AccBloc>()
                        .scrollController
                        .position
                        .maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease);
              });
              return (context.read<AccBloc>().userData != null)
                  ? Container(
                      padding: EdgeInsets.only(top: size.width * 0.01),
                      width: size.width * 0.9,
                      alignment: (adminChatList[index].senderId ==
                              context.read<AccBloc>().userData!.id.toString())
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: (adminChatList[index].senderId ==
                                context.read<AccBloc>().userData!.id.toString())
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          (adminChatList[index].senderId ==
                                  context
                                      .read<AccBloc>()
                                      .userData!
                                      .id
                                      .toString())
                              ? Card(
                                  elevation: 5,
                                  child: Container(
                                    width: size.width * 0.5,
                                    padding: EdgeInsets.all(size.width * 0.03),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft:
                                              (adminChatList[index].senderId ==
                                                      context
                                                          .read<AccBloc>()
                                                          .userData!
                                                          .id
                                                          .toString())
                                                  ? Radius.circular(
                                                      size.width * 0.02)
                                                  : const Radius.circular(0),
                                          topRight:
                                              (adminChatList[index].senderId ==
                                                      context
                                                          .read<AccBloc>()
                                                          .userData!
                                                          .id
                                                          .toString())
                                                  ? const Radius.circular(0)
                                                  : Radius.circular(
                                                      size.width * 0.02),
                                          bottomRight: Radius.circular(
                                              size.width * 0.02),
                                          bottomLeft: Radius.circular(
                                              size.width * 0.02),
                                        ),
                                        color: (adminChatList[index].senderId ==
                                                      context
                                                          .read<AccBloc>()
                                                          .userData!
                                                          .id
                                                          .toString())
                                                              ? (Theme.of(context).brightness==Brightness.dark)?const Color(
                                                                  0xffE7EDEF):AppColors.black
                                                              : const Color(
                                                                  0xffE7EDEF)
                                        ),
                                    child: MyText(
                                      text: adminChatList[index].message,
                                      overflow: TextOverflow.visible,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            // color: AppColors.white
                                            color: (adminChatList[index].senderId ==
                                                      context
                                                          .read<AccBloc>()
                                                          .userData!
                                                          .id
                                                          .toString())
                                                              ? (Theme.of(context).brightness==Brightness.dark)?AppColors.black:AppColors.white:AppColors.black
                                            ),
                                    ),
                                  ),
                                )
                              : Card(
                                  elevation: 5,
                                  shadowColor: Theme.of(context).shadowColor,
                                  child: Container(
                                    width: size.width * 0.5,
                                    padding: EdgeInsets.all(size.width * 0.03),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(0),
                                          topRight: Radius.circular(
                                              size.width * 0.024),
                                          bottomRight: Radius.circular(
                                              size.width * 0.024),
                                          bottomLeft: Radius.circular(
                                              size.width * 0.024),
                                        ),
                                        color: (adminChatList[index].senderId ==
                                                      context
                                                          .read<AccBloc>()
                                                          .userData!
                                                          .id
                                                          .toString())
                                                              ? (Theme.of(context).brightness==Brightness.dark)?const Color(
                                                                  0xffE7EDEF):AppColors.black
                                                              : const Color(
                                                                  0xffE7EDEF)
                                            ),
                                    child: MyText(
                                      text: adminChatList[index].message,
                                      overflow: TextOverflow.visible,                                      
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: (adminChatList[index].senderId ==
                                                      context
                                                          .read<AccBloc>()
                                                          .userData!
                                                          .id
                                                          .toString())
                                                              ? (Theme.of(context).brightness==Brightness.dark)?AppColors.black:AppColors.white:AppColors.black
                                                  ),
                                    ),
                                  ),
                                ),
                          SizedBox(height: size.width * 0.01),
                          MyText(
                            text: adminChatList[index].userTimezone,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: Theme.of(context).dividerColor),
                          ),
                        ],
                      ),
                    
                    )
                  : const Loader();
            },
          )
        : const SizedBox();
  }
}
