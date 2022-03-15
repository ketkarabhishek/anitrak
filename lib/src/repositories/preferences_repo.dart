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

  // Anilist JSON Keys
  final String _anilistJsonAccessTokenKey = "access_token";
  final String _anilistJsonRefreshTokenKey = "refresh_token";
  final String _anilistJsonExpiresInKey = "expires_in";

  // First time
  final String _firstTime = "first_time";

  final _storage = const FlutterSecureStorage();

  Future<bool?> get firstTime async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstTime);
  }

  // Anilist token getters
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
        key: _anilistAccessTokenKey,
        value: tokenMap[_anilistJsonAccessTokenKey]);
    await _storage.write(
        key: _anilistRefreshTokenKey,
        value: tokenMap[_anilistJsonRefreshTokenKey]);
    final expiresIn = DateTime.now()
        .add(Duration(seconds: tokenMap[_anilistJsonExpiresInKey]))
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

  void setFirstTime(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTime, value);
  }
}
