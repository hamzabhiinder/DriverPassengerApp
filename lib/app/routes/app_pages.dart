import 'package:get/get.dart';

import '../modules/driver_home/driver_home_binding.dart';
import '../modules/driver_home/driver_home_view.dart';
import '../modules/passenger_home/passenger_home_binding.dart';
import '../modules/passenger_home/passenger_home_view.dart';
import '../modules/passenger_chauffeur_assigned/binding/passenger_chauffeur_assigned_binding.dart';
import '../modules/passenger_chauffeur_assigned/screen/passenger_chauffeur_assigned_screen.dart';
import '../modules/passenger_confirm_ride/binding/passenger_confirm_ride_binding.dart';
import '../modules/passenger_confirm_ride/screen/passenger_confirm_ride_screen.dart';
import '../modules/passenger_select_vehicle/binding/passenger_select_vehicle_binding.dart';
import '../modules/passenger_select_vehicle/screen/passenger_select_vehicle_screen.dart';
import '../modules/passenger_where_to/binding/passenger_where_to_binding.dart';
import '../modules/passenger_where_to/screen/passenger_where_to_screen.dart';
import '../modules/passenger_login/binding/passenger_login_binding.dart';
import '../modules/passenger_login/binding/passenger_otp_binding.dart';
import '../modules/passenger_login/screen/passenger_login_view.dart';
import '../modules/passenger_login/screen/passenger_otp_screen.dart';
import '../modules/role_select/role_select_binding.dart';
import '../modules/role_select/role_select_view.dart';
import '../modules/splash/binding/splash_binding.dart';
import '../modules/splash/view/splash_view.dart';
import 'app_routes.dart';

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
      name: AppRoutes.driverHome,
      page: DriverHomeView.new,
      binding: DriverHomeBinding(),
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
      name: AppRoutes.passengerChauffeurAssigned,
      page: PassengerChauffeurAssignedScreen.new,
      binding: PassengerChauffeurAssignedBinding(),
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
