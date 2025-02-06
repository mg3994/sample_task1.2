// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/common.dart';
import '../../../core/utils/custom_snack_bar.dart';
import '../../../di/locator.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/models/country_list_model.dart';
import 'usecases/auth_usecase.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final formKey = GlobalKey<FormState>();
  FocusNode textFieldFocus = FocusNode();
  TextEditingController emailOrMobileController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  TextEditingController rUserNameController = TextEditingController();
  TextEditingController rMobileController = TextEditingController();
  TextEditingController rEmailController = TextEditingController();
  TextEditingController rPasswordController = TextEditingController();
  TextEditingController rReferralCodeController = TextEditingController();

  bool isLoading = false;
  bool isLoginByEmail = true;
  bool isOtpVerify = false;
  bool isNewUser = false;
  // bool showLoginBtn = false;
  bool showPassword = false;
  bool isMobileNumber = false;
  bool userExist = false;
  bool isFirebaseOtpVerifyEnable = false;

  int splashIndex = 0;
  int timerDuration = 0;
  int dialMaxLength = 14;
  int isRefferalEarnings = 0;

  String dialCode = '+91';
  String flagImage = '${AppConstants.baseUrl}image/country/flags/IN.png';
  String textDirection = 'ltr';
  String languageCode = 'EN';
  String selectedGender = '';
  String profileImage = '';

  // Firebase
  dynamic firebaseCredentials;
  String firebaseVerificationId = '';
  dynamic firebaseResendToken;

  List<Country> countries = [];
  List<Widget> splashImages = [
    Image.asset(AppImages.splash1),
    Image.asset(AppImages.splash2),
  ];
  List<String> genderList = [
    'Male',
    'Female',
    'Prefer not to say',
  ];

  AuthBloc() : super(AuthInitialState()) {
    // Auth
    on<GetDirectionEvent>(_getDirection);
    on<CountryGetEvent>(_countryList);
    on<SplashImageChangeEvent>(_splashChangeIndex);
    on<EmailorMobileOnChangeEvent>(_emailMobileOnchange);
    on<EmailorMobileOnTapEvent>(_emailMobileOnTap);
    on<EmailorMobileOnSubmitEvent>(_emailMobileOnSubmit);

    // Verify
    on<ShowPasswordIconEvent>(_showPassIconOnChange);
    on<VerifyUserEvent>(_verifyUserDetails);
    on<OTPOnChangeEvent>(_otpOnChange);
    on<GetCommonModuleEvent>(_commonModules);
    on<SignInWithOTPEvent>(_signInWithOTP);
    on<ConfirmOrVerifyOTPEvent>(_confirmOrVerifyOTP);
    on<VerifyTimerEvent>(_timerEvent);

    // Register
    on<RegisterUserEvent>(_registerUser);
    on<RegisterPageInitEvent>(_registerInit);
    on<ImageUpdateEvent>(_getProfileImage);
    on<ReferralEvent>(_getReferralCode);

    // Login
    on<LoginUserEvent>(_loginUser);

    // Update Password
    on<UpdatePasswordEvent>(_updatePassword);
  }

  Future<void> _getDirection(AuthEvent event, Emitter<AuthState> emit) async {
    emit(AuthDataLoadingState());
    textDirection = await AppSharedPreference.getLanguageDirection();
    languageCode = await AppSharedPreference.getSelectedLanguageCode();
    emit(AuthDataSuccessState());
  }

  FutureOr<void> _countryList(AuthEvent event, Emitter<AuthState> emit) async {
    emit(CountryLoadingState());
    textDirection = await AppSharedPreference.getLanguageDirection();
    final data = await serviceLocator<AuthUsecase>().getCountryList();
    data.fold(
      (error) {
        emit(CountryFailureState());
      },
      (success) {
        countries = success.data;
        dialCode = countries
            .firstWhere((element) => element.datumDefault == true)
            .dialCode;
        flagImage = countries
            .firstWhere((element) => element.datumDefault == true)
            .flag!;
        dialMaxLength = countries
            .firstWhere((element) => element.datumDefault == true)
            .dialMaxLength; 
        emit(CountrySuccessState());
      },
    );
  }

  Future<void> _splashChangeIndex(
      SplashImageChangeEvent event, Emitter<AuthState> emit) async {
    splashIndex = event.splashIndex;
    emit(SplashChangeIndexState());
  }

  Future<void> _emailMobileOnchange(
      EmailorMobileOnChangeEvent event, Emitter<AuthState> emit) async {
    if (AppValidation.mobileNumberValidate(event.value)) {
      isLoginByEmail = false;
    } else if (!AppValidation.mobileNumberValidate(event.value)) {
      isLoginByEmail = true;
    }
    emit(EmailorMobileOnChangeState());
  }

  Future<void> _emailMobileOnTap(
      EmailorMobileOnTapEvent event, Emitter<AuthState> emit) async {
    // showLoginBtn = true;
    emit(EmailorMobileOnTapState());
  }

  Future<void> _emailMobileOnSubmit(
      EmailorMobileOnSubmitEvent event, Emitter<AuthState> emit) async {
    // showLoginBtn = false;
    emit(EmailorMobileOnSubmitState());
  }

  // Verify

  Future<void> _showPassIconOnChange(
      ShowPasswordIconEvent event, Emitter<AuthState> emit) async {
    showPassword = !event.showPassword;
    emit(ShowPasswordIconState());
  }

  FutureOr<void> _commonModules(
      AuthEvent event, Emitter<AuthState> emit) async {
    final data = await serviceLocator<AuthUsecase>().commonModuleCheck();
    data.fold(
      (error) {
        // emit(state);
      },
      (success) async {
        isFirebaseOtpVerifyEnable = success.firebaseOtpEnabled;
        isRefferalEarnings = success.enableRefferal;
      },
    );
  }

  Future<void> verifyPhoneNumber(String phoneNumber, context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        firebaseCredentials = credential;
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          debugPrint('The provided phone number is not valid.');
          showToast(message: AppLocalizations.of(context)!.notValidPhoneNumber);
        }
        isLoading = false;
      },
      codeSent: (String verificationId, int? resendToken) async {
        firebaseVerificationId = verificationId;
        firebaseResendToken = resendToken;
        isLoading = false;
        showToast(
            message: AppLocalizations.of(context)!
                .otpSendTo
                .replaceAll('***', phoneNumber));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> _signInWithOTP(
      SignInWithOTPEvent event, Emitter<AuthState> emit) async {
    isLoading = true;
    otpController.text = '';
    isOtpVerify = event.isOtpVerify;
    final firebaseEnabled =
        await FirebaseDatabase.instance.ref().child('call_FB_OTP').get();

    if (firebaseEnabled.value == true && !event.isLoginByEmail) {
      if (isFirebaseOtpVerifyEnable && !event.isLoginByEmail) {
        await verifyPhoneNumber(
            '${event.countryCode}${event.mobileOrEmail}', event.context);
        await Future.delayed(
          const Duration(seconds: 3),
          () {
            isLoading = false;
            emit(SignInWithOTPSuccessState());
            if (event.isForgotPassword) {
              emit(ForgotPasswordOTPSendState());
            }
          },
        );
      } else {
        if (!event.isLoginByEmail) {
          final data = await serviceLocator<AuthUsecase>().sendMobileOtp(
            mobileNumber: event.mobileOrEmail,
            countryCode: event.countryCode,
          );
          data.fold(
            (error) {
              showToast(message: '${error.message}');
              isLoading = false;
              emit(SignInWithOTPFailureState());
            },
            (success) {
              showToast(
                  message: AppLocalizations.of(event.context)!
                      .otpSendTo
                      .replaceAll('***', event.mobileOrEmail));
              isLoading = false;
              emit(SignInWithOTPSuccessState());
              if (event.isForgotPassword) {
                emit(ForgotPasswordOTPSendState());
              }
            },
          );
        }
      }
    } else {
      isLoading = false;
      textFieldFocus.unfocus();
      if (event.isLoginByEmail) {
        final data = await serviceLocator<AuthUsecase>()
            .sendEmailOtp(emailAddress: event.mobileOrEmail);
        data.fold(
          (error) {
            showToast(message: '${error.message}');
            isLoading = false;
            emit(SignInWithOTPFailureState());
          },
          (success) {
            showToast(
                message: AppLocalizations.of(event.context)!
                    .otpSendTo
                    .replaceAll('***', event.mobileOrEmail));
            isLoading = false;
            emit(SignInWithOTPSuccessState());
            if (event.isForgotPassword) {
              emit(ForgotPasswordOTPSendState());
            }
          },
        );
      } else {
        RemoteNotification noti = RemoteNotification(
            title: AppLocalizations.of(event.context)!.otpForLogin,
            body: AppLocalizations.of(event.context)!
                .testOtp
                .replaceAll('***', '123456'));
        showOtpNotification(noti);
        if (event.isForgotPassword) {
          emit(ForgotPasswordOTPSendState());
        }
      }
      emit(SignInWithDemoState());
    }
  }

  Future<void> _confirmOrVerifyOTP(
      ConfirmOrVerifyOTPEvent event, Emitter<AuthState> emit) async {
    isLoading = true;
    emit(VerifyLoadingState());
    final firebaseEnabled =
        await FirebaseDatabase.instance.ref().child('call_FB_OTP').get();
    if (event.otp.isNotEmpty) {
      if (firebaseEnabled.value == true && !event.isLoginByEmail) {
        if (isFirebaseOtpVerifyEnable && !event.isLoginByEmail) {
          try {
            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: event.firebaseVerificationId,
                smsCode: event.otp);
            await FirebaseAuth.instance.signInWithCredential(credential);

            if (!event.isForgotPasswordVerify) {
              if (!event.isUserExist) {
                // New User
                isLoading = false;
                emit(NewUserRegisterState());
              } else {
                // Exist User
                add(LoginUserEvent(
                    emailOrMobile: event.mobileOrEmail,
                    otp: event.otp,
                    password: event.password,
                    isOtpLogin: event.isOtpVerify,
                    isLoginByEmail: event.isLoginByEmail,
                    context: event.context));
              }
            } else {
              isLoading = false;
              emit(ForgotPasswordOTPVerifyState());
            }
          } on FirebaseAuthException catch (error) {
            debugPrint(error.toString());
            if (error.code == 'invalid-verification-code') {
              showToast(
                  message: AppLocalizations.of(event.context)!.enterValidOtp);
              isLoading = false;
              otpController.clear();
              emit(SignInWithOTPFailureState());
            } else {
              showToast(message: error.code);
              isLoading = false;
              otpController.clear();
              emit(SignInWithOTPFailureState());
            }
          }
        } else {
          if (!event.isLoginByEmail) {
            final data = await serviceLocator<AuthUsecase>().verifyMobileOtp(
              mobileNumber: event.mobileOrEmail,
              otp: event.otp,
            );
            data.fold(
              (error) {
                showToast(message: '${error.message}');
                isLoading = false;
                emit(ConfirmOrOTPVerifyFailureState());
              },
              (success) {
                showToast(
                    message: AppLocalizations.of(event.context)!.verifySuccess);
                emit(ConfirmOrOTPVerifySuccessState());
                isLoading = false;
                if (!event.isForgotPasswordVerify) {
                  if (!event.isUserExist) {
                    // New User
                    emit(NewUserRegisterState());
                  } else {
                    // Exist User
                    add(LoginUserEvent(
                        emailOrMobile: event.mobileOrEmail,
                        otp: event.otp,
                        password: event.password,
                        isOtpLogin: event.isOtpVerify,
                        isLoginByEmail: event.isLoginByEmail,
                        context: event.context));
                  }
                } else {
                  emit(ForgotPasswordOTPVerifyState());
                }
              },
            );
          }
        }
      } else {
        if (event.isLoginByEmail) {
          final data = await serviceLocator<AuthUsecase>().verifyEmailOtp(
            emailAddress: event.mobileOrEmail,
            otp: event.otp,
          );
          data.fold(
            (error) {
              showToast(message: '${error.message}');
              isLoading = false;
              emit(ConfirmOrOTPVerifyFailureState());
            },
            (success) {
              showToast(
                  message: AppLocalizations.of(event.context)!.verifySuccess);
              emit(ConfirmOrOTPVerifySuccessState());
              isLoading = false;
              if (!event.isForgotPasswordVerify) {
                if (!event.isUserExist) {
                  // New User
                  emit(NewUserRegisterState());
                } else {
                  // Exist User
                  add(LoginUserEvent(
                      emailOrMobile: event.mobileOrEmail,
                      otp: event.otp,
                      password: event.password,
                      isOtpLogin: event.isOtpVerify,
                      isLoginByEmail: event.isLoginByEmail,
                      context: event.context));
                }
              } else {
                emit(ForgotPasswordOTPVerifyState());
              }
            },
          );
        } else {
          // DEMO LOGIN
          if (event.isUserExist &&
              event.otp == '123456' &&
              !event.isForgotPasswordVerify) {
            add(LoginUserEvent(
                emailOrMobile: event.mobileOrEmail,
                otp: event.otp,
                password: event.password,
                isOtpLogin: event.isOtpVerify,
                isLoginByEmail: event.isLoginByEmail,
                context: event.context));
            // emit(ConfirmMobileOrEmailState());
          } else if (!event.isUserExist &&
              event.otp == '123456' &&
              !event.isForgotPasswordVerify) {
            emit(NewUserRegisterState());
          } else if (event.isUserExist &&
              event.otp == '123456' &&
              event.isForgotPasswordVerify) {
            emit(ForgotPasswordOTPVerifyState());
          } else {
            isLoading = false;
            otpController.clear();
            showToast(
                message: AppLocalizations.of(event.context)!.enterValidOtp);
            emit(SignInWithOTPFailureState());
          }
        }
      }
    } else {
      showToast(message: AppLocalizations.of(event.context)!.enterOtp);
      isLoading = false;
      emit(SignInWithOTPFailureState());
    }
  }

  Future<void> _otpOnChange(
      OTPOnChangeEvent event, Emitter<AuthState> emit) async {
    emit(OTPOnChangeState());
  }

  FutureOr<void> _verifyUserDetails(
      VerifyUserEvent event, Emitter<AuthState> emit) async {
    emit(VerifyLoadingState());
    isLoading = true;
    final data = await serviceLocator<AuthUsecase>().verifyUser(
        emailOrMobileNumber: emailOrMobileController.text,
        isLoginByEmail: isLoginByEmail);
    data.fold(
      (error) {
        isLoading = false;
        emit(VerifyFailureState());
      },
      (success) {
        userExist = success.success;
        emit(VerifySuccessState());
        isLoading = false;
      },
    );
  }

  Future<void> _timerEvent(
      VerifyTimerEvent event, Emitter<AuthState> emit) async {
    timerDuration = event.duration;
    emit(VerifyTimerState(duration: event.duration));
  }

  // Register

  Future<void> _getProfileImage(
      ImageUpdateEvent event, Emitter<AuthState> emit) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: event.source);

    if (image != null) {
      profileImage = image.path.toString();
    }
    emit(ImageUpdateState());
  }

  FutureOr _registerUser(
      RegisterUserEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    isLoading = true;
    final data = await serviceLocator<AuthUsecase>().userRegister(
      userName: event.userName,
      mobileNumber: event.mobileNumber,
      emailAddress: event.emailAddress,
      password: event.password,
      countryCode: event.countryCode,
      gender: event.gender,
      profileImage: event.profileImage,
    );
    data.fold(
      (error) {
        showToast(message: '${error.message}');
        isLoading = false;
        emit(LoginFailureState());
      },
      (success) async {
        showToast(message: 'Registered Successfully');
        isLoading = false;
        emit(LoginSuccessState());
        await AppSharedPreference.setToken(
            'Bearer ${success.accessToken}');
        await AppSharedPreference.setLoginStatus(true);
      },
    );
  }

  Future<void> _registerInit(
      RegisterPageInitEvent event, Emitter<AuthState> emit) async {
    emit(AuthDataLoadingState());
    if (event.arg.isLoginByEmail) {
      rEmailController.text = event.arg.emailOrMobile;
    } else {
      rMobileController.text = event.arg.emailOrMobile;
    }
    isLoginByEmail = event.arg.isLoginByEmail;
    countries = event.arg.countryList;
    flagImage = event.arg.countryFlag;
    dialCode = event.arg.contryCode;
    emit(AuthDataSuccessState());
  }

  FutureOr _getReferralCode(
      ReferralEvent event, Emitter<AuthState> emit) async {
    isLoading = true;
    if (event.referralCode == 'Skip') {
      isLoading = false;
      emit(ReferralSuccessState());
    } else {
      if (event.referralCode.isNotEmpty) {
        final data = await serviceLocator<AuthUsecase>()
            .referralCode(referralCode: event.referralCode);
        data.fold(
          (error) {
            showToast(message: '${error.message}');
            isLoading = false;
            emit(ReferralFailureState());
          },
          (success) async {
            showToast(message: AppLocalizations.of(event.context)!.welcome);
            isLoading = false;
            emit(ReferralSuccessState());
          },
        );
      } else {
        showToast(
            message: AppLocalizations.of(event.context)!.enterRefferalCode);
      }
    }
  }

  // Login

  FutureOr _loginUser(LoginUserEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    isLoading = true;
    final data = await serviceLocator<AuthUsecase>().userLogin(
      emailOrMobile: event.emailOrMobile,
      otp: event.otp,
      password: event.password,
      isOtpLogin: event.isOtpLogin,
      isLoginByEmail: event.isLoginByEmail,
    );
    data.fold(
      (error) {
        if (!event.isOtpLogin) {
          showToast(message: AppLocalizations.of(event.context)!.validPassword);
        } else {
          showToast(message: AppLocalizations.of(event.context)!.enterValidOtp);
        }
        isLoading = false;
        emit(LoginFailureState());
      },
      (success) async {
        isLoading = false;
        emit(LoginSuccessState());
        showToast(message: AppLocalizations.of(event.context)!.loginSuccess);
        debugPrint('${success.tokenType} ${success.accessToken}');
        await AppSharedPreference.setToken(
            'Bearer ${success.accessToken}');
        await AppSharedPreference.setLoginStatus(true);
      },
    );
  }

  // Update Password
  FutureOr _updatePassword(
      UpdatePasswordEvent event, Emitter<AuthState> emit) async {
    isLoading = true;
    final data = await serviceLocator<AuthUsecase>().updatePassword(
        emailOrMobile: event.emailOrMobile,
        password: event.password,
        isLoginByEmail: event.isLoginByEmail);
    data.fold(
      (error) {
        showToast(message: '${error.message}');
        isLoading = false;
        emit(ForgotPasswordUpdateFailureState());
      },
      (success) async {
        showToast(message: AppLocalizations.of(event.context)!.passCheck);
        isLoading = false;
        emit(ForgotPasswordUpdateSuccessState());
      },
    );
  }
}
