import 'package:anitrak/src/services/anilist/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountsRepo{
  //Anilist store Keys
  final String _anilistAccessTokenKey = "anilist_access_token";
  final String _anilistRefreshTokenKey = "anilist_refresh_token";
  final String _anilistExpiresInKey = "anilist_expires_in";

  // Anilist JSON Keys
  final String _anilistJsonAccessTokenKey = "access_token";
  final String _anilistJsonRefreshTokenKey = "refresh_token";
  final String _anilistJsonExpiresInKey = "expires_in";

  final _anilistAuth = AnilistAuth();
  final _storage = const FlutterSecureStorage();

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

  Future<Map<String, dynamic>> anilistLogin() async {
    final authTokenMap = await _anilistAuth.authenticate();
    return authTokenMap;
  }

  Future<void> saveAnilistToken(Map<String, dynamic> tokenMap) async {
    await _storage.write(key: _anilistAccessTokenKey, value: tokenMap[_anilistJsonAccessTokenKey]);
    await _storage.write(key: _anilistRefreshTokenKey, value: tokenMap[_anilistJsonRefreshTokenKey]);
    final expiresIn = DateTime.now().add(Duration(seconds: tokenMap[_anilistJsonExpiresInKey])).subtract(const Duration(days: 7)).toIso8601String();
    await _storage.write(key: _anilistExpiresInKey, value: expiresIn);
  }
}