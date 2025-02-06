import 'dart:convert';

CommonModuleModel commonModuleResponseModelFromJson(String str) =>
    CommonModuleModel.fromJson(json.decode(str));

class CommonModuleModel {
  bool success;
  String message;
  String enableOwnerLogin;
  String enableEmailOtp;
  bool firebaseOtpEnabled;
  int enableRefferal;

  CommonModuleModel({
    required this.success,
    required this.message,
    required this.enableOwnerLogin,
    required this.enableEmailOtp,
    required this.firebaseOtpEnabled,
    required this.enableRefferal,
  });

  factory CommonModuleModel.fromJson(Map<String, dynamic> json) =>
      CommonModuleModel(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
        enableOwnerLogin: json["enable_owner_login"] ?? '0',
        enableEmailOtp: json["enable_email_otp"] ?? '0',
        firebaseOtpEnabled: json["firebase_otp_enabled"] ?? false,
        enableRefferal: json["enable_user_referral_earnings"] != null
            ? int.parse(json["enable_user_referral_earnings"].toString())
            : 0,
      );
}
