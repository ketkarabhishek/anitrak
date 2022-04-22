import 'package:anitrak/src/services/anilist/anilist_client.dart';
import 'package:anitrak/src/services/anilist/auth.dart';
import 'package:anitrak/src/services/kitsu/kitsu.dart';

class AccountsRepo{
  AccountsRepo({required this.anilistClient, required this.kitsuClient});

  final AnilistClient anilistClient;

  final Kitsu kitsuClient;

  final _anilistAuth = AnilistAuth();

  // Anilist
  Future<Map<String, dynamic>> anilistLogin() async {
    final authTokenMap = await _anilistAuth.authenticate();
    return authTokenMap;
  }

  Future<Map<String, dynamic>> fetchAnilistUserData() async {
    final userData = await anilistClient.getCurrentUserData();
    return userData;
  }

  // Kitsu
  Future<Map<String, dynamic>> kitsuLogin({required String userName, required String password}) async {
    final authTokenMap = await Kitsu.authenticate(userName: userName, password: password);
    return authTokenMap;
  }

  Future<Map<String, dynamic>> fetchKitsuUserData() async {
    final userData = await kitsuClient.getCurrentUserData();
    return {
      'userId': userData['id'],
      'userName': userData['slug'],
      'avatar': userData['avatarImage']['original']['url']
    };
  }

}