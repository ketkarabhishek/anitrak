import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepo {
  //Anilist store Keys
  final String _anilistAccessTokenKey = "anilist_access_token";
  final String _anilistRefreshTokenKey = "anilist_refresh_token";
  final String _anilistExpiresInKey = "anilist_expires_in";
  final String _anilistUserIdKey = "anilist_user_id";
  final String _anilistUserNameKey = "anilist_user_name";
  final String _anilistAvatarKey = "anilist_avatar";
  final String _anilistSyncKey = "anilist_sync";

  //Kitsu store Keys
  final String _kitsuAccessTokenKey = "kitsu_access_token";
  final String _kitsuRefreshTokenKey = "kitsu_refresh_token";
  final String _kitsuExpiresInKey = "kitsu_expires_in";
  final String _kitsuUserIdKey = "kitsu_user_id";
  final String _kitsuUserNameKey = "kitsu_user_name";
  final String _kitsuAvatarKey = "kitsu_avatar";
  final String _kitsuSyncKey = "kitsu_sync";

  // Anilist JSON Keys
  final String _jsonAccessTokenKey = "access_token";
  final String _jsonRefreshTokenKey = "refresh_token";
  final String _jsonExpiresInKey = "expires_in";

  // First time
  static const _firstTime = "first_time";

  static const String mappingRefreshDate = "mapping_date";

  final _storage = const FlutterSecureStorage();

  Future<bool?> get firstTime async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstTime);
  }

  void setFirstTime(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTime, value);
  }

  // Mapping

  Future<String?> get mappingDate async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(mappingRefreshDate);
  }

  void setMappingDate(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(mappingRefreshDate, value);
  }

  // Anilist=================
  Future<String?> get anilistAccessToken async {
    return await _storage.read(key: _anilistAccessTokenKey);
  }

  Future<String?> get anilistRefreshToken async {
    return await _storage.read(key: _anilistRefreshTokenKey);
  }

  Future<String?> get anilistExpiresIn async {
    return await _storage.read(key: _anilistExpiresInKey);
  }

  Future<String?> get anilistUserId async {
    return await _storage.read(key: _anilistUserIdKey);
  }

  Future<String?> get anilistUserName async {
    return await _storage.read(key: _anilistUserNameKey);
  }

  Future<String?> get anilistAvatar async {
    return await _storage.read(key: _anilistAvatarKey);
  }

  Future<bool?> get anilistSync async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_anilistSyncKey);
  }

  void setSync(bool newSync) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_anilistSyncKey, newSync);
  }

  Future<void> saveAnilistToken(Map<String, dynamic> tokenMap) async {
    await _storage.write(
        key: _anilistAccessTokenKey, value: tokenMap[_jsonAccessTokenKey]);
    await _storage.write(
        key: _anilistRefreshTokenKey, value: tokenMap[_jsonRefreshTokenKey]);
    final expiresIn = DateTime.now()
        .add(Duration(seconds: tokenMap[_jsonExpiresInKey]))
        .subtract(const Duration(days: 7))
        .toIso8601String();
    await _storage.write(key: _anilistExpiresInKey, value: expiresIn);
  }

  Future<void> saveAnilistUserData(
      {required String userId,
      required String userName,
      required String avatar}) async {
    await _storage.write(key: _anilistUserIdKey, value: userId);
    await _storage.write(key: _anilistUserNameKey, value: userName);
    await _storage.write(key: _anilistAvatarKey, value: avatar);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_anilistSyncKey, false);
  }

  Future<void> deleteAnilistToken() async {
    await _storage.delete(key: _anilistAccessTokenKey);
    await _storage.delete(key: _anilistRefreshTokenKey);
    await _storage.delete(key: _anilistExpiresInKey);
  }

  // Kitsu ========================
  Future<String?> get kitsuAccessToken async {
    return await _storage.read(key: _kitsuAccessTokenKey);
  }

  Future<String?> get kitsuRefreshToken async {
    return await _storage.read(key: _kitsuRefreshTokenKey);
  }

  Future<String?> get kitsuExpiresIn async {
    return await _storage.read(key: _kitsuExpiresInKey);
  }

  Future<String?> get kitsuUserId async {
    return await _storage.read(key: _kitsuUserIdKey);
  }

  Future<String?> get kitsuUserName async {
    return await _storage.read(key: _kitsuUserNameKey);
  }

  Future<String?> get kitsuAvatar async {
    return await _storage.read(key: _kitsuAvatarKey);
  }

  Future<bool?> get kitsuSync async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kitsuSyncKey);
  }

  void setKitsuSync(bool newSync) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kitsuSyncKey, newSync);
  }

  Future<void> saveKitsuToken(Map<String, dynamic> tokenMap) async {
    await _storage.write(
        key: _kitsuAccessTokenKey, value: tokenMap[_jsonAccessTokenKey]);
    await _storage.write(
        key: _kitsuRefreshTokenKey, value: tokenMap[_jsonRefreshTokenKey]);
    final expiresIn = DateTime.now()
        .add(Duration(seconds: tokenMap[_jsonExpiresInKey]))
        .subtract(const Duration(days: 7))
        .toIso8601String();
    await _storage.write(key: _kitsuExpiresInKey, value: expiresIn);
  }

  Future<void> saveKitsuUserData(
      {required String userId,
      required String userName,
      required String avatar}) async {
    await _storage.write(key: _kitsuUserIdKey, value: userId);
    await _storage.write(key: _kitsuUserNameKey, value: userName);
    await _storage.write(key: _kitsuAvatarKey, value: avatar);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kitsuSyncKey, false);
  }

  Future<void> deleteKitsuToken() async {
    await _storage.delete(key: _kitsuAccessTokenKey);
    await _storage.delete(key: _kitsuRefreshTokenKey);
    await _storage.delete(key: _kitsuExpiresInKey);
  }
}
