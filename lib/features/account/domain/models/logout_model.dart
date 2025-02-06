import 'dart:convert';

LogoutResponseModel logoutResponseModelFromJson(String str) =>
    LogoutResponseModel.fromJson(json.decode(str));

class LogoutResponseModel {
  bool success;
  String message;

  LogoutResponseModel({
    required this.success,
    required this.message,
  });

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) =>
      LogoutResponseModel(
        success: json["success"],
        message: json["message"],
      );
}
