// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restart_tagxi/common/tobitmap.dart';
import 'package:restart_tagxi/core/utils/custom_snack_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../common/common.dart';
import '../../../core/utils/functions.dart';
import '../../../di/locator.dart';
import '../../bookingpage/application/usecases/booking_usecase.dart';
import '../../bookingpage/domain/models/point_latlng.dart';
import '../../home/domain/models/contact_model.dart';
import '../../home/application/usecase/home_usecases.dart';
import '../../home/domain/models/stop_address_model.dart';
import '../../home/domain/models/user_details_model.dart';
import '../domain/models/admin_chat_history_model.dart';
import '../domain/models/admin_chat_model.dart';
import '../domain/models/card_list_model.dart';
import '../domain/models/faq_model.dart';
import '../domain/models/history_model.dart';
import '../domain/models/makecomplaint_model.dart';
import '../domain/models/notifications_model.dart';
import '../domain/models/payment_method_model.dart';
import '../domain/models/walletpage_model.dart';
import 'usecase/acc_usecases.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart' as fmlt;

part 'acc_event.dart';

part 'acc_state.dart';

class AccBloc extends Bloc<AccEvent, AccState> {
  final formKey = GlobalKey<FormState>();
  final paymentKey = GlobalKey();
  String textDirection = 'ltr';
  bool _isEdit = false;
  ImagePicker picker = ImagePicker();

  List<NotificationData> notificationDatas = [];
  List<HistoryData> history = [];
  List outstation = [];
  List outStationDriver = [];
  List<ComplaintList> complaintList = [];
  List<Marker> markers = [];
  Set<Polyline> polyline = {};
  LatLngBounds? bound;
  List<LatLng> polylist = [];
  List<fmlt.LatLng> fmpoly = [];

  Map<int, List<HistoryData>> historyCache = {
    0: [], // Completed history
    1: [], // Later history
    2: [], // Cancelled history
  };

  // UserDetails
  TextEditingController updateController = TextEditingController();
  TextEditingController complaintController = TextEditingController();
  String profilePicture = '';
  String name = '';
  String mobile = '';
  String email = '';
  String gender = '';
  String profileImage = '';
  String darkMapString = '';
  String lightMapString = '';
  bool isContainerClicked = false;

  List<String> genderOptions = [
    'Male',
    'Female',
    'Prefer not to say',
  ];
  String selectedGender = '';
  bool isLoading = false;
  UserDetail? userData;
  HistoryData? historyData;
  DriverData? driverData;
  PaymentAuthData? paymentAuthData;
  CardFormEditController? cardFormEditController;
  CardFieldInputDetails? cardDetails;

  //fav address
  TextEditingController newAddressController = TextEditingController();
  List<FavoriteLocationData> home = [];
  List<FavoriteLocationData> work = [];
  List<FavoriteLocationData> others = [];
  List<FavoriteLocationData> favAddressList = [];

  List<FaqData> faqDataList = [];
  int choosenFaqIndex = 0;

  int choosenMapIndex = 0;

  int selectedHistoryType = 0;

  List<WalletHistoryData> walletHistoryList = [];
  WalletResponseModel? walletResponse;
  List<PaymentGateway> walletPaymentGatways = [];
  List<SavedCardDetails> savedCardsList = [];
  TextEditingController walletAmountController = TextEditingController();
  TextEditingController transferPhonenumber = TextEditingController();
  TextEditingController transferAmount = TextEditingController();
  dynamic addMoney;
  WalletPagination? walletPaginations;
  int? choosenPaymentIndex = 0;
  List<SOSDatum> sosdata = [];
  List<ContactsModel> contactsList = [];
  ContactsModel selectedContact = ContactsModel(name: '', number: '');
  TextEditingController addSosNameController = TextEditingController();
  TextEditingController addSosMobileController = TextEditingController();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(value: "user", child: Text("User")),
      DropdownMenuItem(value: "driver", child: Text("Driver")),
    ];
    return menuItems;
  }

  String dropdownValue = 'user';

  TextEditingController adminchatText = TextEditingController();
  List<ChatData> adminChatList = [];
  dynamic isNewChat = 1;
  String chatId = '';
  List<Conversation> adminChatHistory = [];
  ScrollController scrollController = ScrollController();
  NotificationPagination? notificationPaginations;
  List<AddressModel> selectedAddress = [];
  GoogleMapController? googleMapController;
  final fm.MapController fmController = fm.MapController();
  LatLng currentLatLng = const LatLng(0, 0);
  String currentLocation = '';
  bool isCameraMoved = false;
  HistoryPagination? historyPaginations;
  TextEditingController searchController = TextEditingController();
  AddressModel? favNewAddress;
  String webViewUrl = '';
  String mapType = '';
  bool loadMore = false;
  bool isArrow = true;
  bool paymentProcessComplete = false;
  bool paymentSuccess = false;
  bool addCardSuccess = false;
  bool sosInitLoading = false;
  bool isFavLoading = false;
  bool isSosLoading = false;
  bool firstLoad = true;
  bool isDarkTheme = false;
  WebViewController? webController;
  InAppWebViewController? inAppWebViewController;
  int? selectedAmount;
  String? paymentUrl;

  StreamSubscription<DatabaseEvent>? chatStream;
  StreamSubscription<DatabaseEvent>? outStationBidStream;
  String unSeenChatCount = '0';

  AccBloc() : super(AccInitialState()) {
    on<AccUpdateEvent>((event, emit) => emit(UpdateState()));
    on<AccGetDirectionEvent>(getDirection);
    on<OnTapChangeEvent>(_onTapChange);
    on<ContainerClickedEvent>(_isClickChange);

    //isEditPage
    on<IsEditPage>(_isEditPage);
    on<UpdateControllerWithDetailsEvent>(_updateControllerWithDetails);
    on<UserDetailsPageInitEvent>(_updateUserDetails);

    //Notification
    on<NotificationGetEvent>(_getNotificationList);
    on<ClearAllNotificationsEvent>(_clearAllNotifications);
    on<DeleteNotificationEvent>(_deleteNotification);
    on<NotificationPageInitEvent>(notificationInitEvent);

    on<GetFaqListEvent>(_getFaqList);
    on<FaqOnTapEvent>(_selectedFaqIndex);
    on<ChooseMapOnTapEvent>(_selectedMapIndex);

    // History
    on<HistoryPageInitEvent>(historyInitEvent);
    on<HistoryGetEvent>(_getHistoryList);
    on<HistoryTypeChangeEvent>(_historyTypeChange);
    on<AddHistoryMarkerEvent>(addHistoryMarker);

    //Outstation
    on<OutstationGetEvent>(_getOutstationList);
    on<OutstationAcceptOrDeclineEvent>(outstationAcceptOrDecline);

    //Logout event
    on<LogoutEvent>(_logout);

    //Delete Account
    on<DeleteAccountEvent>(_deleteAccount);

    //Complaint page
    on<ComplaintEvent>(_getComplaints);
    on<ComplaintButtonEvent>(_complaintButton);

    // Wallet PAge
    on<WalletPageInitEvent>(walletInitEvent);
    on<GetWalletHistoryListEvent>(_getWalletHistoryList);
    on<TransferMoneySelectedEvent>(_onTransferMoneySelected);
    on<MoneyTransferedEvent>(moneyTransfered);
    on<PaymentAuthenticationEvent>(paymentAuth);
    on<AddCardDetailsEvent>(addCardDetails);
    on<CardListEvent>(getCardList);
    on<DeleteCardEvent>(deleteCard);
    on<MakeDefaultCardEvent>(makeDefault);

    //gender list
    on<GenderSelectedEvent>(_onGenderSelected);
    on<DeleteContactEvent>(_deletesos);
    on<AccGetUserDetailsEvent>(getUserDetails);
    on<SelectContactDetailsEvent>(selectContactDetails);
    on<AddContactEvent>(addContactDetails);
    on<DeleteFavAddressEvent>(_deleteFavAddress);
    on<GetFavListEvent>(getFavList);
    on<SelectFromFavAddressEvent>(selectFavAddress);
    on<AddFavAddressEvent>(addFavourites);

    // update details
    on<UpdateUserDetailsEvent>(_updateTextField);
    on<UserDetailEditEvent>(userDetailEdit);
    on<SendAdminMessageEvent>(sendAdminChat);
    on<GetAdminChatHistoryListEvent>(_getAdminChatHistoryList);
    on<AdminMessageSeenEvent>(_adminMessageSeenDetail);

    //update profile
    on<UpdateImageEvent>(_getProfileImage);
    on<PaymentOnTapEvent>(_selectedPaymentIndex);
    on<RideLaterCancelRequestEvent>(cancelRequest);
    on<FavNewAddressInitEvent>(newFavAddress);
    on<UserDataInitEvent>(userDataInit);
    on<AddMoneyWebViewUrlEvent>(addMoneyWebViewUrl);

    on<SosInitEvent>(sosPageInit);
    on<AdminChatInitEvent>(adminChatInit);
    on<WalletPageReUpdateEvent>(walletPageReUpdate);
  }

  //Get Direction
  Future<void> getDirection(AccEvent event, Emitter<AccState> emit) async {
    emit(AccDataLoadingStartState());
    textDirection = await AppSharedPreference.getLanguageDirection();
    mapType = await AppSharedPreference.getMapType();
    isDarkTheme = await AppSharedPreference.getDarkThemeStatus();
    lightMapString = await rootBundle.loadString('assets/light.json');
    darkMapString = await rootBundle.loadString('assets/dark.json');
    if (mapType == 'google_map') {
      choosenMapIndex = 0;
    } else {
      choosenMapIndex = 1;
    }
    emit(AccDataLoadingStopState());
  }

  FutureOr<void> walletPageReUpdate(
      WalletPageReUpdateEvent event, Emitter<AccState> emit) async {
    emit(WalletPageReUpdateState(
        currencySymbol: event.currencySymbol,
        money: event.money,
        requestId: event.requestId,
        url: event.url,
        userId: event.userId));
  }

  void _isClickChange(ContainerClickedEvent event, Emitter<AccState> emit) {
    isContainerClicked = !isContainerClicked;
    emit(ContainerClickState(isContainerClicked: isContainerClicked));
  }

  //ontap event
  Future<void> _onTapChange(
      OnTapChangeEvent event, Emitter<AccState> emit) async {}

  void _isEditPage(IsEditPage event, Emitter<AccState> emit) {
    _isEdit = !_isEdit;
  }

  //Update userDetails controller
  Future<void> _updateControllerWithDetails(
      UpdateControllerWithDetailsEvent event, Emitter<AccState> emit) async {
    userData = event.args.userData;
    updateController.text = event.args.text;
    emit(UpdateState());
  }

  //Update User Details
  Future<void> _updateUserDetails(
      UserDetailsPageInitEvent event, Emitter<AccState> emit) async {
    userData = event.arg.userData;
    sosdata = event.arg.userData.sos.data;
    favAddressList = event.arg.userData.favouriteLocations.data;
    if (userData != null) {
      name = userData!.name;
      mobile = userData!.mobile;
      email = userData!.email;
      gender = userData!.gender;
      profilePicture = userData!.profilePicture;
    }
    emit(UserDetailsSuccessState(userData: userData));
  }

  Future<void> notificationInitEvent(
      NotificationPageInitEvent event, Emitter<AccState> emit) async {
    add(NotificationGetEvent());
    scrollController.addListener(notificationPageScrollListener);
    emit(UpdateState());
  }

  notificationPageScrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (notificationPaginations != null &&
          notificationPaginations!.pagination != null &&
          notificationPaginations!.pagination.currentPage <
              notificationPaginations!.pagination.totalPages) {
        loadMore = true;
        add(AccUpdateEvent());
        add(NotificationGetEvent());
        add(AccUpdateEvent());
      } else {
        if (notificationPaginations!.pagination.currentPage ==
            notificationPaginations!.pagination.totalPages) {
          loadMore = false;
          add(AccUpdateEvent());
        }
      }
    }
  }

  // Get Notifications
  Future<void> _getNotificationList(
      NotificationGetEvent event, Emitter<AccState> emit) async {
    isLoading = true;
    emit(UpdateState());
    emit(AccDataLoadingStartState());
    try {
      final data = await serviceLocator<AccUsecase>()
          .notificationDetails(pageNo: event.pageNumber.toString());
      data.fold(
        (error) {
          isLoading = false;
          emit(UpdateState());
          emit(NotificationFailure(errorMessage: error.message ?? ""));
        },
        (success) {
          isLoading = false;
          emit(UpdateState());
          for (var i = 0; i < success.data.length; i++) {
            notificationDatas.add(success.data[i]);
          }
          notificationPaginations = success.meta;
          emit(NotificationSuccess(notificationDatas: notificationDatas));
        },
      );
    } catch (e) {
      emit(NotificationFailure(errorMessage: e.toString()));
    }
  }

//ook
  Future<void> historyInitEvent(
      HistoryPageInitEvent event, Emitter<AccState> emit) async {
    add(HistoryGetEvent(historyFilter: 'is_completed=1'));
    scrollController.addListener(historyPageScrollListener);
    emit(UpdateState());
  }

  historyPageScrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (historyPaginations != null &&
          historyPaginations!.pagination != null &&
          historyPaginations!.pagination.currentPage <
              historyPaginations!.pagination.totalPages) {
        loadMore = true;
        add(AccUpdateEvent());
        add(HistoryGetEvent(
            pageNumber: historyPaginations!.pagination.currentPage + 1,
            historyFilter: (selectedHistoryType == 0)
                ? "is_completed=1"
                : (selectedHistoryType == 1)
                    ? "is_later=1"
                    : "is_cancelled=1"));
        // loadMore = false;
        add(AccUpdateEvent());
      } else {
        if (historyPaginations!.pagination.currentPage ==
            historyPaginations!.pagination.totalPages) {
          loadMore = false;
          add(AccUpdateEvent());
        }
      }
    }
  }

  // History
  Future<void> _getHistoryList(
      HistoryGetEvent event, Emitter<AccState> emit) async {
    isLoading = true;
    emit(UpdateState());
    history.clear();
    final data = await serviceLocator<AccUsecase>().historyDetails(
        event.historyFilter,
        pageNo: event.pageNumber.toString());
    data.fold(
      (error) {
        isLoading = false;
        emit(UpdateState());
        debugPrint('History Error: ${error.toString()}');
        emit(HistoryFailure(errorMessage: error.message ?? ""));
      },
      (success) {
        isLoading = false;
        loadMore = false;
        emit(UpdateState());
        for (var i = 0; i < success.data.length; i++) {
          history.add(success.data[i]);
        }
        // history = success.data;
        historyPaginations = success.meta;
        emit(HistorySuccess(history: history));
      },
    );
  }

  // Outstation
  Future<void> _getOutstationList(
      OutstationGetEvent event, Emitter<AccState> emit) async {
    if (outStationBidStream != null) {
      outStationBidStream?.cancel();
    }
    outStationBidStream = FirebaseDatabase.instance
        .ref()
        .child('bid-meta/${event.id}')
        .onValue
        .handleError((onError) {
      outStationBidStream?.cancel();
    }).listen(
      (DatabaseEvent event) {
        debugPrint("Outstation Bidding Stream");
        Map rideList = {};
        DataSnapshot snapshots = event.snapshot;
        if (snapshots.value != null) {
          rideList = jsonDecode(jsonEncode(snapshots.value));
          if (rideList['request_id'] != null) {
            if (rideList['drivers'] != null) {
              outstation.clear();
              outStationDriver.clear();
              Map driver = rideList['drivers'];
              driver.forEach((key, value) {
                if (driver[key]['is_rejected'] != 'by_driver' &&
                    driver[key]['is_rejected'] != 'by_user') {
                  outstation.add(value);
                  final dist = calculateDistance(
                      lat1: rideList['pick_lat'],
                      lon1: rideList['pick_lng'],
                      lat2: rideList['drivers'][key]['lat'],
                      lon2: rideList['drivers'][key]['lng']);
                  outStationDriver.add(dist.toStringAsFixed(2));
                } else {
                  outstation.removeWhere(
                      (element) => element["id"] == driver[key]["id"]);
                }
              });
              add(AccUpdateEvent());
            }
          }
        }
      },
    );
  }

  Future<void> outstationAcceptOrDecline(
      OutstationAcceptOrDeclineEvent event, Emitter<AccState> emit) async {
    if (event.isAccept) {
      final data = await serviceLocator<BookingUsecase>().biddingAccept(
          requestId: event.id,
          driverId: event.driver['driver_id'].toString(),
          acceptRideFare: event.driver['price'].toString(),
          offeredRideFare: event.offeredRideFare);
      await data.fold(
        (error) {
          isLoading = false;
          if (error.message == 'logout') {
            emit(UpdateState());
          } else {
            showToast(message: '${error.message}');
            emit(UpdateState());
          }
        },
        (success) async {
          emit(OutstationAcceptState());
          await FirebaseDatabase.instance
              .ref()
              .child('bid-meta/${event.id}')
              .remove();
        },
      );
    } else {
      await FirebaseDatabase.instance
          .ref()
          .child(
              'bid-meta/${event.id}/drivers/driver_${event.driver["driver_id"]}')
          .update({"is_rejected": 'by_user'});
      outstation.removeWhere(
          (element) => element["driver_id"] == event.driver["driver_id"]);
      emit(UpdateState());
    }
  }

  // Change History Type
  Future<void> _historyTypeChange(
      HistoryTypeChangeEvent event, Emitter<AccState> emit) async {
    selectedHistoryType = event.historyTypeIndex;
    String filter;
    switch (selectedHistoryType) {
      case 0:
        filter = 'is_completed=1';
        break;
      case 1:
        filter = 'is_later=1';
        break;
      case 2:
        filter = 'is_cancelled=1';
        break;
      default:
        filter = '';
    }
    emit(UpdateState());
    add(HistoryGetEvent(historyFilter: filter));
    // emit(HistoryTypeChangeState(selectedHistoryType: selectedHistoryType));
  }

  FutureOr<void> addHistoryMarker(
      AddHistoryMarkerEvent event, Emitter<AccState> emit) async {
    mapType = await AppSharedPreference.getMapType();
    if (mapType == 'google_map') {
      markers.clear();
      markers.add(Marker(
        markerId: const MarkerId("pick"),
        position:
            LatLng(double.parse(event.pickLat), double.parse(event.pickLng)),
        icon: await Image.asset(
          AppImages.pickPin,
          height: 30,
          fit: BoxFit.contain,
        ).toBitmapDescriptor(
            logicalSize: const Size(20, 20), imageSize: const Size(200, 200)),
      ));
      if (event.stops!.isEmpty && event.dropLat != '') {
        markers.add(Marker(
          markerId: const MarkerId("drop"),
          position: LatLng(
              double.parse(event.dropLat!), double.parse(event.dropLng!)),
          icon: await Image.asset(
            AppImages.dropPin,
            height: 30,
            fit: BoxFit.contain,
          ).toBitmapDescriptor(
              logicalSize: const Size(20, 20), imageSize: const Size(200, 200)),
        ));
      } else if (event.stops != null) {
        for (var i = 0; i < event.stops!.length; i++) {
          markers.add(Marker(
            markerId: MarkerId("drop$i"),
            position: LatLng(
                event.stops![i]['latitude'], event.stops![i]['longitude']),
            icon: await Image.asset(
              AppImages.dropPin,
              height: 30,
              fit: BoxFit.contain,
            ).toBitmapDescriptor(
                logicalSize: const Size(20, 20),
                imageSize: const Size(200, 200)),
          ));
        }
      }
    }
    if (mapType == 'google_map') {
      if (event.dropLat != null) {
        mapBound(
            double.parse(event.pickLat),
            double.parse(event.pickLng),
            double.parse(event.dropLat!),
            double.parse(event.dropLng!),
            mapType);
      } else {
        googleMapController
            ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(
                  double.parse(event.pickLat),
                  double.parse(event.pickLng),
                ),
                zoom: 15)));
      }

      if (event.polyline != '') {
        await decodeEncodedPolyline(event.polyline!, mapType);
      }
    } else {
      if (event.polyline != '') {
        await decodeEncodedPolyline(event.polyline!, mapType);
      }
      if (event.dropLat != null) {
        fmController.fitCamera(fm.CameraFit.coordinates(coordinates: [
          fmlt.LatLng(double.parse(event.pickLat), double.parse(event.pickLng)),
          fmlt.LatLng(
              double.parse(event.dropLat!), double.parse(event.dropLng!))
        ]));
        fmController.move(
            fmlt.LatLng(
                double.parse(event.pickLat), double.parse(event.pickLng)),
            10);
      } else {
        fmController.move(
            fmlt.LatLng(
                double.parse(event.pickLat), double.parse(event.pickLng)),
            10);
      }
    }

    emit(UpdateState());
  }

  //Clear notification
  Future<void> _clearAllNotifications(
      ClearAllNotificationsEvent event, Emitter<AccState> emit) async {
    try {
      for (var value in notificationDatas) {
        await _deleteNotificationById(value.id);
      }
      notificationDatas.clear();
      emit(NotificationClearedSuccess());
    } catch (e) {
      emit(NotificationFailure(errorMessage: e.toString()));
    }
  }

  // Delete notification
  Future<void> _deleteNotification(
      DeleteNotificationEvent event, Emitter<AccState> emit) async {
    try {
      await _deleteNotificationById(event.id);
      notificationDatas.removeWhere((value) => value.id == event.id);
      emit(NotificationDeletedSuccess());
    } catch (e) {
      emit(NotificationFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _deleteNotificationById(String id) async {
    try {
      await serviceLocator<AccUsecase>().deleteNotification(id);
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  // Logout
  Future<void> _logout(LogoutEvent event, Emitter<AccState> emit) async {
    emit(LogoutLoadingState());
    final data = await serviceLocator<AccUsecase>().logout();
    data.fold(
      (error) {
        debugPrint('Logout error: ${error.toString()}');
        emit(LogoutFailureState(errorMessage: error.toString()));
      },
      (success) {
        emit(LogoutSuccess());
      },
    );
  }

  // Delete account
  Future<void> _deleteAccount(
      DeleteAccountEvent event, Emitter<AccState> emit) async {
    emit(DeleteAccountLoadingState());
    final deleteResult = await serviceLocator<AccUsecase>().deleteUserAccount();
    deleteResult.fold(
      (error) {
        debugPrint('Delete Account error: ${error.toString()}');
        emit(DeleteAccountFailureState(errorMessage: error.message ?? ""));
      },
      (success) {
        emit(DeleteAccountSuccess());
      },
    );
  }

  // make complaints
  Future<void> _getComplaints(
      ComplaintEvent event, Emitter<AccState> emit) async {
    isLoading = true;
    emit(MakeComplaintLoading());

    try {
      final data = await serviceLocator<AccUsecase>()
          .makeComplaint(complaintType: event.complaintType.toString());
      data.fold(
        (error) {
          isLoading = false;
          debugPrint('Outstation Error: ${error.toString()}');
          emit(MakeComplaintFailure(errorMessage: error.message ?? ""));
        },
        (success) {
          isLoading = false;
          complaintList = success.data;
          emit(MakeComplaintSuccess(complaintList: complaintList));
        },
      );
    } catch (e) {
      debugPrint('An error occurred: $e');
      emit(MakeComplaintFailure(errorMessage: e.toString()));
    }
  }

// make complaint button
  Future<void> _complaintButton(
      ComplaintButtonEvent event, Emitter<AccState> emit) async {
    final complaintText = complaintController.text.trim();

    if (complaintText.length <= 10) {
      emit(ComplaintButtonFailureState(
          errorMessage: 'Complaint text must be more than 10 characters.'));
      return;
    }

    emit(ComplaintButtonLoadingState());
    final result = await serviceLocator<AccUsecase>().makeComplaintButton(
        event.complaintTitleId, complaintText, event.requestId);

    result.fold(
      (failure) {
        debugPrint('Make Complaint Button error: ${failure.toString()}');
        emit(ComplaintButtonFailureState(errorMessage: failure.toString()));
      },
      (success) {
        emit(MakeComplaintButtonSuccess());
        complaintController.clear();
      },
    );
  }

  Future<void> _onGenderSelected(
      GenderSelectedEvent event, Emitter<AccState> emit) async {
    selectedGender = event.selectedGender;
    emit(GenderSelectedState(selectedGender: selectedGender));
  }

//Faq
  FutureOr<void> _getFaqList(
      GetFaqListEvent event, Emitter<AccState> emit) async {
    emit(FaqLoadingState());
    final data = await serviceLocator<AccUsecase>().getFaqDetail();
    data.fold(
      (error) {
        emit(FaqFailureState());
      },
      (success) {
        faqDataList = success.data;
        emit(FaqSuccessState());
      },
    );
  }

  Future<void> _selectedFaqIndex(
      FaqOnTapEvent event, Emitter<AccState> emit) async {
    choosenFaqIndex = event.selectedFaqIndex;
    emit(FaqSelectState(choosenFaqIndex));
  }

  Future<void> _selectedMapIndex(
      ChooseMapOnTapEvent event, Emitter<AccState> emit) async {
    choosenMapIndex = event.chooseMapIndex;
    if (event.chooseMapIndex == 0) {
      await AppSharedPreference.setMapType('google_map');
    } else {
      await AppSharedPreference.setMapType('open_street_map');
    }
    emit(ChooseMapSelectState(choosenMapIndex));
  }

  FutureOr<void> _getWalletHistoryList(
      GetWalletHistoryListEvent event, Emitter<AccState> emit) async {
    if (firstLoad) {
      emit(WalletHistoryLoadingState());
    }
    final data =
        await serviceLocator<AccUsecase>().getWalletDetail(event.pageIndex);
    data.fold(
      (error) {
        isLoading = false;
        firstLoad = false;
        emit(UpdateState());
        emit(WalletHistoryFailureState());
      },
      (success) {
        isLoading = false;
        loadMore = false;
        firstLoad = false;
        walletResponse = success;

        walletPaymentGatways = success.paymentGateways;
        if (event.pageIndex == 1) {
          walletHistoryList = success.walletHistory.data;
        } else {
          if (success.walletHistory.data.isNotEmpty) {
            walletHistoryList.addAll(success.walletHistory.data);
          }
        }
        walletPaginations = success.walletHistory.meta;
        emit(WalletHistorySuccessState(walletHistoryDatas: walletHistoryList));
      },
    );
  }

  Future<void> walletInitEvent(
      WalletPageInitEvent event, Emitter<AccState> emit) async {
    userData = event.arg.userData;
    firstLoad = true;
    isLoading = true;
    add(GetWalletHistoryListEvent(pageIndex: 1));
    scrollController.addListener(walletPageScrollListener);
    emit(UpdateState());
  }

  walletPageScrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoading &&
        !loadMore) {
      if (walletPaginations != null &&
          walletPaginations!.pagination.currentPage <
              walletPaginations!.pagination.totalPages) {
        loadMore = true;
        add(AccUpdateEvent());
        add(GetWalletHistoryListEvent(
            pageIndex: walletPaginations!.pagination.currentPage + 1));
      } else {
        if (walletPaginations!.pagination.currentPage ==
            walletPaginations!.pagination.totalPages) {
          loadMore = false;
          add(AccUpdateEvent());
        }
      }
    }
  }

  Future<void> _onTransferMoneySelected(
      TransferMoneySelectedEvent event, Emitter<AccState> emit) async {
    dropdownValue = event.selectedTransferAmountMenuItem;
    emit(TransferMoneySelectedState(
        selectedTransferAmountMenuItem: dropdownValue));
  }

  FutureOr<void> moneyTransfered(
      MoneyTransferedEvent event, Emitter<AccState> emit) async {
    emit(UserProfileDetailsLoadingState());
    final data = await serviceLocator<AccUsecase>().moneyTransfer(
        transferMobile: event.transferMobile,
        role: event.role,
        transferAmount: event.transferAmount);
    data.fold(
      (error) {
        debugPrint(error.toString());
        emit(MoneyTransferedFailureState());
      },
      (success) {
        add(GetWalletHistoryListEvent(
            pageIndex: walletPaginations!.pagination.currentPage));
        emit(MoneyTransferedSuccessState());

        // add(GetWalletHistoryListEvent());
      },
    );
  }

  Future<void> paymentAuth(
      PaymentAuthenticationEvent event, Emitter<AccState> emit) async {
    userData = event.arg.userData;
    final data = await serviceLocator<AccUsecase>().stripeSetupIntent();
    data.fold((error) {
      debugPrint(error.toString());
    }, (success) {
      paymentAuthData = success.data;
    });
    emit(UpdateState());
  }

  Future<void> getUserDetails(
      AccGetUserDetailsEvent event, Emitter<AccState> emit) async {
    // emit(AccDataLoadingState());
    final data = await serviceLocator<HomeUsecase>().userDetails();
    data.fold((error) {
      debugPrint(error.toString());
    }, (success) {
      userData = success.data;
      sosdata = success.data.sos.data;
      favAddressList = success.data.favouriteLocations.data;
      add(GetFavListEvent(userData: userData!, favAddressList: favAddressList));
      // emit(AccDataSuccessState());
    });
  }

  // Delete sos
  Future<void> _deletesos(
      DeleteContactEvent event, Emitter<AccState> emit) async {
    final data = await serviceLocator<AccUsecase>().deleteSosContact(event.id!);
    data.fold(
      (error) {
        debugPrint(error.toString());
        emit(SosFailureState());
      },
      (success) {
        add(AccGetUserDetailsEvent());
        emit(SosDeletedSuccessState());
      },
    );
  }

  FutureOr<void> addContactDetails(
      AddContactEvent event, Emitter<AccState> emit) async {
    emit(UserProfileDetailsLoadingState());
    isLoading = true;
    final data = await serviceLocator<AccUsecase>()
        .addSosContact(name: event.name, number: event.number);
    data.fold(
      (error) {
        debugPrint(error.toString());
        emit(AddContactFailureState());
      },
      (success) {
        isLoading = false;
        add(AccGetUserDetailsEvent());
        emit(AddContactSuccessState());
      },
    );
  }

  Future<void> selectContactDetails(
      SelectContactDetailsEvent event, Emitter<AccState> emit) async {
    await Permission.contacts.request();
    PermissionStatus status = await Permission.contacts.status;
    if (status.isGranted) {
      emit(AccDataLoadingStartState());
      Iterable<Contact> contacts = await ContactsService.getContacts();
      if (contactsList.isEmpty) {
        for (var contact in contacts) {
          contact.phones!.toSet().forEach((phone) {
            contactsList.add(ContactsModel(
                name: contact.displayName ?? contact.givenName!,
                number: phone.value!));
          });
        }
      }
      emit(AccDataLoadingStopState());
      emit(SelectContactDetailsState());
    } else {
      debugPrint("Permission Denied");
      bool isOpened = await openAppSettings();
      if (isOpened) {
      } else {}
      emit(GetContactPermissionState());
    }
  }

  Future<void> _updateTextField(
      UpdateUserDetailsEvent event, Emitter<AccState> emit) async {
    final result = await serviceLocator<AccUsecase>().updateDetailsButton(
      email: event.email,
      name: event.name,
      gender: event.gender,
      profileImage: event.profileImage,
    );
    result.fold(
      (failure) {
        debugPrint('Update Details: ${failure.toString()}');
        emit(UpdateUserDetailsFailureState());
      },
      (success) {
        emit(UserDetailsUpdatedState(
          name: success["data"]['name'] ?? '', //event.name,
          email: success["data"]['email'] ?? '', //event.email,
          gender: success["data"]['gender'] ?? '', //event.gender,
          profileImage:
              success["data"]['profile_picture'] ?? '', //event.profileImage,
        ));
        emit(UpdateState());
      },
    );
  }

  Future<void> _getProfileImage(
      UpdateImageEvent event, Emitter<AccState> emit) async {
    final ImagePicker picker = ImagePicker();
    XFile? image;
    if (event.source == ImageSource.camera) {
      image = await picker.pickImage(source: ImageSource.camera);
    } else if (event.source == ImageSource.gallery) {
      image = await picker.pickImage(source: ImageSource.gallery);
    }

    if (image != null) {
      profileImage = image.path;
      emit(ImageUpdateState(profileImage: profileImage));
      add(UpdateUserDetailsEvent(
        name: event.name,
        email: event.email,
        gender: event.gender,
        profileImage: profileImage,
      ));
    }
  }

  Future<void> _deleteFavAddress(
      DeleteFavAddressEvent event, Emitter<AccState> emit) async {
    final data =
        await serviceLocator<AccUsecase>().deleteFavouritesAddress(event.id!);
    data.fold(
      (error) {
        debugPrint(error.toString());
        emit(FavFailureState());
      },
      (success) {
        if (event.isHome) {
          home.removeWhere((element) => element.id == event.id);
        } else if (event.isWork) {
          work.removeWhere((element) => element.id == event.id);
        } else if (event.isOthers) {
          others.removeWhere((element) => element.id == event.id);
        }
        if (userData != null) {
          userData!.favouriteLocations.data
              .removeWhere((element) => element.id == event.id);
        }
        emit(FavDeletedSuccessState());
      },
    );
  }

  //Fav loc
  FutureOr<void> getFavList(
      GetFavListEvent event, Emitter<AccState> emit) async {
    userData = event.userData;
    isFavLoading = true;
    emit(FavoriteLoadingState());
    home.clear();
    work.clear();
    others.clear();
    if (event.favAddressList.isNotEmpty) {
      for (var e in event.favAddressList) {
        if (e.addressName == 'Work') {
          work.add(e);
        } else if (e.addressName == 'Home') {
          home.add(e);
        } else {
          others.add(e);
        }
      }
    }
    await Future.delayed(const Duration(seconds: 1));
    isFavLoading = false;
    emit(FavoriteLoadedState());
    // emit(UpdateState());
  }

  FutureOr<void> selectFavAddress(
      SelectFromFavAddressEvent event, Emitter<AccState> emit) async {
    emit(SelectFromFavAddressState(addressType: event.addressType));
  }

  Future addFavourites(AddFavAddressEvent event, Emitter<AccState> emit) async {
    final data = await serviceLocator<AccUsecase>().addFavAddress(
        address: event.address,
        name: event.name,
        lat: event.lat,
        lng: event.lng);
    data.fold(
      (error) {
        debugPrint(error.toString());
        emit(AddFavAddressFailureState());
      },
      (success) {
        if (!event.isOther) {
          add(AccGetUserDetailsEvent());
        }
        emit(UpdateState());
      },
    );
  }

  FutureOr<void> userDetailEdit(
      UserDetailEditEvent event, Emitter<AccState> emit) async {
    emit(UserDetailEditState(header: event.header, text: event.text));
  }

  FutureOr<void> sendAdminChat(
      SendAdminMessageEvent event, Emitter<AccState> emit) async {
    emit(AccDataLoadingStartState());
    final data = await serviceLocator<AccUsecase>().sendAdminMessages(
        newChat: event.newChat, message: event.message, chatId: event.chatId);
    data.fold(
      (error) {
        emit(SendAdminMessageFailureState());
      },
      (success) {
        chatId = success.data.conversationId;
        adminChatList.add(ChatData(
            message: success.data.message,
            conversationId: chatId,
            senderId: userData!.id.toString(),
            senderType: success.data.senderType,
            count: success.data.count,
            newChat: success.data.newChat,
            createdAt: success.data.createdAt,
            messageSuccess: success.data.messageSuccess,
            userTimezone: success.data.userTimezone));
        isNewChat = 0;
        if (adminChatList.isNotEmpty && chatStream == null) {
          streamAdminchat();
        }
        unSeenChatCount = '0';
        // add(GetAdminChatHistoryListEvent());
        emit(SendAdminMessageSuccessState());
      },
    );
  }

  FutureOr<void> _getAdminChatHistoryList(
      GetAdminChatHistoryListEvent event, Emitter<AccState> emit) async {
    emit(UserProfileDetailsLoadingState());
    final data = await serviceLocator<AccUsecase>().getAdminChatHistoryDetail();
    data.fold(
      (error) {
        emit(AdminChatHistoryFailureState());
      },
      (success) {
        adminChatList.clear();
        isNewChat = success.data.newChat;
        int count = success.data.count;
        for (var i = 0; i < success.data.conversation.length; i++) {
          adminChatList.add(ChatData(
              message: success.data.conversation[i].content,
              conversationId: success.data.conversation[i].conversationId,
              senderId: success.data.conversation[i].senderId.toString(),
              senderType: success.data.conversation[i].senderType.toString(),
              count: count,
              newChat: '0',
              createdAt: success.data.conversation[i].createdAt,
              messageSuccess: 'Data inserted successfully',
              userTimezone: success.data.conversation[i].userTimezone));
        }
        // if (adminChatList.isNotEmpty) {
        chatId = success.data.conversationId;
        // add(AdminMessageSeenEvent(chatId: chatId));
        // }
        if (adminChatList.isNotEmpty && chatStream == null) {
          streamAdminchat();
        }
        unSeenChatCount = '0';
        emit(AdminChatHistorySuccessState());
      },
    );
  }

  streamAdminchat() async {
    if (chatStream != null) {
      chatStream?.cancel();
      chatStream = null;
    }
    chatStream = FirebaseDatabase.instance
        .ref()
        .child(
            'conversation/${(adminChatList.length > 2) ? (userData != null) ? userData!.chatId : chatId : chatId}')
        .onValue
        .listen((event) async {
      var value = Map<String, dynamic>.from(
          jsonDecode(jsonEncode(event.snapshot.value)));
      if (userData != null) {
        if ((((adminChatList.isNotEmpty &&
                    adminChatList.last.message !=
                        value['message'].toString())) &&
                value['sender_id'].toString() != userData!.id.toString()) ||
            (value['sender_id'].toString() != userData!.id.toString() &&
                adminChatList.isEmpty)) {
          // adminChatList.add(jsonDecode(jsonEncode(event.snapshot.value)));
          adminChatList.add(ChatData.fromJson(value));
          add(AccUpdateEvent());
        }
      }
      value.clear();
      if (adminChatList.isNotEmpty) {
        unSeenChatCount =
            adminChatList[adminChatList.length - 1].count.toString();
        if (unSeenChatCount == 'null') {
          unSeenChatCount = '0';
        }
      }
    });
  }

  FutureOr<void> _adminMessageSeenDetail(
      AdminMessageSeenEvent event, Emitter<AccState> emit) async {
    emit(UserProfileDetailsLoadingState());
    final data = await serviceLocator<AccUsecase>()
        .adminMessageSeenDetail(event.chatId!);
    data.fold(
      (error) {
        emit(AdminMessageSeenFailureState());
      },
      (success) {
        emit(AdminMessageSeenSuccessState());
      },
    );
  }

  Future<void> _selectedPaymentIndex(
      PaymentOnTapEvent event, Emitter<AccState> emit) async {
    choosenPaymentIndex = event.selectedPaymentIndex;
    emit(PaymentSelectState(choosenPaymentIndex!));
  }

  FutureOr cancelRequest(
      RideLaterCancelRequestEvent event, Emitter<AccState> emit) async {
    emit(AccDataLoadingStartState());
    final data = await serviceLocator<BookingUsecase>()
        .cancelRequest(requestId: event.requestId, reason: event.reason);
    data.fold((error) {
      debugPrint(error.toString());
      emit(AccDataLoadingStopState());
    }, (success) {
      emit(AccDataLoadingStopState());
      history.removeWhere((value) => value.id == event.requestId);
      emit(RequestCancelState());
    });
  }

  FutureOr newFavAddress(
      FavNewAddressInitEvent event, Emitter<AccState> emit) async {
    favNewAddress = event.arg.selectedAddress;
    userData = event.arg.userData;
    emit(UpdateState());
  }

  FutureOr addMoneyWebViewUrl(
      AddMoneyWebViewUrlEvent event, Emitter<AccState> emit) async {
    if (event.from == '1') {
      paymentUrl =
          '${event.url}?amount=${event.money}&payment_for=request&currency=${event.currencySymbol}&user_id=${event.userId.toString()}&request_id=${event.requestId.toString()}';
    } else {
      paymentUrl =
          '${event.url}?amount=${event.money}&payment_for=wallet&currency=${event.currencySymbol}&user_id=${event.userId.toString()}';
    }
  }

  Future<void> userDataInit(
      UserDataInitEvent event, Emitter<AccState> emit) async {
    userData = event.userDetails;
    emit(UpdateState());
  }

  Future<void> sosPageInit(SosInitEvent event, Emitter<AccState> emit) async {
    isSosLoading = true;
    emit(UpdateState());
    sosdata = event.arg.sosData;
    await Future.delayed(const Duration(seconds: 2));
    isSosLoading = false;
    emit(UpdateState());
  }

  Future<void> adminChatInit(
      AdminChatInitEvent event, Emitter<AccState> emit) async {
    userData = event.arg.userData;
    emit(UpdateState());
    add(GetAdminChatHistoryListEvent());
  }

  FutureOr addCardDetails(
      AddCardDetailsEvent event, Emitter<AccState> emit) async {
    try {
      isLoading = true;
      emit(UpdateState());
      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
              paymentMethodData: PaymentMethodData(
                  billingDetails: BillingDetails(
                      name: userData!.username, phone: userData!.mobile))));
      debugPrint('Payment 0$paymentMethod');

      final data = await serviceLocator<AccUsecase>().stripSaveCardDetails(
          paymentMethodId: paymentMethod.id,
          last4Number: paymentMethod.card.last4!,
          cardType: paymentMethod.card.brand!,
          validThrough:
              '${paymentMethod.card.expMonth}/${paymentMethod.card.expYear}');
      data.fold((error) {
        debugPrint(error.toString());
      }, (success) {
        if (success['success']) {
          isLoading = false;
          emit(SaveCardSuccessState());
        } else {
          isLoading = false;
          emit(UpdateState());
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      showToast(message: 'Please enter the valid data');
    }
  }

  FutureOr getCardList(CardListEvent event, Emitter<AccState> emit) async {
    final data = await serviceLocator<AccUsecase>().cardList();
    data.fold((error) {
      debugPrint(error.toString());
    }, (success) {
      savedCardsList.clear();
      savedCardsList = success.data;
      emit(UpdateState());
    });
  }

  FutureOr deleteCard(DeleteCardEvent event, Emitter<AccState> emit) async {
    emit(AccDataLoadingStartState());
    final data =
        await serviceLocator<AccUsecase>().deleteCard(cardId: event.cardId);
    data.fold((error) {
      debugPrint(error.toString());
      showToast(message: error.message.toString());
      emit(AccDataLoadingStopState());
    }, (success) {
      savedCardsList.removeWhere((element) => element.id == event.cardId);
      emit(AccDataLoadingStopState());
    });
  }

  FutureOr makeDefault(
      MakeDefaultCardEvent event, Emitter<AccState> emit) async {
    emit(AccDataLoadingStartState());
    final data = await serviceLocator<AccUsecase>()
        .makeDefaultCard(cardId: event.cardId);
    data.fold((error) {
      debugPrint(error.toString());
      emit(AccDataLoadingStopState());
    }, (success) {
      add(CardListEvent());
      emit(AccDataLoadingStopState());
    });
  }

  Future<List<PointLatLng>> decodeEncodedPolyline(
      String encoded, String mapType) async {
    polylist.clear();
    List<PointLatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    polyline.clear();

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      if (mapType == 'google_map') {
        polylist.add(p);
      } else {
        fmpoly.add(fmlt.LatLng(p.latitude, p.longitude));
      }
    }
    if (mapType == 'google_map') {
      polyline.add(
        Polyline(
            polylineId: const PolylineId('1'),
            color: AppColors.primary,
            visible: true,
            width: 4,
            points: polylist),
      );
    }
    return poly;
  }

  mapBound(pickLat, pickLng, dropLat, dropLng, mapType) {
    dynamic pick = LatLng(pickLat, pickLng);
    dynamic drop = LatLng(dropLat, dropLng);
    if (pick.latitude > drop.latitude && pick.longitude > drop.longitude) {
      bound = LatLngBounds(southwest: drop, northeast: pick);
    } else if (pick.longitude > drop.longitude) {
      bound = LatLngBounds(
          southwest: LatLng(pick.latitude, drop.longitude),
          northeast: LatLng(drop.latitude, pick.longitude));
    } else if (pick.latitude > drop.latitude) {
      bound = LatLngBounds(
          southwest: LatLng(drop.latitude, pick.longitude),
          northeast: LatLng(pick.latitude, drop.longitude));
    } else {
      bound = LatLngBounds(southwest: pick, northeast: drop);
    }
    if (mapType == 'google_map') {
      googleMapController
          ?.animateCamera(CameraUpdate.newLatLngBounds(bound!, 50));
    }
  }
}
