import 'package:flutter_web_auth/flutter_web_auth.dart';

class AnilistAuth {
  final String clientId = "6688";
  final String urlScheme = "com.akai.anitrak";

  String _getAuthUrl() {
    return "https://anilist.co/api/v2/oauth/authorize?client_id=$clientId&response_type=token";
  }

  Future<String?> authenticate() async {
    try {
      // Present the dialog to the user
      final result = await FlutterWebAuth.authenticate(
          url: _getAuthUrl(), callbackUrlScheme: urlScheme);
      final decoded = Uri.decodeFull(result).replaceAll('#', '?');
      final uri = Uri.parse(decoded);
      final token = uri.queryParameters['access_token'];
      return token;
    } catch (e) {
      print(e.toString());
    }
  }
}
