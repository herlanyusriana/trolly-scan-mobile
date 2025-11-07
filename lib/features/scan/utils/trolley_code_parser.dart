import 'dart:convert';

String? parseTrolleyCode(String? raw) {
  if (raw == null) {
    return null;
  }

  final trimmed = raw.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  if (trimmed.startsWith('{')) {
    try {
      final decoded = json.decode(trimmed);
      if (decoded is Map<String, dynamic>) {
        final code = decoded['code'];
        if (code is String && code.trim().isNotEmpty) {
          return code.trim().toUpperCase();
        }
      }
    } catch (_) {
      // Fallback to original value below.
    }
  }

  return trimmed.toUpperCase();
}
