import 'package:anitrak/src/database/media_library_dao.dart';
import 'package:anitrak/src/models/library_item.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/models/media_model.dart';
import 'package:anitrak/src/services/anilist/anilist_client.dart';

class MediaLibraryRepo {
  MediaLibraryRepo({
    required this.mediaLibraryDao,
    required this.client,
  });

  final MediaLibraryDao mediaLibraryDao;

  final AnilistClient client;

  // ====DB====
  // MediaEntry
  Stream<List<MediaEntry>> getAllMediaEntries() { 
    return mediaLibraryDao.getAllMediaEntries();
  }

  Stream<List<MediaEntry>> getMediaEntries({String status = "CURRENT", int limit = 0}) {
    return mediaLibraryDao.getMediaEntries(status: status, limit: limit);
  }

  Stream<List<MediaEntry>> getUnsyncedMediaEntries() {
    return mediaLibraryDao.getUnsyncedMediaEntries();
  }

  Future<MediaEntry?> getMediaEntry({int alMediaId = 0, int malMediaId = 0}){
    return mediaLibraryDao.getMediaEntry(alMediaId: alMediaId, malMediaId: malMediaId);
  }

  Future<void> updateMediaEntry(MediaEntry entry) async {
    await mediaLibraryDao.updateMediaEntry(entry);
  }

   Future<void> replaceAllMediaEntries(List<MediaEntry> mediaList) async{
    await mediaLibraryDao.replaceAllEntries(mediaList);
  }

  // Media
  Future<void> replaceAllMedia(List<MediaModel> mediaList) async{
    await mediaLibraryDao.replaceAllMedia(mediaList);
  }

  Future<MediaModel> getMedia({required String id}) async {
    return mediaLibraryDao.getMedia(id: id);
  }

  // Library Item
  Stream<List<LibraryItem>> getLibraryStream({String status = "CURRENT", int limit = 0}) {
    return mediaLibraryDao.watchLibraryItems(status: status, limit: limit);
  }

  Future<void> insertLibraryItem(LibraryItem item) async {
    await mediaLibraryDao.insertMedia(item.media);
    await mediaLibraryDao.insertMediaEntry(item.mediaEntry);
  }

  // ====Anilist====
  Future<int> saveAnilistEntry(MediaEntry entry, {required int mediaId}) async {
    final varMap = entry.toAnilistMap(mediaId: mediaId);
    return client.saveMediaListEntry(varMap);
  }

  Future<List<dynamic>> getUserMediaList(String userId) async {
    final json = await client.getMediaListCollection(int.parse(userId), "ANIME");
    final lists = json['lists'] as List;
    final filteredList =
        lists.where((element) => !element['isCustomList']).toList();
    final reducedList = filteredList.map((e){
      return e['entries'] as List;
    })
    .toList()
    .reduce((value, element) => value + element);
    return reducedList;
  }
  
  Future<List<MediaModel>> getAnilistMedia({String? search}) async {
    final json = await client.getMedia(search: search);
    final jsonList = json["media"] as List;
    return jsonList.map((e) => MediaModel.fromAnilistJson(e)).toList();
  }

}
