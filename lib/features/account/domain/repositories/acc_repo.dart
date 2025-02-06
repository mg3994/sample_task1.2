import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../models/admin_chat_history_model.dart';
import '../models/admin_chat_model.dart';
import '../models/card_list_model.dart';
import '../models/delete_account_model.dart';
import '../models/faq_model.dart';
import '../models/history_model.dart';
import '../models/logout_model.dart';
import '../models/makecomplaint_model.dart';
import '../models/notifications_model.dart';
import '../models/payment_method_model.dart';
import '../models/walletpage_model.dart';

abstract class AccRepository {
  Future<Either<Failure, NotificationResponseModel>>
      getUserNotificationsDetails({String? pageNo});

  Future<Either<Failure, DeleteAccountResponseModel>> deleteAccount();

  Future<Either<Failure, ComplaintResponseModel>> makeComplaintList(
      {String? complaintType});

  Future<Either<Failure, dynamic>> deleteNotification(String id);

  Future<Either<Failure, dynamic>> makeComplaintButton(
      String complaintTitleId, String complaintText, String requestId);

  Future<Either<Failure, HistoryResponseModel>> getUserHistoryDetails(
      String historyFilter,
      {String? pageNo});

  Future<Either<Failure, LogoutResponseModel>> logout();

  Future<Either<Failure, FaqResponseModel>> getFaqDetails();

  Future<Either<Failure, WalletResponseModel>> getWalletHistoryDetails(
      int page);

  Future<Either<Failure, dynamic>> moneyTransfer({
    required String transferMobile,
    required String role,
    required String transferAmount,
  });

  Future<Either<Failure, dynamic>> addSos({
    required String name,
    required String number,
  });

  Future<Either<Failure, dynamic>> deleteSos(String id);

  Future<Either<Failure, dynamic>> deleteFav(String id);

  Future<Either<Failure, dynamic>> addFavAddress({
    required String address,
    required String name,
    required String lat,
    required String lng,
  });

  Future<Either<Failure, dynamic>> updateDetailsButton(
      {required String email,
      required String name,
      required String gender,
      required String profileImage,
      bool? updateFcmToken});

  Future<Either<Failure, AdminChatModel>> sendAdminMessage({
    required String newChat,
    required String message,
    required String chatId,
  });

  Future<Either<Failure, AdminChatHistoryModel>> getAdminChatHistoryDetails();

  Future<Either<Failure, dynamic>> adminMessageSeenDetails(String chatId);

  Future<Either<Failure, PaymentAuthModel>> stripeSetupIntent();

  Future<Either<Failure, dynamic>> stripeSaveCardDetails({
    required String paymentMethodId,
    required String last4Number,
    required String cardType,
    required String validThrough,
  });

  Future<Either<Failure, CardListModel>> cardList();

  Future<Either<Failure, dynamic>> makeDefaultCard({required String cardId});

  Future<Either<Failure, dynamic>> deleteCard({required String cardId});
}
