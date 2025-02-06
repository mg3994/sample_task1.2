import 'package:flutter/material.dart';
import 'package:restart_tagxi/features/account/presentation/pages/outstation_page.dart';
import '../core/error/error_page.dart';
import '../features/account/presentation/pages/confirm_fav_location.dart';
import '../features/account/presentation/pages/delete_account.dart';
import '../features/account/presentation/pages/outstation_offered_page.dart';
import '../features/account/presentation/pages/payment_methods.dart';
import '../features/account/presentation/pages/paymentgateways.dart';
import '../features/home/presentation/pages/on_going_rides.dart';
import 'app_arguments.dart';
import '../features/account/presentation/pages/admin_chat.dart';
import '../features/account/presentation/pages/faq_page.dart';
import '../features/account/presentation/pages/sos_page.dart';
import '../features/bookingpage/presentation/page/give_ratings_page.dart';
import '../features/account/presentation/pages/account_page.dart';
import '../features/account/presentation/pages/complaint_list.dart';
import '../features/account/presentation/pages/complaint_page.dart';
import '../features/account/presentation/pages/edit_page.dart';
import '../features/account/presentation/pages/fav_location.dart';
import '../features/account/presentation/pages/history_page.dart';
import '../features/account/presentation/pages/notification_page.dart';
import '../features/account/presentation/pages/referral_page.dart';
import '../features/account/presentation/pages/settings_page.dart';
import '../features/account/presentation/pages/trip_summary_history.dart';
import '../features/account/presentation/pages/update_details.dart';
import '../features/account/presentation/pages/wallet_page.dart';
import '../features/auth/presentation/pages/auth_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/refferal_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/update_password_page.dart';
import '../features/home/presentation/pages/destination_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/auth/presentation/pages/verify_page.dart';
import '../features/bookingpage/presentation/page/booking_page.dart';
import '../features/home/presentation/pages/confirm_location_page.dart';
import '../features/landing/presentation/page/landing_page.dart';
import '../features/language/presentation/page/choose_language_page.dart';
import '../features/loading/presentation/pages/loader_page.dart';
import '../features/bookingpage/presentation/page/trip_summary_page.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoutes(RouteSettings routeSettings) {
    late Route<dynamic> pageRoute;
    Object? arg = routeSettings.arguments;

    switch (routeSettings.name) {
      case LoaderPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const LoaderPage(),
        );
      case LandingPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const LandingPage(),
        );
        break;
      case ChooseLanguagePage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              ChooseLanguagePage(arg: arg as ChooseLanguageArguments),
        );
        break;
      case AuthPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const AuthPage(),
        );
        break;
      case VerifyPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => VerifyPage(
            arg: arg as VerifyArguments,
          ),
        );
        break;
      case RegisterPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => RegisterPage(
            arg: arg as RegisterPageArguments,
          ),
        );
        break;
      case RefferalPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const RefferalPage(),
        );
        break;
      case ForgotPasswordPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ForgotPasswordPage(
            arg: arg as ForgotPasswordPageArguments,
          ),
        );
        break;
      case UpdatePasswordPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => UpdatePasswordPage(
            arg: arg as UpdatePasswordPageArguments,
          ),
        );
        break;
      case HomePage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
        break;
      case DestinationPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => DestinationPage(
            arg: arg as DestinationPageArguments,
          ),
        );
        break;
      case ConfirmLocationPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ConfirmLocationPage(
            arg: arg as ConfirmLocationPageArguments,
          ),
        );
        break;
      case OnGoingRidesPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              OnGoingRidesPage(arg: arg as OnGoingRidesPageArguments),
        );
        break;
      case TripSummaryPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => TripSummaryPage(
            arg: arg as TripSummaryPageArguments,
          ),
        );
        break;
      case RatingsPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => RatingsPage(
            arg: arg as RatingsPageArguments,
          ),
        );
        break;
      case HistoryTripSummaryPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              HistoryTripSummaryPage(arg: arg as HistoryPageArguments),
        );
        break;
      case BookingPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => BookingPage(
            arg: arg as BookingPageArguments,
          ),
        );
        break;
      case DeleteAccount.routeName:
        pageRoute =
            MaterialPageRoute(builder: (context) => const DeleteAccount());
        break;
      // animation sliding
      case AccountPage.routeName:
        pageRoute = PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              AccountPage(arg: arg as AccountPageArguments),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final curvedAnimation =
                CurvedAnimation(parent: animation, curve: curve);
            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
        break;
      case EditPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => EditPage(arg: arg as EditPageArguments),
        );
        break;
      case NotificationPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const NotificationPage(),
        );
      case HistoryPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const HistoryPage(),
        );
        break;
      case OutstationHistoryPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => OutstationHistoryPage(
              arg: arg as OutstationHistoryPageArguments
              ),
        );
        break;
      case OutStationOfferedPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => OutStationOfferedPage(
              args: arg as OutStationOfferedPageArguments),
        );
        break;
      case ReferralPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ReferralPage(
            args: arg as ReferralArguments,
          ),
        );
        break;
      case ComplaintListPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ComplaintListPage(
            args: arg as ComplaintListPageArguments,
          ),
        );
        break;
      case ComplaintPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ComplaintPage(
            arg: arg as ComplaintPageArguments,
          ),
        );
        break;
      case UpdateDetails.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => UpdateDetails(
            arg: arg as UpdateDetailsArguments,
          ),
        );
        break;
      case SettingsPage.routeName:
        pageRoute =
            MaterialPageRoute(builder: (context) => const SettingsPage());
        break;
      case FaqPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const FaqPage(),
        );
        break;
      case FavoriteLocationPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              FavoriteLocationPage(arg: arg as FavouriteLocationPageArguments),
        );
        break;
      case WalletHistoryPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              WalletHistoryPage(arg: arg as WalletPageArguments),
        );
        break;

      case SosPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => SosPage(arg: arg as SOSPageArguments),
        );
        break;

      case AdminChat.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => AdminChat(arg: arg as AdminChatPageArguments),
        );
        break;
      case ConfirmFavLocation.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ConfirmFavLocation(
            arg: arg as ConfirmFavouriteLocationPageArguments,
          ),
        );
        break;
      case PaymentMethodPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              PaymentMethodPage(arg: arg as PaymentMethodArguments),
        );
        break;

      case PaymentGatwaysPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => PaymentGatwaysPage(
            arg: arg as PaymentGateWayPageArguments,
          ),
        );
        break;

      default:
        pageRoute = MaterialPageRoute(
          builder: (context) => const ErrorPage(),
        );
    }
    return pageRoute;
  }

  static Route<dynamic> onUnknownRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(builder: (context) => const ErrorPage());
  }
}
