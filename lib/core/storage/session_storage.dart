import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/domain/entities/mobile_user.dart';

class SessionStorage {
  SessionStorage(this._preferences);

  final SharedPreferences _preferences;

  static const _authUserKey = 'session.auth.user';
  static const _pendingCodesKey = 'session.scan.pending_codes';
  static const _departureNumberKey = 'session.scan.departure_number';
  static const _departureSavedAtKey = 'session.scan.departure_saved_at';

  MobileUser? readUser() {
    final payload = _preferences.getString(_authUserKey);
    if (payload == null) return null;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        return MobileUser.fromJson(decoded);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<void> saveUser(MobileUser user) async {
    await _preferences.setString(_authUserKey, jsonEncode(user.toJson()));
  }

  Future<void> clearUser() async {
    await _preferences.remove(_authUserKey);
  }

  List<String> readPendingScanCodes() {
    return List<String>.from(
      _preferences.getStringList(_pendingCodesKey) ?? const <String>[],
    );
  }

  Future<void> savePendingScanCodes(List<String> codes) async {
    await _preferences.setStringList(_pendingCodesKey, codes);
  }

  Future<void> clearPendingScanCodes() async {
    await _preferences.remove(_pendingCodesKey);
  }

  int? readDepartureNumber() {
    final stored = _preferences.getInt(_departureNumberKey);
    if (stored == null) return null;
    final savedAtMillis = _preferences.getInt(_departureSavedAtKey);
    if (savedAtMillis == null) {
      return null;
    }
    final savedAt =
        DateTime.fromMillisecondsSinceEpoch(savedAtMillis, isUtc: false);
    final now = DateTime.now();
    final currentWindowStart = _departureWindowStart(now);
    if (savedAt.isBefore(currentWindowStart)) {
      return null;
    }
    return stored;
  }

  Future<void> saveDepartureNumber(int number) async {
    await _preferences.setInt(_departureNumberKey, number);
    await _preferences.setInt(
      _departureSavedAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> clearDepartureNumber() async {
    await _preferences.remove(_departureNumberKey);
    await _preferences.remove(_departureSavedAtKey);
  }

  DateTime _departureWindowStart(DateTime reference) {
    final sixAmToday = DateTime(
      reference.year,
      reference.month,
      reference.day,
      6,
    );
    if (reference.isBefore(sixAmToday)) {
      return sixAmToday.subtract(const Duration(days: 1));
    }
    return sixAmToday;
  }

  // Offline submission history removed. History now comes from server only.
}
