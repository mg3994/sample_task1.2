import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/core/utils/custom_button.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../application/acc_bloc.dart';

class DeleteAccount extends StatelessWidget {
  static const String routeName = '/deleteAccount';

  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => AccBloc()..add(AccGetDirectionEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {},
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Directionality(
            textDirection: context.read<AccBloc>().textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: PopScope(
              canPop: false,
              child: Scaffold(
                  body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.width * 0.05),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            MyText(
                              text: AppLocalizations.of(context)!.deleteAccount,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: Theme.of(context).primaryColorDark,fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.width * 0.05),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: MyText(
                          text: AppLocalizations.of(context)!
                              .deleteDetailText
                              .replaceAll('***', '30')
                              .replaceAll('**', '24'),
                          maxLines: 8,
                        ),
                      ),
                      SizedBox(height: size.width * 0.1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomButton(
                          buttonName: AppLocalizations.of(context)!.okText,
                          width: size.width,
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, AuthPage.routeName, (route) => false);
                          },
                        ),
                      ),
                      SizedBox(height: size.width * 0.1)
                    ],
                  ),
                ),
              )),
            ),
          );
        }),
      ),
    );
  }
}
