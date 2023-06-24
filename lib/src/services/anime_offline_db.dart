import 'package:dio/dio.dart';

class AnimeOffileDB {
  static Future<dynamic> downloadDbFile() async {
    final res = await Dio().get(
        "https://raw.githubusercontent.com/Fribb/anime-lists/master/anime-offline-database-reduced.json");
    return res.data;
  }
}
