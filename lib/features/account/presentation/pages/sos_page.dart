import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_dialoges.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../home/domain/models/contact_model.dart';
import '../../../home/domain/models/user_details_model.dart';
import '../../application/acc_bloc.dart';
import '../widgets/sos_card_shimmer.dart';
import '../widgets/top_bar.dart';
import 'pick_contact.dart';

class SosPage extends StatelessWidget {
  static const String routeName = '/sosPage';
  final SOSPageArguments arg;
  const SosPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(SosInitEvent(arg: arg)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AccDataLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is AccDataLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is SelectContactDetailsState) {
            final accBloc = context.read<AccBloc>();
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              useRootNavigator: true,
              isScrollControlled: true,
              builder: (_) {
                return BlocProvider.value(
                  value: accBloc,
                  child: const PickContact(),
                );
              },
            );
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Scaffold(
              body: TopBarDesign(
                isHistoryPage: false,
                title: AppLocalizations.of(context)!.sos,
                onTap: () {
                  Navigator.pop(context, context.read<AccBloc>().sosdata);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.width *0.10,),
                      if (context.read<AccBloc>().isSosLoading)
                        ListView.builder(
                          itemCount: 6,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return SosShimmerLoading(size: size);
                          },
                        ),
                      if (!context.read<AccBloc>().isSosLoading)
                        sosDetails(
                            size, context.read<AccBloc>().sosdata, context),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: (context.read<AccBloc>().sosdata.length <= 4)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 15),
                      child: CustomButton(
                          buttonName: AppLocalizations.of(context)!.addContact,
                          onTap: () {
                            context.read<AccBloc>().selectedContact =
                                ContactsModel(name: '', number: '');
                            context
                                .read<AccBloc>()
                                .add(SelectContactDetailsEvent());
                          }),
                    )
                  : null);
        }),
      ),
    );
  }

  Widget sosDetails(Size size, List<SOSDatum> sosdata, BuildContext context) {
    return (sosdata.isNotEmpty && sosdata.first.userType != 'admin')
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: sosdata.length,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return (sosdata[index].userType != 'admin')
                  ? Container(
                      width: size.width,
                      margin: const EdgeInsets.only(right: 10, bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              width: 0.5,
                              color: Theme.of(context).disabledColor)),
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.025),
                        child: Row(
                          children: [
                            Container(
                              height: size.width * 0.13,
                              width: size.width * 0.13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.2),
                              ),
                              alignment: Alignment.center,
                              child: MyText(
                                text: sosdata[index]
                                    .name
                                    .toString()
                                    .substring(0, 1),
                              ),
                            ),
                            SizedBox(width: size.width * 0.025),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyText(
                                    text: sosdata[index].name,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Theme.of(context).primaryColorDark),
                                    maxLines: 2,
                                  ),
                                  MyText(
                                    text: sosdata[index].number,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .disabledColor
                                                .withOpacity(0.6)),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: size.width * 0.025),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierColor: Theme.of(context).shadowColor,
                                    builder: (BuildContext _) {
                                      return BlocProvider.value(
                                        value:
                                            BlocProvider.of<AccBloc>(context),
                                        child: CustomDoubleButtonDialoge(
                                          title: AppLocalizations.of(context)!.deleteSos,
                                          content:
                                              AppLocalizations.of(context)!.deleteContact,
                                          yesBtnName: AppLocalizations.of(context)!.yes,
                                          noBtnName: AppLocalizations.of(context)!.no,
                                          yesBtnFunc: () {
                                            context.read<AccBloc>().add(
                                                DeleteContactEvent(
                                                    id: sosdata[index].id));
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(); // Handle cases with admin or no contacts
            },
          )
        : Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, size.height * 0.13, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.sosNoData,
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 10),
                  MyText(
                    text: AppLocalizations.of(context)!.nososContacts,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).disabledColor,fontSize: 18),
                  ),
                  MyText(
                    text: AppLocalizations.of(context)!.addContactsText,
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).disabledColor,fontSize: 16
                        ),
                  ),
                ],
              ),
            ),
          );
  }
}
