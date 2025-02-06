part of 'acc_bloc.dart';

abstract class AccEvent {}

class AccGetUserDetailsEvent extends AccEvent {}

class AccGetDirectionEvent extends AccEvent {}

class OnTapChangeEvent extends AccEvent {}

class IsEditPage extends AccEvent {}

class ContainerClickedEvent extends AccEvent {}

class NavigateToEditPageEvent extends AccEvent {}

class GetUserProfileDetailsEvent extends AccEvent {}

class UpdateControllerWithDetailsEvent extends AccEvent {
  final UpdateDetailsArguments args;

  UpdateControllerWithDetailsEvent({required this.args});
}

class UpdateDetailsEvent extends AccEvent {
  final String? name;
  final String? mail;

  UpdateDetailsEvent({
    required this.name,
    required this.mail,
  });
}

class UpdateTextFieldEvent extends AccEvent {
  final String text;
  final UpdateDetailsArguments arg;

  UpdateTextFieldEvent({required this.text, required this.arg});
}

class UpdateUserNameEvent extends AccEvent {
  final String name;

  UpdateUserNameEvent({required this.name});
}

class UpdateUserEmailEvent extends AccEvent {
  final String email;

  UpdateUserEmailEvent({required this.email});
}

class UpdateUserGenderEvent extends AccEvent {
  final String gender;

  UpdateUserGenderEvent({required this.gender});
}

class UserDetailsPageInitEvent extends AccEvent {
  final AccountPageArguments arg;

  UserDetailsPageInitEvent({required this.arg});
}

class NotificationGetEvent extends AccEvent {
  final int? pageNumber;

  NotificationGetEvent({this.pageNumber});
}

class ComplaintEvent extends AccEvent {
  final String? complaintType;

  ComplaintEvent({this.complaintType});
}

class NotificationLoading extends AccEvent {}

class DeleteNotificationEvent extends AccEvent {
  final String id;

  DeleteNotificationEvent({required this.id});
}

class ClearAllNotificationsEvent extends AccEvent {}

class HistoryGetEvent extends AccEvent {
  final String historyFilter;
  final int? pageNumber;

  HistoryGetEvent({required this.historyFilter, this.pageNumber});
}

class OutstationGetEvent extends AccEvent {
  final String id;

  OutstationGetEvent({required this.id});
}

class OutstationAcceptOrDeclineEvent extends AccEvent {
  final bool isAccept;
  final dynamic driver;
  final String id;
  final String offeredRideFare;

  OutstationAcceptOrDeclineEvent({required this.isAccept, required this.driver, required this.id, required this.offeredRideFare});

}

class LogoutEvent extends AccEvent {}

class GetFaqListEvent extends AccEvent {}

class FaqOnTapEvent extends AccEvent {
  final int selectedFaqIndex;

  FaqOnTapEvent({required this.selectedFaqIndex});
}

class UpdateUserDetailsEvent extends AccEvent {
  final String name;
  final String email;
  final String gender;
  final String profileImage;

  UpdateUserDetailsEvent(
      {required this.name,
      required this.email,
      required this.gender,
      required this.profileImage});
}

class GenderSelectedEvent extends AccEvent {
  final String selectedGender;

  GenderSelectedEvent({required this.selectedGender});
}

class ChooseMapOnTapEvent extends AccEvent {
  final int chooseMapIndex;

  ChooseMapOnTapEvent({required this.chooseMapIndex});
}

class ComplaintButtonEvent extends AccEvent {
  final String complaintTitleId;
  final String complaintText;
  final String requestId;
  final BuildContext context;

  ComplaintButtonEvent(
      {required this.complaintTitleId,
      required this.complaintText,
      required this.requestId,
      required this.context});
}

class DeleteAccountEvent extends AccEvent {}

class HistoryTypeChangeEvent extends AccEvent {
  final int historyTypeIndex;

  HistoryTypeChangeEvent({required this.historyTypeIndex});
}

class GetWalletHistoryListEvent extends AccEvent {
  final int pageIndex;
  GetWalletHistoryListEvent({required this.pageIndex});
}

class TransferMoneySelectedEvent extends AccEvent {
  final String selectedTransferAmountMenuItem;

  TransferMoneySelectedEvent({required this.selectedTransferAmountMenuItem});
}

class MoneyTransferedEvent extends AccEvent {
  final String transferMobile;
  final String role;
  final String transferAmount;

  MoneyTransferedEvent(
      {required this.transferMobile,
      required this.role,
      required this.transferAmount});
}

class DeleteContactEvent extends AccEvent {
  final String? id;

  DeleteContactEvent({required this.id});
}

class SelectContactDetailsEvent extends AccEvent {}

class AddContactEvent extends AccEvent {
  final String name;
  final String number;

  AddContactEvent({required this.name, required this.number});
}

class AccUpdateEvent extends AccEvent {}

class DeleteFavAddressEvent extends AccEvent {
  final String? id;
  final bool isHome;
  final bool isWork;
  final bool isOthers;

  DeleteFavAddressEvent(
      {required this.id,
      required this.isHome,
      required this.isWork,
      required this.isOthers});
}

class GetFavListEvent extends AccEvent {
  final UserDetail userData;
  final List<FavoriteLocationData> favAddressList;

  GetFavListEvent({required this.userData, required this.favAddressList});
}

class FavPageInitEvent extends AccEvent {}

class SelectFromFavAddressEvent extends AccEvent {
  final String addressType;

  SelectFromFavAddressEvent({required this.addressType});
}

class AddFavAddressEvent extends AccEvent {
  final String address;
  final String name;
  final String lat;
  final String lng;
  final bool isOther;

  AddFavAddressEvent(
      {required this.address,
      required this.name,
      required this.lat,
      required this.lng,
      required this.isOther});
}

class UserDetailEditEvent extends AccEvent {
  final String header;
  final String text;

  UserDetailEditEvent({required this.header, required this.text});
}

class SendAdminMessageEvent extends AccEvent {
  final String newChat;
  final String message;
  final String chatId;

  SendAdminMessageEvent(
      {required this.newChat, required this.message, required this.chatId});
}

class GetAdminChatHistoryListEvent extends AccEvent {}

class AdminChatInitEvent extends AccEvent {
  final AdminChatPageArguments arg;

  AdminChatInitEvent({required this.arg});
}

class PickImageFromGalleryEvent extends AccEvent {}

class PickImageFromCameraEvent extends AccEvent {}

class AdminMessageSeenEvent extends AccEvent {
  final String? chatId;

  AdminMessageSeenEvent({required this.chatId});
}

class UpdateImageEvent extends AccEvent {
  final String name;
  final String email;
  final String gender;
  final ImageSource source;

  UpdateImageEvent({
    required this.name,
    required this.email,
    required this.gender,
    required this.source,
  });
}

class LanguageGetEvent extends AccEvent {}

class FavLocateMeEvent extends AccEvent {}

class AccUpdateLocationEvent extends AccEvent {
  final LatLng latLng;
  final bool isFromHomePage;

  AccUpdateLocationEvent({required this.latLng, required this.isFromHomePage});
}

class PaymentOnTapEvent extends AccEvent {
  final int selectedPaymentIndex;

  PaymentOnTapEvent({required this.selectedPaymentIndex});
}

class RideLaterCancelRequestEvent extends AccEvent {
  final String requestId;
  final String? reason;

  RideLaterCancelRequestEvent({
    required this.requestId,
    this.reason,
  });
}

class FavNewAddressInitEvent extends AccEvent {
  final ConfirmFavouriteLocationPageArguments arg;

  FavNewAddressInitEvent({required this.arg});
}

class UserDataInitEvent extends AccEvent {
  final UserDetail? userDetails;

  UserDataInitEvent({required this.userDetails});
}

class AddMoneyWebViewUrlEvent extends AccEvent {
  dynamic from;
  dynamic url;
  dynamic userId;
  dynamic requestId;
  dynamic currencySymbol;
  dynamic money;
  BuildContext context;

  AddMoneyWebViewUrlEvent({
    this.url,
    this.from,
    this.userId,
    this.requestId,
    this.currencySymbol,
    this.money,
    required this.context,
  });
}

class WalletPageReUpdateEvent extends AccEvent {
  String from;
  String url;
  String userId;
  String requestId;
  String currencySymbol;
  String money;
  WalletPageReUpdateEvent(
      {required this.from,
      required this.url,
      required this.userId,
      required this.requestId,
      required this.currencySymbol,
      required this.money});
}

class HistoryPageInitEvent extends AccEvent {}

class AddHistoryMarkerEvent extends AccEvent {
  final List? stops;
  final String pickLat;
  final String pickLng;
  final String? dropLat;
  final String? dropLng;
  final String? polyline;
  AddHistoryMarkerEvent(
      {
      this.stops,
      required this.pickLat,
      required this.pickLng,
      this.dropLat,
      this.dropLng,
      this.polyline});
}

class WalletPageInitEvent extends AccEvent {
  final WalletPageArguments arg;

  WalletPageInitEvent({required this.arg});
}

class NotificationPageInitEvent extends AccEvent {}

class SosInitEvent extends AccEvent {
  final SOSPageArguments arg;

  SosInitEvent({required this.arg});
}

class PaymentAuthenticationEvent extends AccEvent {
  final PaymentMethodArguments arg;

  PaymentAuthenticationEvent({required this.arg});
}

class AddCardDetailsEvent extends AccEvent {
  BuildContext context;

  AddCardDetailsEvent({
    required this.context,
  });
}

class CardListEvent extends AccEvent {}

class DeleteCardEvent extends AccEvent {
  final String cardId;

  DeleteCardEvent({required this.cardId});
}

class MakeDefaultCardEvent extends AccEvent {
  final String cardId;

  MakeDefaultCardEvent({required this.cardId});
}
