import 'package:get/get.dart';

import '../modules/driver_home/driver_home_binding.dart';
import '../modules/driver_home/driver_home_view.dart';
import '../modules/passenger_home/passenger_home_binding.dart';
import '../modules/passenger_home/passenger_home_view.dart';
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
      name: AppRoutes.passengerHome,
      page: PassengerHomeView.new,
      binding: PassengerHomeBinding(),
    ),
  ];
}
