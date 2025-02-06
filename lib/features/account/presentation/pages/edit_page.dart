import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/core/network/extensions.dart';
import '../../../../common/app_arguments.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/acc_bloc.dart';
import '../widgets/edit_options.dart';
import '../widgets/profile_design.dart';
import 'update_details.dart';

class EditPage extends StatelessWidget {
  static const String routeName = '/editPage';
  final EditPageArguments arg;
  const EditPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(UserDataInitEvent(userDetails: arg.userData)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is UserProfileDetailsLoadingState) {
            CustomLoader.loader(context);
          } else if (state is UpdateUserDetailsFailureState) {
            context.showSnackBar(message: AppLocalizations.of(context)!.failedUpdateDetails);
          } else if (state is UserDetailsUpdatedState) {
            context.read<AccBloc>().userData!.name = state.name;
            context.read<AccBloc>().userData!.email = state.email;
            context.read<AccBloc>().userData!.gender = state.gender;
            context.read<AccBloc>().userData!.profilePicture =
                state.profileImage;
          } else if (state is UserDetailEditState) {
            Navigator.pushNamed(
              context,
              UpdateDetails.routeName,
              arguments: UpdateDetailsArguments(
                  header: state.header,
                  text: state.text,
                  userData: context.read<AccBloc>().userData!),
            ).then(
              (value) {
                if (!context.mounted) return;
                if (value != null) {
                  final data = value as UserDetailsUpdatedState;
                  context.read<AccBloc>().userData!.name = data.name;
                  context.read<AccBloc>().userData!.email = data.email;
                  context.read<AccBloc>().userData!.gender = data.gender;
                  context.read<AccBloc>().userData!.profilePicture =
                      data.profileImage;
                  context.read<AccBloc>().add(AccUpdateEvent());
                }
              },
            );
          }
        },
        child: BlocBuilder<AccBloc, AccState>(
          builder: (context, state) {
            return (context.read<AccBloc>().userData != null)
                ? Directionality(
                    textDirection:
                        context.read<AccBloc>().textDirection == 'rtl'
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                    child: Scaffold(
                      body: ProfileWidget(
                        isEditPage: true,
                        showWallet: false,
                        walletBalance: '',
                        ratings: '',
                        trips: '',
                        profileUrl:
                            context.read<AccBloc>().userData!.profilePicture,
                        userName: context.read<AccBloc>().userData!.name,
                        user: context.read<AccBloc>().userData!,
                        backOnTap: () {
                          Navigator.pop(
                              context, context.read<AccBloc>().userData);
                        },
                        child: SizedBox(
                          height: size.height * 0.7,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  MyText(
                                    text: AppLocalizations.of(context)!
                                        .personalInformation,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            color:
                                                Theme.of(context).primaryColorDark,fontSize: 20),
                                  ),
                                  const SizedBox(height: 10),
                                  EditOptions(
                                    text:
                                        context.read<AccBloc>().userData!.name,
                                    header: AppLocalizations.of(context)!.name,
                                    onTap: () {
                                      context.read<AccBloc>().add(
                                          UserDetailEditEvent(
                                              header:
                                                  AppLocalizations.of(context)!
                                                      .name,
                                              text: context
                                                  .read<AccBloc>()
                                                  .userData!
                                                  .name));
                                    },
                                  ),
                                  EditOptions(
                                    text: context
                                        .read<AccBloc>()
                                        .userData!
                                        .mobile,
                                    header: AppLocalizations.of(context)!
                                        .mobileNumber,
                                    onTap: () {},
                                  ),
                                  EditOptions(
                                    text:
                                        context.read<AccBloc>().userData!.email,
                                    header: AppLocalizations.of(context)!
                                        .emailAddress,
                                    onTap: () {
                                      context.read<AccBloc>().add(
                                          UserDetailEditEvent(
                                              header:
                                                  AppLocalizations.of(context)!
                                                      .emailAddress,
                                              text: context
                                                  .read<AccBloc>()
                                                  .userData!
                                                  .email));
                                    },
                                  ),
                                  EditOptions(
                                    text: context
                                        .read<AccBloc>()
                                        .userData!
                                        .gender,
                                    header:
                                        AppLocalizations.of(context)!.gender,
                                    onTap: () {
                                      context.read<AccBloc>().add(
                                            UserDetailEditEvent(
                                              header:
                                                  AppLocalizations.of(context)!
                                                      .gender,
                                              text: context
                                                  .read<AccBloc>()
                                                  .userData!
                                                  .gender,
                                            ),
                                          );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                        
                    ),
                  )
                : const Scaffold(
                    body: Loader(),
                  );
          },
        ),
      ),
    );
  }
}
