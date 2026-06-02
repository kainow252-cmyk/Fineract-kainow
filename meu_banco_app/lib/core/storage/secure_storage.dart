import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyToken = 'fineract_token';
  static const _keyUsername = 'fineract_username';
  static const _keyUserId = 'fineract_user_id';
  static const _keyClientId = 'fineract_client_id';
  static const _keyOfficeId = 'fineract_office_id';
  static const _keyDisplayName = 'fineract_display_name';
  static const _keyAccountId = 'fineract_account_id';

  // ── Token ──────────────────────────────────────────────────────────
  static Future<void> saveToken(String token) =>
      _storage.write(key: _keyToken, value: token);

  static Future<String?> getToken() =>
      _storage.read(key: _keyToken);

  // ── Usuário ────────────────────────────────────────────────────────
  static Future<void> saveUserData({
    required String username,
    required int userId,
    required int clientId,
    required int officeId,
    required String displayName,
    int? accountId,
  }) async {
    await Future.wait([
      _storage.write(key: _keyUsername, value: username),
      _storage.write(key: _keyUserId, value: userId.toString()),
      _storage.write(key: _keyClientId, value: clientId.toString()),
      _storage.write(key: _keyOfficeId, value: officeId.toString()),
      _storage.write(key: _keyDisplayName, value: displayName),
      if (accountId != null)
        _storage.write(key: _keyAccountId, value: accountId.toString()),
    ]);
  }

  static Future<String?> getUsername() =>
      _storage.read(key: _keyUsername);

  static Future<String?> getDisplayName() =>
      _storage.read(key: _keyDisplayName);

  static Future<int?> getUserId() async {
    final v = await _storage.read(key: _keyUserId);
    return v != null ? int.tryParse(v) : null;
  }

  static Future<int?> getClientId() async {
    final v = await _storage.read(key: _keyClientId);
    return v != null ? int.tryParse(v) : null;
  }

  static Future<int?> getAccountId() async {
    final v = await _storage.read(key: _keyAccountId);
    return v != null ? int.tryParse(v) : null;
  }

  // ── Limpeza ────────────────────────────────────────────────────────
  static Future<void> clearAll() => _storage.deleteAll();

  // ── Verificar login ────────────────────────────────────────────────
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
