
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:restart_tagxi/features/account/domain/models/card_list_model.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/failure.dart';
import '../../domain/models/admin_chat_history_model.dart';
import '../../domain/models/admin_chat_model.dart';
import '../../domain/models/delete_account_model.dart';
import '../../domain/models/faq_model.dart';
import '../../domain/models/history_model.dart';
import '../../domain/models/logout_model.dart';
import '../../domain/models/makecomplaint_model.dart';
import '../../domain/models/notifications_model.dart';
import '../../domain/models/payment_method_model.dart';
import '../../domain/models/walletpage_model.dart';
import '../../domain/repositories/acc_repo.dart';
import '../repository/acc_api.dart';

class AccRepositoryImpl implements AccRepository {
  final AccApi _accApi;

  AccRepositoryImpl(this._accApi);

  // Notification
  @override
  Future<Either<Failure, NotificationResponseModel>>
      getUserNotificationsDetails({String? pageNo}) async {
    try {
      Response response = await _accApi.getNotificationsApi(pageNo: pageNo);
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        return Left(GetDataFailure(message: response.data["message"]));
      } else {
        final notificationResponseModel =
            NotificationResponseModel.fromJson(response.data);
        return Right(notificationResponseModel);
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
  }

  // logout
  @override
  Future<Either<Failure, LogoutResponseModel>> logout() async {
    try {
      Response response = await _accApi.logoutApi();
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        return Left(GetDataFailure(message: response.data["message"]));
      } else {
        final logoutResponseModel = LogoutResponseModel.fromJson(response.data);
        return Right(logoutResponseModel);
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
  }

  // delete account
  @override
  Future<Either<Failure, DeleteAccountResponseModel>> deleteAccount() async {
    try {
      Response response = await _accApi.deleteAccountApi();
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        return Left(GetDataFailure(message: response.data["message"]));
      } else {
        final deleteAccountResponseModel =
            DeleteAccountResponseModel.fromJson(response.data);
        return Right(deleteAccountResponseModel);
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
  }

  // make complaint
  @override
  Future<Either<Failure, ComplaintResponseModel>> makeComplaintList(
      {String? complaintType}) async {
    try {
      Response response =
          await _accApi.makeComplaintsApi(complaintType: complaintType);
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        return Left(GetDataFailure(message: response.data["message"]));
      } else {
        final complaintResponseModel =
            ComplaintResponseModel.fromJson(response.data);
        return Right(complaintResponseModel);
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
  }

//history
  @override
  Future<Either<Failure, HistoryResponseModel>> getUserHistoryDetails(
      String historyFilter,
      {String? pageNo}) async {
    HistoryResponseModel historyResponseModel;
    try {
      Response response =
          await _accApi.getHistoryApi(historyFilter, pageNo: pageNo);
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        return Left(GetDataFailure(message: response.data["message"]));
      } else {
        historyResponseModel = HistoryResponseModel.fromJson(response.data);
      }
    } on FetchDataException catch (e) {
      debugPrint('getUserHistoryDetails Error: $e');
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(historyResponseModel);
  }

  //Delete notification
  @override
  Future<Either<Failure, dynamic>> deleteNotification(String id) async {
    try {
      Response response = await _accApi.deleteNotification(id);
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return Left(GetDataFailure(message: response.statusMessage ?? 'Error'));
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
  }

  //make complaint button
  @override
  Future<Either<Failure, dynamic>> makeComplaintButton(
      String complaintTitleId, String complaintText, String requestId) async {
    try {
      Response response = await _accApi.makeComplaintButton(
          complaintTitleId, complaintText, requestId);
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return Left(GetDataFailure(message: response.statusMessage ?? 'Error'));
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
  }

  //Faq
  @override
  Future<Either<Failure, FaqResponseModel>> getFaqDetails() async {
    FaqResponseModel faqDataResponseModel;
    try {
      Response response = await _accApi.getFaqLists();

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['errors']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          faqDataResponseModel = FaqResponseModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(faqDataResponseModel);
  }

  @override
  Future<Either<Failure, WalletResponseModel>> getWalletHistoryDetails(
      int page) async {
    try {
      Response response = await _accApi.getWalletHistoryLists(page);
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        return Left(GetDataFailure(message: response.data["message"]));
      } else {
        debugPrint("Wallet Success");
        final walletDataResponseModel =
            WalletResponseModel.fromJson(response.data);
        return Right(walletDataResponseModel);
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, dynamic>> moneyTransfer({
    required String transferMobile,
    required String role,
    required String transferAmount,
  }) async {
    dynamic amountTransfered;
    try {
      Response response = await _accApi.moneytransfers(
          transferMobile: transferMobile,
          role: role,
          transferAmount: transferAmount);
      debugPrint('transfer status code ${response.statusCode}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(
            GetDataFailure(message: response.data['errors']["message"]));
      } else {
        if (response.statusCode == 400 || response.statusCode == 500) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          amountTransfered = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(amountTransfered);
  }

  //update button
  @override
  Future<Either<Failure, dynamic>> updateDetailsButton(
      {required String email,
      required String name,
      required String gender,
      required String profileImage,
      bool? updateFcmToken}) async {
    dynamic updateval;
    try {
      Response response = await _accApi.updateDetailsButton(
          email: email,
          name: name,
          gender: gender,
          profileImage: profileImage,
          updateFcmToken: updateFcmToken);
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(
            GetDataFailure(message: response.data['errors']["message"]));
      } else {
        if (response.statusCode == 400 || response.statusCode == 500) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          updateval = response.data;
          debugPrint('deleteContact $updateval');
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(updateval);
  }

  @override
  Future<Either<Failure, dynamic>> deleteFav(String id) async {
    dynamic deleteFavAddress;
    try {
      Response response = await _accApi.deleteFavAddress(id);
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(
            GetDataFailure(message: response.data['errors']["message"]));
      } else {
        if (response.statusCode == 400 || response.statusCode == 500) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          deleteFavAddress = response.data;
          debugPrint('deleteContact hhh $deleteFavAddress');
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(deleteFavAddress);
  }

  @override
  Future<Either<Failure, dynamic>> addFavAddress({
    required String address,
    required String name,
    required String lat,
    required String lng,
  }) async {
    dynamic addFavourite;
    try {
      Response response = await _accApi.addFavouriteAddress(
          address: address, name: name, lat: lat, lng: lng);
      debugPrint('add fav status code ${response.statusCode}');
      debugPrint('addfav address $addFavourite');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(
            GetDataFailure(message: response.data['errors']["message"]));
      } else {
        if (response.statusCode == 400 || response.statusCode == 500) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          addFavourite = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(addFavourite);
  }

  @override
  Future<Either<Failure, dynamic>> addSos({
    required String name,
    required String number,
  }) async {
    dynamic addContact;
    try {
      Response response = await _accApi.addSosContacts(
        name: name,
        number: number,
      );
      debugPrint('add sos status code ${response.statusCode}');
      debugPrint('addContact $addContact');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(
            GetDataFailure(message: response.data['errors']["message"]));
      } else {
        if (response.statusCode == 400 || response.statusCode == 500) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          addContact = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(addContact);
  }

  @override
  Future<Either<Failure, dynamic>> deleteSos(String id) async {
    dynamic deleteContact;
    try {
      Response response = await _accApi.deleteSosContacts(id);
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(
            GetDataFailure(message: response.data['errors']["message"]));
      } else {
        if (response.statusCode == 400 || response.statusCode == 500) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          deleteContact = response.data;
          debugPrint('deleteContact hhh $deleteContact');
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(deleteContact);
  }

  @override
  Future<Either<Failure, AdminChatModel>> sendAdminMessage({
    required String newChat,
    required String message,
    required String chatId,
  }) async {
    AdminChatModel sendAdminMessage;
    try {
      Response response = await _accApi.sendAdminMessage(
        newChat: newChat,
        message: message,
        chatId: chatId,
      );
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(
            GetDataFailure(message: response.data['errors']["message"]));
      } else {
        if (response.statusCode == 400 || response.statusCode == 500) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          sendAdminMessage = AdminChatModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(sendAdminMessage);
  }

  @override
  Future<Either<Failure, AdminChatHistoryModel>>
      getAdminChatHistoryDetails() async {
    AdminChatHistoryModel adminChatHistory;
    try {
      Response response = await _accApi.getAdminChatHistoryLists();

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['errors']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          adminChatHistory = AdminChatHistoryModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(adminChatHistory);
  }

  @override
  Future<Either<Failure, dynamic>> adminMessageSeenDetails(
      String chatId) async {
    dynamic adminMessageSeen;
    try {
      Response response = await _accApi.adminMessageSeen(chatId);

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['errors']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          adminMessageSeen = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(adminMessageSeen);
  }

  @override
  Future<Either<Failure, PaymentAuthModel>> stripeSetupIntent() async {
    PaymentAuthModel paymentAuthenticationResponse;
    try {
      Response response = await _accApi.stripeSetupIntent();
      
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['errors']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          paymentAuthenticationResponse =
              PaymentAuthModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(paymentAuthenticationResponse);
  }

  @override
  Future<Either<Failure, dynamic>> stripeSaveCardDetails({
     required String paymentMethodId,
    required String last4Number,
    required String cardType,
    required String validThrough,
  }) async {
    dynamic saveCardResponse;
    try {
      Response response = await _accApi.stripeSetupIntent();

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['errors']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          saveCardResponse = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(saveCardResponse);
  }

  @override
  Future<Either<Failure, CardListModel>> cardList() async {
    CardListModel cardListResponse;
    try {
      Response response = await _accApi.cardList();

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['errors']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          cardListResponse = CardListModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(cardListResponse);
  }

  @override
  Future<Either<Failure, dynamic>> makeDefaultCard({required String cardId}) async {
    dynamic makeDefaultResponse;
    try {
      Response response = await _accApi.makeDefaultCard(cardId: cardId);

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['errors']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          makeDefaultResponse = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(makeDefaultResponse);
  }

  @override
  Future<Either<Failure, dynamic>> deleteCard(
      {required String cardId}) async {
    dynamic deleteCardResponse;
    try {
      Response response = await _accApi.deleteCard(cardId: cardId);

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['errors']));
      } else {
        if (response.statusCode == 400 || response.statusCode == 500) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          deleteCardResponse = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(deleteCardResponse);
  }
}
