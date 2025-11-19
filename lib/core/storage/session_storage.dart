import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/domain/entities/mobile_user.dart';
import '../../features/scan/domain/entities/trolley_submission.dart';

class SessionStorage {
  SessionStorage(this._preferences);

  final SharedPreferences _preferences;

  static const _authUserKey = 'session.auth.user';
  static const _pendingCodesKey = 'session.scan.pending_codes';
  static const _submissionHistoryKey = 'session.scan.history';
  static const _departureNumberKey = 'session.scan.departure_number';

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
    return _preferences.getInt(_departureNumberKey);
  }

  Future<void> saveDepartureNumber(int number) async {
    await _preferences.setInt(_departureNumberKey, number);
  }

  Future<void> clearDepartureNumber() async {
    await _preferences.remove(_departureNumberKey);
  }

  List<TrolleySubmission> readSubmissionHistory() {
    final payload = _preferences.getString(_submissionHistoryKey);
    if (payload == null) return const <TrolleySubmission>[];
    try {
      final decoded = jsonDecode(payload);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(TrolleySubmission.fromJson)
            .toList();
      }
    } catch (_) {
      return const <TrolleySubmission>[];
    }
    return const <TrolleySubmission>[];
  }

  Future<void> prependSubmission(
    TrolleySubmission submission, {
    int maxItems = 20,
  }) async {
    final history = readSubmissionHistory();
    final updated = [submission, ...history].take(maxItems).toList();
    final encoded = jsonEncode(
      updated.map((submission) => submission.toJson()).toList(),
    );
    await _preferences.setString(_submissionHistoryKey, encoded);
  }
}
