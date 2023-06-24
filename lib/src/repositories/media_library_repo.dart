import 'dart:async';
import 'dart:convert';

import 'package:anitrak/src/database/library_update_dao.dart';
import 'package:anitrak/src/database/media_library_dao.dart';
import 'package:anitrak/src/models/library_item.dart';
import 'package:anitrak/src/models/library_update.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/models/media_mapping.dart';
import 'package:anitrak/src/models/media_model.dart';
import 'package:anitrak/src/services/anilist/anilist_client.dart';
import 'package:anitrak/src/services/anime_offline_db.dart';
import 'package:anitrak/src/services/kitsu/kitsu.dart';
import 'package:flutter/foundation.dart';

class MediaLibraryRepo {
  MediaLibraryRepo({
    required this.mediaLibraryDao,
    required this.libraryUpdateDao,
    required this.anilistClient,
    required this.kitsuClient,
  });

  final MediaLibraryDao mediaLibraryDao;
  final LibraryUpdateDao libraryUpdateDao;

  final AnilistClient anilistClient;
  final Kitsu kitsuClient;

  // ====DB====
  // MediaEntry
  Stream<List<MediaEntry>> getAllMediaEntries() {
    return mediaLibraryDao.getAllMediaEntries();
  }

  Stream<List<MediaEntry>> getMediaEntries(
      {MediaEntryStatus status = MediaEntryStatus.watching, int limit = 0}) {
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
      {MediaEntryStatus? status, int? limit}) {
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

  Future<void> deleteLibraryItem(LibraryItem item) async {
    await libraryUpdateDao.deleteLibraryUpdate(
        mediaEntryId: item.mediaEntry.id);
    await mediaLibraryDao.deleteMediaEntry(mediaEntryId: item.mediaEntry.id);
    await mediaLibraryDao.deleteMedia(mediaId: item.media.id);
    final update = LibraryUpdate.createNewUpdate(
        LibraryUpdateType.delete, item.mediaEntry.id,
        alEntryId: item.mediaEntry.alEntryId,
        kitsuEntryId: item.mediaEntry.kitsuEntryId);
    libraryUpdateDao.insertLibraryUpdate(update);
  }

  // Library Update
  Stream<List<LibraryUpdate>> getLibraryUpdates({
    LibraryUpdateType? type,
    bool? anilist,
    bool? kitsu,
    bool? mal,
  }) {
    return libraryUpdateDao.getLibraryUpdates(
      type: type?.index,
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
  Future<void> saveAnilistEntry(MediaEntry entry,
      {required int mediaId}) async {
    final varMap = entry.toAnilistMap(mediaId: mediaId);
    final id = await anilistClient.saveMediaListEntry(varMap);
    if (entry.alEntryId == 0) {
      final newEntry = entry.copyWith(alEntryId: id);
      await mediaLibraryDao.updateMediaEntry(newEntry);
    }
    return;
  }

  Future<bool> deleteAnilistEntry({required int mediaId}) async {
    final varMap = {'id': mediaId};
    return anilistClient.deleteMediaListEntry(varMap);
  }

  Future<List<dynamic>> getUserMediaList(String userId) async {
    final json =
        await anilistClient.getMediaListCollection(int.parse(userId), "ANIME");
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
    final json = await anilistClient.getMedia(search: search);
    final jsonList = json["media"] as List;
    return jsonList.map((e) => MediaModel.fromAnilistJson(e)).toList();
  }

  // Kitsu
  Future<List<dynamic>> getUserKitsuLibrary(String userId) async {
    final json = await kitsuClient.getLibrary(userId: int.parse(userId));
    return json['nodes'] as List;
  }

  Future<void> createKitsuEntry(MediaEntry entry,
      {required int mediaId}) async {
    final varMap = entry.toKitsuMap(
        mediaId: mediaId, updateType: LibraryUpdateType.create);
    final id = await kitsuClient.createLibraryEntry(varMap);
    if (entry.kitsuEntryId == 0) {
      final newEntry = entry.copyWith(alEntryId: id);
      await mediaLibraryDao.updateMediaEntry(newEntry);
    }
    return;
  }

  Future<void> updateKitsuEntry(MediaEntry entry) async {
    final varMap = entry.toKitsuMap(updateType: LibraryUpdateType.update);
    await kitsuClient.updateLibraryEntry(varMap);
    return;
  }

  Future<bool> deleteKitsuEntry({required int mediaEntryId}) async {
    final varMap = {'id': mediaEntryId};
    final res = await kitsuClient.deleteLibraryEntry(varMap);
    return res == mediaEntryId;
  }

  // Anime Mapping
  Future<void> insertAllMediaMappings(List<MediaMapping> mediaList) async {
    await mediaLibraryDao.insertAllMediaMapping(mediaList);
  }

  Future<void> refreshMediaMappings() async {
    final mappings = await AnimeOffileDB.downloadDbFile();
    final list = await compute(parseMappings, mappings.toString());
    await mediaLibraryDao.insertAllMediaMapping(list);
  }

  Future<MediaMapping> getMediaMapping(int id, String site) {
    return mediaLibraryDao.getMapping(id: id, site: site);
  }

  Future<void> deleteAllMediaMapping() {
    return mediaLibraryDao.deleteAllMappings();
  }
}

List<MediaMapping> parseMappings(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<MediaMapping>((json) => MediaMapping.fromJson(json))
      .toList();
}
