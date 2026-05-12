import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:driver_passenger_app/app/app.dart';
import 'package:driver_passenger_app/app/data/services/role_service.dart';
import 'package:driver_passenger_app/app/modules/splash/constants/splash_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    Get.reset();
    await Get.putAsync<RoleService>(() => RoleService().init(), permanent: true);
  });

  tearDown(Get.reset);

  testWidgets('Splash shows headline and CTA', (WidgetTester tester) async {
    await tester.pumpWidget(const DriverPassengerApp());
    await tester.pump();
    await tester.pump(SplashConstants.blackIntroDuration);
    await tester.pump(SplashConstants.premiumFadeDuration);
    await tester.pump();
    expect(find.text(SplashConstants.headlineLine1), findsOneWidget);
    expect(find.text(SplashConstants.headlineLine2), findsOneWidget);
    expect(find.text(SplashConstants.ctaLabel), findsOneWidget);
  });
}
