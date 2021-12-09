import 'package:dio/dio.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class AnilistAuth {
  final String _clientId = "6688";
  final String _clientSecret = "HwuvvpKlJrgeRt27t9NtzTISPiQzTEXY7bgLb6CH";
  final String _urlScheme = "com.akai.anitrak";
  final String _callbackUrl = "com.akai.anitrak://login-callback";

  final String _authTokenUrl = 'https://anilist.co/api/v2/oauth/token';

  String _getAuthUrl() {
    return "https://anilist.co/api/v2/oauth/authorize?client_id=$_clientId&redirect_uri=$_callbackUrl&response_type=code";
  }

  Future<Map<String, dynamic>> authenticate() async {
    try {
      final authCode = await _getAuthorizationCode();
      final tokenMap = await _getAccessTokenFromAuthCode(authCode!);
      return tokenMap;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String?> _getAuthorizationCode() async {
    try {
      // Present the dialog to the user
      final result = await FlutterWebAuth.authenticate(
          url: _getAuthUrl(), callbackUrlScheme: _urlScheme);
      final uri = Uri.parse(result);
      final authCode = uri.queryParameters['code'];
      return authCode;
    } catch (e) {
     throw e.toString();
    }
  }

  Future<Map<String, dynamic>> _getAccessTokenFromAuthCode(
      String authCode) async {
    try {
      final response = await Dio().post(
        _authTokenUrl,
        data: {
          'grant_type': 'authorization_code',
          'client_id': _clientId,
          'client_secret': _clientSecret,
          'redirect_uri': _callbackUrl,
          'code': authCode,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw e.toString();
    }
  }
}
