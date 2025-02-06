part of 'acc_bloc.dart';

abstract class AccState {}

class AccInitialState extends AccState {}

class AccDataLoadingStopState extends AccState {}

class AccDataLoadingStartState extends AccState {}

class UserProfileDetailsLoadingState extends AccState {}

class SaveCardSuccessState extends AccState {}

class IsEditPageState extends AccState {
  final bool isEditPage;

  IsEditPageState({required this.isEditPage});
}

class GenderSelectedState extends AccState {
  final String selectedGender;

  GenderSelectedState({required this.selectedGender});
}

class UserDetailsUpdatedState extends AccState {
  final String name;
  final String email;
  final String gender;
  final String profileImage;

  UserDetailsUpdatedState(
      {required this.name,
      required this.email,
      required this.gender,
      required this.profileImage});
}

class UserDetailsSuccessState extends AccState {
  final UserDetail? userData;

  UserDetailsSuccessState({this.userData});
}

class NotificationFailure extends AccState {
  final String errorMessage;

  NotificationFailure({required this.errorMessage});
}

class PermissionDeniedState extends AccState {
  final String message;

  PermissionDeniedState({required this.message});
}

class UpdateDetailsFailureState extends AccState {
  final String errorMessage;

  UpdateDetailsFailureState({required this.errorMessage});
}

class HistoryFailure extends AccState {
  final String errorMessage;

  HistoryFailure({required this.errorMessage});
}

class LogoutFailure extends AccState {
  final String errorMessage;

  LogoutFailure({required this.errorMessage});
}

class MakeComplaintFailure extends AccState {
  final String errorMessage;

  MakeComplaintFailure({required this.errorMessage});
}

class ComplaintButtonFailureState extends AccState {
  final String errorMessage;

  ComplaintButtonFailureState({required this.errorMessage});
}

class UpdateUserDetailsButtonFailureState extends AccState {
  final String errorMessage;

  UpdateUserDetailsButtonFailureState({required this.errorMessage});
}

class NotificationSuccess extends AccState {
  final List<NotificationData>? notificationDatas;

  NotificationSuccess({required this.notificationDatas});
}

class HistorySuccess extends AccState {
  final List<HistoryData>? history;

  HistorySuccess({required this.history});
}

class UpdatedUserDetailsState extends AccState {
  final UserDetail updatedUserData;

  UpdatedUserDetailsState({required this.updatedUserData});
}

class LogoutSuccess extends AccState {}

class ImageUpdateState extends AccState {
  final String profileImage;

  ImageUpdateState({required this.profileImage});
}

class MakeComplaintButtonSuccess extends AccState {}

class MakeComplaintLoading extends AccState {}

class ImageUpdateFailureState extends AccState {}

class DeleteAccountSuccess extends AccState {}

class UpdateUserDetailsSuccessState extends AccState {}

class UpdateUserDetailsFailureState extends AccState {}

class MakeComplaintSuccess extends AccState {
  final List<ComplaintList>? complaintList;

  MakeComplaintSuccess({required this.complaintList});
}

class NotificationClearedSuccess extends AccState {}

class NotificationDeletedSuccess extends AccState {}

class LogoutLoadingState extends AccState {}

class ComplaintButtonLoadingState extends AccState {}

class UpdateUserDetailsLoadingState extends AccState {}

class DeleteAccountLoadingState extends AccState {}

class LogoutFailureState extends AccState {
  final String errorMessage;

  LogoutFailureState({required this.errorMessage});
}

final class ChooseMapSelectState extends AccState {
  final int selectedMapIndex;

  ChooseMapSelectState(this.selectedMapIndex);
}

class MakeComplaintFailureState extends AccState {
  final String errorMessage;

  MakeComplaintFailureState({required this.errorMessage});
}

class DeleteAccountFailureState extends AccState {
  final String errorMessage;

  DeleteAccountFailureState({required this.errorMessage});
}

final class FaqSuccessState extends AccState {}

final class FaqFailureState extends AccState {}

final class FaqLoadingState extends AccState {}

final class FaqSelectState extends AccState {
  final int selectedIndex;

  FaqSelectState(this.selectedIndex);

  List<Object> get props => [selectedIndex];
}

final class UserProfileDetailsFailureState extends AccState {}

// final class WalletHistorySuccessState extends AccState {}
class WalletHistorySuccessState extends AccState {
  final List<WalletHistoryData>? walletHistoryDatas;

  WalletHistorySuccessState({required this.walletHistoryDatas});
}

final class WalletHistoryFailureState extends AccState {}

final class WalletHistoryLoadingState extends AccState {}

class TransferMoneySelectedState extends AccState {
  final String selectedTransferAmountMenuItem;

  TransferMoneySelectedState({required this.selectedTransferAmountMenuItem});
}

final class MoneyTransferedSuccessState extends AccState {}

final class MoneyTransferedFailureState extends AccState {}

final class MoneyTransferedLoadingState extends AccState {}

class SosDeletedSuccessState extends AccState {}

class SosFailureState extends AccState {}

final class GetContactPermissionState extends AccState {}

final class SelectContactDetailsState extends AccState {}

final class AddContactSuccessState extends AccState {}

final class AddContactFailureState extends AccState {}

final class AddContactLoadingState extends AccState {}

final class UpdateState extends AccState {}

class FavDeletedSuccessState extends AccState {}

class FavFailureState extends AccState {}

final class SelectFromFavAddressState extends AccState {
  final String addressType;

  SelectFromFavAddressState({required this.addressType});
}

final class AddFavAddressSuccessState extends AccState {}

final class AddFavAddressFailureState extends AccState {}

final class AddFavAddressLoadingState extends AccState {}

final class UserDetailEditState extends AccState {
  final String header;
  final String text;

  UserDetailEditState({required this.header, required this.text});
}

final class SendAdminMessageSuccessState extends AccState {}

final class SendAdminMessageFailureState extends AccState {}

final class SendAdminMessageLoadingState extends AccState {}

final class AdminChatHistorySuccessState extends AccState {}

final class AdminChatHistoryFailureState extends AccState {}

final class AdminChatHistoryLoadingState extends AccState {}

class ImagePickedState extends AccState {
  final String imagePath;

  ImagePickedState({required this.imagePath});
}

final class AdminMessageSeenSuccessState extends AccState {}

final class AdminMessageSeenFailureState extends AccState {}

final class LanguageInitialState extends AccState {}

final class LanguageLoadingState extends AccState {}

final class LanguageFailureState extends AccState {}

final class LanguageSuccessState extends AccState {}

final class LanguageUpdateState extends AccState {}

final class FavLocateMeState extends AccState {}

final class PaymentSelectState extends AccState {
  final int selectedIndex;

  PaymentSelectState(this.selectedIndex);
}

final class RequestCancelState extends AccState {}

class HistoryDataSuccessState extends AccState {}

class HistoryDataLoadingState extends AccState {
  get data => null;
}

final class AddMoneyWebViewUrlState extends AccState {
  dynamic from;
  dynamic url;
  dynamic userId;
  dynamic requestId;
  dynamic currencySymbol;
  dynamic money;

  AddMoneyWebViewUrlState(
      {this.url,
      this.from,
      this.userId,
      this.requestId,
      this.currencySymbol,
      this.money});
}

class WalletPageReUpdateState extends AccState {
  String url;
  String userId;
  String requestId;
  String currencySymbol;
  String money;
  WalletPageReUpdateState(
      {required this.url,
      required this.userId,
      required this.requestId,
      required this.currencySymbol,
      required this.money});
}

class PaymentSuccessState extends AccState {}

class GetUrlSuccessState extends AccState {}

class PaymentFailureState extends AccState {}

class SosLoadingState extends AccState {}

class SosLoadedState extends AccState {}

class FavoriteLoadingState extends AccState {}

class FavoriteLoadedState extends AccState {}

class ContainerClickState extends AccState {
  final bool isContainerClicked;

  ContainerClickState({required this.isContainerClicked});
}

class WalletAmountSelectedState extends AccState {
  final int selectedAmount;

  WalletAmountSelectedState({required this.selectedAmount});
}

class OutstationAcceptState extends AccState {}