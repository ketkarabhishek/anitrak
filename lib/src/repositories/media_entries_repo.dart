import 'package:anitrak/src/database/media_entry_dao.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/services/anilist/anilist_client.dart';

class MediaEntriesRepo {
  MediaEntriesRepo({
    required this.mediaEntriesDao,
    required this.client
  });

  final MediaEntriesDao mediaEntriesDao;

  final AnilistClient client;

  Stream<List<MediaEntry>> getAllMediaEntries() { 
    return mediaEntriesDao.getAllMediaEntries();
  }

  Stream<List<MediaEntry>> getMediaEntries({String status = "CURRENT", int limit = 0}) {
    return mediaEntriesDao.getMediaEntries(status: status, limit: limit);
  }

  Stream<List<MediaEntry>> getUnsyncedMediaEntries() {
    return mediaEntriesDao.getUnsyncedMediaEntries();
  }

  Future<void> updateMediaEntry(MediaEntry entry) async {
    await mediaEntriesDao.updateMediaEntry(entry);
  }

  Future<void> updateAnilistEntry(MediaEntry entry) async {
    final varMap = entry.toAnilistMap();
    await client.saveMediaListEntry(varMap);
  }

  Future<void> importAnilistLibrary() async {
    final json = await client.getMediaListCollection(561580, "ANIME");
    final lists = json['lists'] as List;
    final filteredList =
        lists.where((element) => !element['isCustomList']).toList();
    final mediaLists = filteredList
        .map<List<MediaEntry>>((e) {
          final l = e['entries'] as List;
          return l
              .map<MediaEntry>((e) => MediaEntry.fromAnilistJson(e))
              .toList();
        })
        .toList()
        .reduce((value, element) => value + element);
    await mediaEntriesDao.replaceAllEntries(mediaLists);
    return;
  }
}
