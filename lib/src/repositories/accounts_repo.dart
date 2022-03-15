import 'package:anitrak/src/services/anilist/anilist_client.dart';
import 'package:anitrak/src/services/anilist/auth.dart';

class AccountsRepo{
  AccountsRepo({required this.anilistClient});

  final AnilistClient anilistClient;

  final _anilistAuth = AnilistAuth();

  Future<Map<String, dynamic>> anilistLogin() async {
    final authTokenMap = await _anilistAuth.authenticate();
    return authTokenMap;
  }

  Future<Map<String, dynamic>> fetchAnilistUserData() async {
    final userData = await anilistClient.getCurrentUserData();
    return userData;
  }
}