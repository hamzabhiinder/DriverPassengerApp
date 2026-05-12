import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_role.dart';

/// Persists the last selected [UserRole] for cold start routing.
class RoleService extends GetxService {
  static const _prefsKey = 'user_role';

  final Rxn<UserRole> currentRole = Rxn<UserRole>();

  Future<RoleService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    currentRole.value = switch (raw) {
      'driver' => UserRole.driver,
      'passenger' => UserRole.passenger,
      _ => null,
    };
    return this;
  }

  Future<void> setRole(UserRole role) async {
    currentRole.value = role;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, role.name);
  }

  Future<void> clearRole() async {
    currentRole.value = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}
