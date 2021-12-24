import 'package:anitrak/src/database/database.dart';
import 'package:anitrak/src/database/media_entry_table.dart';
import 'package:anitrak/src/database/media_table.dart';
import 'package:anitrak/src/models/library_item.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/models/media_model.dart';
import 'package:drift/drift.dart';

part 'media_library_dao.g.dart';

@DriftAccessor(tables: [MediaEntries, Media])
class MediaLibraryDao extends DatabaseAccessor<MyDatabase>
    with _$MediaLibraryDaoMixin {
  MediaLibraryDao(MyDatabase db) : super(db);

  Stream<List<MediaEntry>> getAllMediaEntries() {
    final query = select(mediaEntries)
      ..where((tbl) => tbl.status.equals("CURRENT"))
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    return query.watch();
  }

  Stream<List<MediaEntry>> getMediaEntries(
      {String status = "CURRENT", int limit = 0}) {
    final query = select(mediaEntries)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);

    if (status.isNotEmpty) {
      query.where((tbl) => tbl.status.equals(status));
    }

    if (limit > 0) {
      query.limit(limit);
    }
    return query.watch();
  }

  Stream<List<MediaEntry>> getUnsyncedMediaEntries() {
    final query = select(mediaEntries)
      ..where((tbl) => tbl.synced.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.updatedAt)]);
    return query.watch();
  }

  Future<void> replaceAllEntries(List<MediaEntry> entries) async {
    await delete(mediaEntries).go();
    await batch((batch) {
      // functions in a batch don't have to be awaited - just
      // await the whole batch afterwards.
      batch.insertAll(mediaEntries, entries);
    });
  }

  Future<void> updateMediaEntry(MediaEntry entry) async {
    await update(mediaEntries).replace(entry);
  }

  // Stream<double> getTotalEpisodesWatched(){
  //   final progressExp = mediaEntries.progress.total();
  //   final query = selectOnly(mediaEntries)..addColumns([progressExp]);

  //   final res =  query.map((row) => row.read(progressExp));
  // }

  // ---- Media ----
  Stream<List<MediaModel>> getAllMedia() {
    final query = select(media);
    return query.watch();
  }

  Future<void> replaceAllMedia(List<MediaModel> entries) async {
    await delete(media).go();
    // for(var entry in entries){
    //   await into(media).insert(entry);
    // }
    
    await batch((batch) {
      // functions in a batch don't have to be awaited - just
      // await the whole batch afterwards.
      batch.insertAll(media, entries);
    });
  }

  Future<void> updateMedia(MediaModel entry) async {
    await update(media).replace(entry);
  }

  // ---------------

  Stream<List<LibraryItem>> watchLibraryItems(
      {String status = "CURRENT", int limit = 0}) {
    final query = select(mediaEntries)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);

    if (status.isNotEmpty) {
      query.where((tbl) => tbl.status.equals(status));
    }

    if (limit > 0) {
      query.limit(limit);
    }

    return query
        .join(
          [
            leftOuterJoin(
              media,
              media.id.equalsExp(mediaEntries.media),
            ),
          ],
        )
        .watch()
        .map(
          (rows) => rows.map(
            (row) {
              return LibraryItem(
                mediaEntry: row.readTable(mediaEntries),
                media: row.readTable(media),
              );
            },
          ).toList(),
        );
  }
}
