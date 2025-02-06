import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/common.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../landing/presentation/page/landing_page.dart';
import '../../../../app/localization.dart';
import '../../../language/presentation/page/choose_language_page.dart';
import '../../application/loader_bloc.dart';

class LoaderPage extends StatefulWidget {
  static const String routeName = '/loaderPage';

  const LoaderPage({super.key});

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => LoaderBloc()..add(LoaderGetLocalDataEvent()),
      child: BlocListener<LoaderBloc, LoaderState>(
        listener: (context, state) {
          if (state is LoaderSuccessState) {
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) {
                Future.delayed(const Duration(seconds: 2), () {
                  if (state.selectedLanguage.isNotEmpty) {
                    if (!context.mounted) return;
                    context.read<LocalizationBloc>().add(
                        LocalizationInitialEvent(
                            isDark:
                                Theme.of(context).brightness == Brightness.dark,
                            locale: Locale(state.selectedLanguage)));
                    if (!state.loginStatus) {
                      if (!state.landingStatus) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, LandingPage.routeName, (route) => false);
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                            context, AuthPage.routeName, (route) => false);
                      }
                    } else {
                      context.read<LoaderBloc>().add(UpdateUserLocationEvent());
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomePage.routeName, (route) => false);
                    }
                  } else {
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      ChooseLanguagePage.routeName,
                      (route) => false,
                      arguments: ChooseLanguageArguments(
                          isInitialLanguageChange: true),
                    );
                  }
                });
              },
            );
          }
        },
        child: BlocBuilder<LoaderBloc, LoaderState>(
          builder: (context, state) {
            return PopScope(
            canPop: false,
            child :Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.loader,
                      width: size.width * 0.51,
                      height: size.height * 0.51,
                    )
                  ],
                ),
              ),
            ));
          },
        ),
      ),
    );
  }
}
