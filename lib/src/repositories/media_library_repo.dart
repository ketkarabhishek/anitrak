import 'package:anitrak/src/database/library_update_dao.dart';
import 'package:anitrak/src/database/media_library_dao.dart';
import 'package:anitrak/src/models/library_item.dart';
import 'package:anitrak/src/models/library_update.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/models/media_model.dart';
import 'package:anitrak/src/services/anilist/anilist_client.dart';

class MediaLibraryRepo {
  MediaLibraryRepo({
    required this.mediaLibraryDao,
    required this.libraryUpdateDao,
    required this.client,
  });

  final MediaLibraryDao mediaLibraryDao;
  final LibraryUpdateDao libraryUpdateDao;

  final AnilistClient client;

  // ====DB====
  // MediaEntry
  Stream<List<MediaEntry>> getAllMediaEntries() {
    return mediaLibraryDao.getAllMediaEntries();
  }

  Stream<List<MediaEntry>> getMediaEntries(
      {String status = "CURRENT", int limit = 0}) {
    return mediaLibraryDao.getMediaEntries(status: status, limit: limit);
  }

  Stream<List<MediaEntry>> getUnsyncedMediaEntries() {
    return mediaLibraryDao.getUnsyncedMediaEntries();
  }

  Future<MediaEntry?> getMediaEntry({int alMediaId = 0, int malMediaId = 0}) {
    return mediaLibraryDao.getMediaEntry(
        alMediaId: alMediaId, malMediaId: malMediaId);
  }

  Future<void> updateMediaEntry(MediaEntry entry) async {
    await mediaLibraryDao.updateMediaEntry(entry);
    final update =
        LibraryUpdate.createNewUpdate(LibraryUpdateType.update, entry.id);
    libraryUpdateDao.insertLibraryUpdate(update);
  }

  Future<void> insertAllMediaEntries(List<MediaEntry> mediaList) async {
    await mediaLibraryDao.insertAllEntries(mediaList);
  }

  // Media
  Future<void> insertAllMedia(List<MediaModel> mediaList) async {
    await mediaLibraryDao.insertAllMedia(mediaList);
  }

  Future<MediaModel> getMedia({required String id}) async {
    return mediaLibraryDao.getMedia(id: id);
  }

  // Library Item
  Stream<List<LibraryItem>> getLibraryStream(
      {String? status, int? limit}) {
    return mediaLibraryDao.watchLibraryItems(status: status, limit: limit);
  }

  Future<void> insertLibraryItem(LibraryItem item) async {
    await mediaLibraryDao.insertMedia(item.media);
    await mediaLibraryDao.insertMediaEntry(item.mediaEntry);
    final update = LibraryUpdate.createNewUpdate(
        LibraryUpdateType.create, item.mediaEntry.id);
    libraryUpdateDao.insertLibraryUpdate(update);
  }

  Future<LibraryItem> getLibraryItem({required String mediaEntryId}) async {
    return mediaLibraryDao.getLibraryItem(mediaEntryId: mediaEntryId);
  }

  Future<void> deleteLibrary() async {
    await libraryUpdateDao.deleteAllLibraryUpdates();
    await mediaLibraryDao.deleteAllEntries();
    await mediaLibraryDao.deleteAllMedia();
  }  

  // Library Update
  Stream<List<LibraryUpdate>> getLibraryUpdates({
    LibraryUpdateType type = LibraryUpdateType.update,
    bool? anilist,
    bool? kitsu,
    bool? mal,
  }) {
    return libraryUpdateDao.getLibraryUpdates(
      type: type.index,
      anilist: anilist,
      kitsu: kitsu,
      mal: mal,
    );
  }

  Future<void> updateLibraryUpdate(LibraryUpdate entry) async {
    await libraryUpdateDao.updateLibraryUpdate(entry);
  }

  // ====Online====
  // Anilist
  Future<int> saveAnilistEntry(MediaEntry entry, {required int mediaId}) async {
    final varMap = entry.toAnilistMap(mediaId: mediaId);
    return client.saveMediaListEntry(varMap);
  }

  Future<List<dynamic>> getUserMediaList(String userId) async {
    final json =
        await client.getMediaListCollection(int.parse(userId), "ANIME");
    final lists = json['lists'] as List;
    final filteredList =
        lists.where((element) => !element['isCustomList']).toList();
    final reducedList = filteredList
        .map((e) {
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
