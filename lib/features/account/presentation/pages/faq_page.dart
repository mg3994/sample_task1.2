import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../../../../core/utils/custom_text.dart';
import '../../application/acc_bloc.dart';
import '../../domain/models/faq_model.dart';
import '../widgets/top_bar.dart';

class FaqPage extends StatelessWidget {
  static const String routeName = '/faqPage';

  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(GetFaqListEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {},
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Directionality(
            textDirection: context.read<AccBloc>().textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              body: TopBarDesign(
                isHistoryPage: false,
                title: AppLocalizations.of(context)!.faq,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (context.read<AccBloc>().faqDataList.isNotEmpty) ...[
                        buildFaqDataList(
                            size, context.read<AccBloc>().faqDataList),
                        SizedBox(height: size.width * 0.05),
                      ],
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

  Widget buildFaqDataList(Size size, List<FaqData> faqDataList) {
    return faqDataList.isNotEmpty
        ? SizedBox(
            height: size.height * 0.725,
            child: RawScrollbar(
              radius: const Radius.circular(20),
              child: ListView.builder(
                itemCount: faqDataList.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      context
                          .read<AccBloc>()
                          .add(FaqOnTapEvent(selectedFaqIndex: index));
                    },
                    child: Container(
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
                            SizedBox(width: size.width * 0.025),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MyText(
                                          text: faqDataList[index].question,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                              ),
                                          maxLines: 2,
                                        ),
                                      ),
                                      RotatedBox(
                                          quarterTurns: (context
                                                      .read<AccBloc>()
                                                      .choosenFaqIndex ==
                                                  index)
                                              ? 2
                                              : 4,
                                          child: Icon(Icons.arrow_drop_down,
                                              color: Theme.of(context)
                                                  .primaryColorDark))
                                    ],
                                  ),
                                  (context.read<AccBloc>().choosenFaqIndex ==
                                          index)
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: size.width * 0.025,
                                            ),
                                            SizedBox(
                                              width: size.width * 0.8,
                                              child: MyText(
                                                text: faqDataList[index].answer,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .disabledColor
                                                            .withOpacity(0.6)),
                                                maxLines: 10,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        : const SizedBox();
  }
}
