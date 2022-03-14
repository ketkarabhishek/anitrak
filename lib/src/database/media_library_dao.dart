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
      ..where((tbl) => tbl.status.equals(1))
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    return query.watch();
  }

  Stream<List<MediaEntry>> getMediaEntries(
      {MediaEntryStatus status = MediaEntryStatus.watching, int limit = 0}) {
    final query = select(mediaEntries)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
      ..where((tbl) => tbl.status.equals(status.index));

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

  Future<MediaEntry?> getMediaEntry(
      {int alMediaId = 0, int malMediaId = 0}) async {
    final mediaQuery = select(media)..limit(1);

    if (alMediaId != 0) {
      mediaQuery.where((tbl) => tbl.alMediaId.equals(alMediaId));
    }

    if (malMediaId != 0) {
      mediaQuery.where((tbl) => tbl.malMediaId.equals(malMediaId));
    }

    final row = await mediaQuery.join([
      leftOuterJoin(
        mediaEntries,
        mediaEntries.media.equalsExp(media.id),
      ),
    ]).getSingleOrNull();

    return row?.readTable(mediaEntries);
  }

  Future<void> insertAllEntries(List<MediaEntry> entries) async {
    await batch((batch) {
      // functions in a batch don't have to be awaited - just
      // await the whole batch afterwards.
      batch.insertAll(mediaEntries, entries);
    });
  }

   Future<void> deleteAllEntries() async {
    await delete(mediaEntries).go();
  }

  Future<void> updateMediaEntry(MediaEntry entry) async {
    await update(mediaEntries).replace(entry);
  }

  Future<void> insertMediaEntry(MediaEntry entry) async {
    await into(mediaEntries).insert(entry);
  }

  Stream<double?> getTotalEpisodesWatched() {
    final progressExp = mediaEntries.progress.total();
    final query = selectOnly(mediaEntries)..addColumns([progressExp]);

    return query.map((row) => row.read(progressExp)).watchSingle();
  }

  // ---- Media ----
  Stream<List<MediaModel>> getAllMedia() {
    final query = select(media);
    return query.watch();
  }

  Future<MediaModel> getMedia({
    required String id,
  }) async {
    final query = select(media);
    if (id.isNotEmpty) {
      query.where((tbl) => tbl.id.equals(id));
    }
    return query.getSingle();
  }

  Future<void> insertAllMedia(List<MediaModel> entries) async {
    await batch((batch) {
      // functions in a batch don't have to be awaited - just
      // await the whole batch afterwards.
      batch.insertAll(media, entries);
    });
  }

  Future<void> deleteAllMedia() async {
    await delete(media).go();
  }

  Future<void> updateMedia(MediaModel entry) async {
    await update(media).replace(entry);
  }

  Future<void> insertMedia(MediaModel entry) async {
    await into(media).insert(entry);
  }

  // ---------------

  Stream<List<LibraryItem>> watchLibraryItems(
      {MediaEntryStatus? status = MediaEntryStatus.watching, int? limit}) {
    final query = select(mediaEntries)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);

    if (status != null) {
      query.where((tbl) => tbl.status.equals(status.index));
    }

    if (limit != null && limit > 0) {
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

  Future<LibraryItem> getLibraryItem({required String mediaEntryId}) async {
    final query = select(mediaEntries)
      ..where((tbl) => tbl.id.equals(mediaEntryId));

    final row = await query.join(
      [
        leftOuterJoin(
          media,
          media.id.equalsExp(mediaEntries.media),
        ),
      ],
    ).getSingle();

    return LibraryItem(
      mediaEntry: row.readTable(mediaEntries),
      media: row.readTable(media),
    );
  }
}
