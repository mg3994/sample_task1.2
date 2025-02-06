import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../common/local_data.dart';
import '../../../../core/network/dio_provider_impl.dart';
import '../../../../core/network/endpoints.dart';

class AccApi {
  //get history
  Future getHistoryApi(String historyFilter, {String? pageNo}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        (pageNo != null && pageNo != '' && pageNo.isNotEmpty)
            ? '${ApiEndpoints.history}?$historyFilter&page=$pageNo'
            : '${ApiEndpoints.history}?$historyFilter',
        headers: {'Authorization': token},
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //logout
  Future logoutApi() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.logout,
        headers: {'Authorization': token},
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //delete account
  Future deleteAccountApi() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.deleteAccount,
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

//delete notification
  Future deleteNotification(String id) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        '${ApiEndpoints.deleteNotification}/$id',
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //make complaint confirm button
  Future makeComplaintButton(
      String complaintTitleId, String complaintText, String requestId) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.makeComplaintButton,
        headers: {'Authorization': token},
        body: (requestId.isEmpty)
            ? jsonEncode({
                'complaint_title_id': complaintTitleId,
                'description': complaintText,
              })
            : jsonEncode({
                'complaint_title_id': complaintTitleId,
                'description': complaintText,
                'request_id': requestId,
              }),
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //get notifications
  Future getNotificationsApi({String? pageNo}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        (pageNo != null)
            ? '${ApiEndpoints.notification}?page=$pageNo'
            : ApiEndpoints.notification,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //Make Complaints
  Future makeComplaintsApi({String? complaintType}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        (complaintType == 'general')
            ? '${ApiEndpoints.makeComplaint}?complaint_type=general'
            : '${ApiEndpoints.makeComplaint}?complaint_type=request',
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //Faq
  Future getFaqLists() async {
    try {
      final token = await AppSharedPreference.getToken();
      Position? position = await Geolocator.getLastKnownPosition();
      double lat = (position != null) ? position.latitude : 0;
      double long = (position != null) ? position.longitude : 0;
      Response response = await DioProviderImpl().get(
        '${ApiEndpoints.faqData}/$lat/$long',
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future getWalletHistoryLists(int page) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        "${ApiEndpoints.walletHistory}?page=$page",
        headers: {'Authorization': token},
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future moneytransfers({
    required String transferMobile,
    required String role,
    required String transferAmount,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.transferMoney,
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: FormData.fromMap({
            'mobile': transferMobile,
            'role': role,
            'amount': transferAmount
          }));
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future updateDetailsButton(
      {required String email,
      required String name,
      required String gender,
      required String profileImage,
      bool? updateFcmToken}) async {
    try {
      dynamic fcmToken;
      final token = await AppSharedPreference.getToken();
      if (updateFcmToken != null && updateFcmToken) {
        fcmToken = await FirebaseMessaging.instance.getToken();
      }
      final formData = FormData.fromMap({
        "name": name,
        "email": email,
        'gender': (gender == 'Male' || gender == 'male')
            ? 'male'
            : (gender == 'Female' || gender == 'female')
                ? 'female'
                : 'others',
        if (updateFcmToken != null && updateFcmToken) 'fcm_token': fcmToken
      });
      if (profileImage.isNotEmpty) {
        formData.files.add(MapEntry(
            'profile_picture', await MultipartFile.fromFile(profileImage)));
      }
      Response response = await DioProviderImpl().post(
        ApiEndpoints.updateUserDetailsButton,
        body: formData,
        headers: {'Authorization': token},
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addSosContacts({
    required String name,
    required String number,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.addSosContact,
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: FormData.fromMap({
            'name': name,
            'number': number,
          }));
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //sos delete
  Future deleteSosContacts(String id) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        '${ApiEndpoints.deleteSosContact}/$id',
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //Fav delete
  Future deleteFavAddress(String id) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        '${ApiEndpoints.removeFavAddress}/$id',
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future addFavouriteAddress({
    required String address,
    required String name,
    required String lat,
    required String lng,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.addFavLocation,
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: FormData.fromMap({
            'pick_lat': lat,
            'pick_lng': lng,
            'pick_address': address,
            'address_name': name
          }));
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }    
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future sendAdminMessage({
    required String newChat,
    required String message,
    required String chatId,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.sendAdminMessage,
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: (chatId.isEmpty)
              ? FormData.fromMap({'new_conversation': 1, 'content': message})
              : FormData.fromMap({
                  'new_conversation': 0,
                  'content': message,
                  'conversation_id': chatId
                }));
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }          
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future getAdminChatHistoryLists() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.adminChatHistory,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future adminMessageSeen(String chatId) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        '${ApiEndpoints.adminMessageSeen}?conversation_id=$chatId',
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // stripeIntent
  Future stripeSetupIntent() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.stripCreate,
        headers: {'Authorization': token},
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // stripSaveCard
  Future stripeSaveCardDetails({
    required String paymentMethodId,
    required String last4Number,
    required String cardType,
    required String validThrough,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response =
          await DioProviderImpl().post(ApiEndpoints.stripSavedCardsDetail,
              headers: {'Authorization': token},
              body: FormData.fromMap({
                'payment_method_id': paymentMethodId,
                'last_number': last4Number,
                'card_type': cardType,
                'valid_through': validThrough
              }));
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }        
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // cardList
  Future cardList() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.savedCardList,
        headers: {'Authorization': token},
      );
      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // makeDefault card
  Future makeDefaultCard({required String cardId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.makeDefaultCard,
          headers: {'Authorization': token},
          body: FormData.fromMap({"card_id": cardId}));
      debugPrint(response.toString());
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // delete card
  Future deleteCard({required String cardId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.deleteCardsDetail + cardId,
        headers: {'Authorization': token},
      );
      debugPrint(response.toString());
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
