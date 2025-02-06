import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/core/network/extensions.dart';
import '../../../../common/app_arguments.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/acc_bloc.dart';

class UpdateDetails extends StatelessWidget {
  static const String routeName = '/UpdateDetails';
  final UpdateDetailsArguments arg;

  const UpdateDetails({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(UpdateControllerWithDetailsEvent(args: arg)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          } else if (state is UserDetailsUpdatedState) {
            context.showSnackBar(
                color: Theme.of(context).primaryColor,
                message: AppLocalizations.of(context)!.updateSuccess);
            Navigator.pop(context, state);
          } else if (state is UpdateUserDetailsFailureState) {
            context.showSnackBar(
                color: Theme.of(context).primaryColor,
                message: AppLocalizations.of(context)!.failedUpdateDetails);
          }
        },
        child: BlocBuilder<AccBloc, AccState>(
          builder: (context, state) {
            return Scaffold(
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Future.delayed(const Duration(milliseconds: 150), () {
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            });
                          },
                          icon: Icon(CupertinoIcons.back,
                              color: Theme.of(context).primaryColorDark),
                        ),
                        MyText(
                          text: AppLocalizations.of(context)!.updateText.replaceAll('***', arg.header),
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: arg.header,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          MyText(
                            text: AppLocalizations.of(context)!.youCanEdit.replaceAll('***', arg.header),
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: Theme.of(context).disabledColor),
                          ),
                          SizedBox(height: size.height * 0.02),
                          if (arg.header ==
                              AppLocalizations.of(context)!.gender)
                            BlocBuilder<AccBloc, AccState>(
                              builder: (context, state) {
                                List<String> showGenderList = [
                                  AppLocalizations.of(context)!.male,
                                  AppLocalizations.of(context)!.female,
                                  AppLocalizations.of(context)!.preferNotSay,
                                ];
                                return DropdownButtonFormField<String>(
                                  alignment: Alignment.bottomCenter,
                                  dropdownColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  isExpanded: true,
                                  decoration:  InputDecoration(
                                    fillColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    filled: true,
                                    hintText: context
                                            .read<AccBloc>()
                                            .selectedGender
                                            .isNotEmpty
                                        ? context.read<AccBloc>().selectedGender
                                        : AppLocalizations.of(context)!
                                            .selectGender,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                  ),
                                  items: showGenderList
                                      .map((gender) {
                                    return DropdownMenuItem<String>(
                                      value: gender,
                                      child: Text(gender),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    int index = showGenderList
                                        .indexOf(newValue.toString());
                                    if (index != -1) {
                                      String codedValue = context
                                          .read<AccBloc>()
                                          .genderOptions[index];
                                      context.read<AccBloc>().add(
                                          GenderSelectedEvent(
                                              selectedGender: codedValue));
                                    }
                                  },
                                );
                              },
                            ),
                          if (arg.header !=
                              AppLocalizations.of(context)!.gender)
                            CustomTextField(
                              controller:
                                  context.read<AccBloc>()
                                  .updateController,
                              hintText: arg.header,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                                  autofocus: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).disabledColor),
                            ),
                          Divider(
                              height: 1, color: Theme.of(context).dividerColor),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: CustomButton(
                        isLoader: BlocProvider.of<AccBloc>(context).isLoading,
                        buttonName: AppLocalizations.of(context)!.update,
                        onTap: () {
                          context.read<AccBloc>().add(UpdateUserDetailsEvent(
                              name: arg.header ==
                                      AppLocalizations.of(context)!.name
                                  ? BlocProvider.of<AccBloc>(context)
                                      .updateController
                                      .text
                                  : context.read<AccBloc>().userData!.name,
                              email: arg.header ==
                                      AppLocalizations.of(context)!.emailAddress
                                  ? BlocProvider.of<AccBloc>(context)
                                      .updateController
                                      .text
                                  : context.read<AccBloc>().userData!.email,
                              gender: arg.header ==
                                      AppLocalizations.of(context)!.gender
                                  ? context.read<AccBloc>()
                                      .selectedGender
                                  : context.read<AccBloc>().userData!.gender,
                              profileImage:
                                  context.read<AccBloc>().profileImage.isEmpty
                                      ? ""
                                      : context.read<AccBloc>().profileImage));
                        },
                      ),
                    ),
                    SizedBox(height: size.width * 0.1),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
