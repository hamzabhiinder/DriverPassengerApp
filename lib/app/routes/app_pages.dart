import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../modules/chat/ride_chat_view.dart';
import '../modules/driver_accept_ride/screen/going_to_pickup.dart';
import '../modules/driver_account/driver_account_view.dart';
import '../modules/driver_documents/driver_documents_view.dart';
import '../modules/driver_earnings/driver_earnings_view.dart';
import '../modules/driver_home/driver_home_binding.dart';
import '../modules/driver_home/driver_home_view.dart';
import '../modules/driver_login/binding/driver_login_binding.dart'
    show DriverLoginBinding;
import '../modules/driver_login/screen/driver_login.dart';
import '../modules/driver_new_ride_request/screen/driver_new_ride_request.dart';
import '../modules/driver_notifications/driver_notifications_view.dart';
import '../modules/driver_performance/driver_performance_view.dart';
import '../modules/driver_settings/driver_settings_view.dart';
import '../modules/driver_support/driver_support_view.dart';
import '../modules/driver_trip_complete/screen/trip_completed.dart';
import '../modules/driver_trips/driver_trips_view.dart';
import '../modules/driver_vehicle/driver_vehicle_view.dart';
import '../modules/driver_wallet/driver_wallet_view.dart';
import '../modules/passenger_account/passenger_account_view.dart';
import '../modules/passenger_cards/passenger_cards_view.dart';
import '../modules/passenger_history/passenger_history_view.dart';
import '../modules/passenger_home/passenger_home_binding.dart';
import '../modules/passenger_notifications/passenger_notifications_view.dart';
import '../modules/passenger_scheduled/passenger_scheduled_view.dart';
import '../modules/passenger_support/passenger_support_view.dart';
import '../modules/passenger_terms/passenger_terms_view.dart';
import '../modules/passenger_trip_options/passenger_trip_options_view.dart';
import '../modules/passenger_wallet/passenger_wallet_view.dart';
import '../modules/passenger_home/passenger_home_view.dart';
import '../modules/passenger_chauffeur_assigned/binding/passenger_chauffeur_assigned_binding.dart';
import '../modules/passenger_chauffeur_assigned/screen/passenger_chauffeur_assigned_screen.dart';
import '../modules/passenger_payment_summary/binding/passenger_payment_summary_binding.dart';
import '../modules/passenger_payment_summary/screen/passenger_payment_summary_screen.dart';
import '../modules/passenger_places/passenger_places_views.dart';
import '../modules/passenger_rate_ride/binding/passenger_rate_ride_binding.dart';
import '../modules/passenger_rate_ride/screen/passenger_rate_ride_screen.dart';
import '../modules/passenger_confirm_ride/binding/passenger_confirm_ride_binding.dart';
import '../modules/passenger_confirm_ride/screen/passenger_confirm_ride_screen.dart';
import '../modules/passenger_select_vehicle/binding/passenger_select_vehicle_binding.dart';
import '../modules/passenger_select_vehicle/screen/passenger_select_vehicle_screen.dart';
import '../modules/passenger_where_to/binding/passenger_where_to_binding.dart';
import '../modules/passenger_where_to/screen/passenger_where_to_screen.dart';
import '../modules/passenger_create_profile/binding/passenger_create_profile_binding.dart';
import '../modules/passenger_create_profile/screen/passenger_create_profile_screen.dart';
import '../modules/passenger_login/binding/passenger_login_binding.dart';
import '../modules/passenger_login/binding/passenger_otp_binding.dart';
import '../modules/passenger_login/screen/passenger_login_view.dart';
import '../modules/passenger_login/screen/passenger_otp_screen.dart';
import '../modules/role_select/role_select_binding.dart';
import '../modules/role_select/role_select_view.dart';
import '../modules/splash/binding/splash_binding.dart';
import '../modules/splash/view/splash_view.dart';
import 'app_routes.dart';

GetPage<void> _putPage<T extends GetxController>({
  required String name,
  required T Function() controller,
  required Widget Function() page,
}) {
  return GetPage<void>(
    name: name,
    page: () {
      Get.put<T>(controller());
      return page();
    },
  );
}

abstract final class AppPages {
  static final routes = <GetPage<dynamic>>[
    GetPage<void>(
      name: AppRoutes.splash,
      page: SplashView.new,
      binding: SplashBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.roleSelect,
      page: RoleSelectView.new,
      binding: RoleSelectBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.driverLogin,
      page: DriverLoginView.new,
      binding: DriverLoginBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.driverHome,
      page: DriverHomeView.new,
      binding: DriverHomeBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.driverNewRideRequest,
      page: NewRideRequestView.new,
    ),
    GetPage<void>(
      name: AppRoutes.driverGoingToPickup,
      page: GoingToPickupView.new,
    ),
    GetPage<void>(
      name: AppRoutes.driverTripCompleted,
      page: TripCompletedView.new,
    ),
    _putPage(
      name: AppRoutes.driverTrips,
      controller: DriverTripsController.new,
      page: () => const DriverTripsView(),
    ),
    _putPage(
      name: AppRoutes.driverEarnings,
      controller: DriverEarningsController.new,
      page: () => const DriverEarningsView(),
    ),
    _putPage(
      name: AppRoutes.driverAccount,
      controller: DriverAccountController.new,
      page: () => const DriverAccountView(),
    ),
    _putPage(
      name: AppRoutes.driverDocuments,
      controller: DriverDocumentsController.new,
      page: () => const DriverDocumentsView(),
    ),
    _putPage(
      name: AppRoutes.driverNotifications,
      controller: DriverNotificationsController.new,
      page: () => const DriverNotificationsView(),
    ),
    _putPage(
      name: AppRoutes.driverSupport,
      controller: DriverSupportController.new,
      page: () => const DriverSupportView(),
    ),
    _putPage(
      name: AppRoutes.driverWallet,
      controller: DriverWalletController.new,
      page: () => const DriverWalletView(),
    ),
    _putPage(
      name: AppRoutes.driverPerformance,
      controller: DriverPerformanceController.new,
      page: () => const DriverPerformanceView(),
    ),
    _putPage(
      name: AppRoutes.driverSettings,
      controller: DriverSettingsController.new,
      page: () => const DriverSettingsView(),
    ),
    _putPage(
      name: AppRoutes.driverVehicle,
      controller: DriverVehicleController.new,
      page: () => const DriverVehicleView(),
    ),
    _putPage(
      name: AppRoutes.rideChat,
      controller: RideChatController.new,
      page: () => const RideChatView(),
    ),
    _putPage(
      name: AppRoutes.passengerSchedule,
      controller: PassengerScheduleController.new,
      page: () => const PassengerScheduleView(),
    ),
    _putPage(
      name: AppRoutes.passengerSavedPlaces,
      controller: PassengerSavedPlacesController.new,
      page: () => const PassengerSavedPlacesView(),
    ),
    _putPage(
      name: AppRoutes.passengerNotifications,
      controller: PassengerNotificationsController.new,
      page: () => const PassengerNotificationsView(),
    ),
    _putPage(
      name: AppRoutes.passengerRideHistory,
      controller: PassengerHistoryController.new,
      page: () => const PassengerHistoryView(),
    ),
    _putPage(
      name: AppRoutes.passengerAccount,
      controller: PassengerAccountController.new,
      page: () => const PassengerAccountView(),
    ),
    _putPage(
      name: AppRoutes.passengerCards,
      controller: PassengerCardsController.new,
      page: () => const PassengerCardsView(),
    ),
    _putPage(
      name: AppRoutes.passengerTerms,
      controller: PassengerTermsController.new,
      page: () => const PassengerTermsView(),
    ),
    _putPage(
      name: AppRoutes.passengerScheduledRides,
      controller: PassengerScheduledController.new,
      page: () => const PassengerScheduledView(),
    ),
    _putPage(
      name: AppRoutes.passengerSupport,
      controller: PassengerSupportController.new,
      page: () => const PassengerSupportView(),
    ),
    _putPage(
      name: AppRoutes.passengerWallet,
      controller: PassengerWalletController.new,
      page: () => const PassengerWalletView(),
    ),
    _putPage(
      name: AppRoutes.passengerTripOptions,
      controller: PassengerTripOptionsController.new,
      page: () => const PassengerTripOptionsView(),
    ),
    GetPage<void>(
      name: AppRoutes.passengerLogin,
      page: PassengerLoginView.new,
      binding: PassengerLoginBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.passengerOtpScreen,
      page: PassengerOtpScreenView.new,
      binding: PassengerOtpBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.passengerCreateProfile,
      page: PassengerCreateProfileScreen.new,
      binding: PassengerCreateProfileBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.passengerChauffeurAssigned,
      page: PassengerChauffeurAssignedScreen.new,
      binding: PassengerChauffeurAssignedBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.passengerPaymentSummary,
      page: PassengerPaymentSummaryScreen.new,
      binding: PassengerPaymentSummaryBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.passengerRateRide,
      page: PassengerRateRideScreen.new,
      binding: PassengerRateRideBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.passengerConfirmRide,
      page: PassengerConfirmRideScreen.new,
      binding: PassengerConfirmRideBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.passengerSelectVehicle,
      page: PassengerSelectVehicleScreen.new,
      binding: PassengerSelectVehicleBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.passengerWhereTo,
      page: PassengerWhereToScreen.new,
      binding: PassengerWhereToBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.passengerHome,
      page: PassengerHomeView.new,
      binding: PassengerHomeBinding(),
    ),
  ];
}
