import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../domain/models/admin_chat_history_model.dart';
import '../../domain/models/admin_chat_model.dart';
import '../../domain/models/card_list_model.dart';
import '../../domain/models/delete_account_model.dart';
import '../../domain/models/faq_model.dart';
import '../../domain/models/history_model.dart';
import '../../domain/models/logout_model.dart';
import '../../domain/models/makecomplaint_model.dart';
import '../../domain/models/notifications_model.dart';
import '../../domain/models/payment_method_model.dart';
import '../../domain/models/walletpage_model.dart';
import '../../domain/repositories/acc_repo.dart';

class AccUsecase {
  final AccRepository _accRepository;

  const AccUsecase(this._accRepository);

  // Notifications
  Future<Either<Failure, NotificationResponseModel>> notificationDetails(
      {String? pageNo}) async {
    return _accRepository.getUserNotificationsDetails(pageNo: pageNo);
  }

  //make complaints
  Future<Either<Failure, ComplaintResponseModel>> makeComplaint(
      {String? complaintType}) async {
    return _accRepository.makeComplaintList(complaintType: complaintType);
  }

  //Delete Notification
  Future<Either<Failure, dynamic>> deleteNotification(String id) async {
    return _accRepository.deleteNotification(id);
  }

  //make complaints button
  Future<Either<Failure, dynamic>> makeComplaintButton(
      String complaintTitleId, String complaintText, String requestId) async {
    return _accRepository.makeComplaintButton(
        complaintTitleId, complaintText, requestId);
  }

  // History
  Future<Either<Failure, HistoryResponseModel>> historyDetails(
      String historyFilter,
      {String? pageNo}) async {
    return _accRepository.getUserHistoryDetails(historyFilter, pageNo: pageNo);
  }

  // logout
  Future<Either<Failure, LogoutResponseModel>> logout() async {
    return _accRepository.logout();
  }

  // Delete account
  Future<Either<Failure, DeleteAccountResponseModel>>
      deleteUserAccount() async {
    return _accRepository.deleteAccount();
  }

  //Faq
  Future<Either<Failure, FaqResponseModel>> getFaqDetail() async {
    return _accRepository.getFaqDetails();
  }

  Future<Either<Failure, WalletResponseModel>> getWalletDetail(int page) async {
    return _accRepository.getWalletHistoryDetails(page);
  }

  Future<Either<Failure, dynamic>> moneyTransfer(
      {required String transferMobile,
      required String role,
      required String transferAmount}) async {
    return _accRepository.moneyTransfer(
        transferMobile: transferMobile,
        role: role,
        transferAmount: transferAmount);
  }

  //update details
  Future<Either<Failure, dynamic>> updateDetailsButton(
      {required String email,
      required String name,
      required String gender,
      required String profileImage,
      bool? updateFcmToken}) async {
    return _accRepository.updateDetailsButton(
        email: email,
        name: name,
        gender: gender,
        profileImage: profileImage,
        updateFcmToken: updateFcmToken);
  }

  //Delete fav
  Future<Either<Failure, dynamic>> deleteFavouritesAddress(String id) async {
    return _accRepository.deleteFav(id);
  }

  Future<Either<Failure, dynamic>> addFavAddress({
    required String address,
    required String name,
    required String lat,
    required String lng,
  }) async {
    return _accRepository.addFavAddress(
        address: address, name: name, lat: lat, lng: lng);
  }

  Future<Either<Failure, dynamic>> deleteSosContact(String id) async {
    return _accRepository.deleteSos(id);
  }

  Future<Either<Failure, dynamic>> addSosContact({
    required String name,
    required String number,
  }) async {
    return _accRepository.addSos(
      name: name,
      number: number,
    );
  }

  Future<Either<Failure, AdminChatModel>> sendAdminMessages({
    required String newChat,
    required String message,
    required String chatId,
  }) async {
    return _accRepository.sendAdminMessage(
      newChat: newChat,
      message: message,
      chatId: chatId,
    );
  }

  Future<Either<Failure, AdminChatHistoryModel>>
      getAdminChatHistoryDetail() async {
    return _accRepository.getAdminChatHistoryDetails();
  }

  Future<Either<Failure, dynamic>> adminMessageSeenDetail(String chatId) async {
    return _accRepository.adminMessageSeenDetails(chatId);
  }

  Future<Either<Failure, PaymentAuthModel>> stripeSetupIntent() async {
    return _accRepository.stripeSetupIntent();
  }

  Future<Either<Failure, dynamic>> stripSaveCardDetails({
    required String paymentMethodId,
    required String last4Number,
    required String cardType,
    required String validThrough,
  }) async {
    return _accRepository.stripeSaveCardDetails(
        paymentMethodId: paymentMethodId,
        last4Number: last4Number,
        cardType: cardType,
        validThrough: validThrough);
  }

  Future<Either<Failure, CardListModel>> cardList() async {
    return _accRepository.cardList();
  }

  Future<Either<Failure, dynamic>> makeDefaultCard(
      {required String cardId}) async {
    return _accRepository.makeDefaultCard(cardId: cardId);
  }

  Future<Either<Failure, dynamic>> deleteCard({required String cardId}) async {
    return _accRepository.deleteCard(cardId: cardId);
  }
}
