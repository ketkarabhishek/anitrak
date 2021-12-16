import 'package:anitrak/src/database/database.dart';
import 'package:anitrak/src/database/media_entry_table.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:drift/drift.dart';

part 'media_entry_dao.g.dart';

// the _TodosDaoMixin will be created by drift. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@DriftAccessor(tables: [MediaEntries])
class MediaEntriesDao extends DatabaseAccessor<MyDatabase>
    with _$MediaEntriesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  MediaEntriesDao(MyDatabase db) : super(db);

  Stream<List<MediaEntry>> getAllMediaEntries() {
    final query = select(mediaEntries)
      ..where((tbl) => tbl.status.equals("CURRENT"))
      ..orderBy([
        (t) => OrderingTerm.desc(t.updatedAt)
      ]);
    return query.watch();
  }

  Stream<List<MediaEntry>> getMediaEntries({String status = "CURRENT"}) {
    final query = select(mediaEntries)
      ..where((tbl) => tbl.status.equals(status))
      ..orderBy([
        (t) => OrderingTerm.desc(t.updatedAt)
      ]);
    return query.watch();
  }

  Stream<List<MediaEntry>> getUnsyncedMediaEntries() {
    final query = select(mediaEntries)
      ..where((tbl) => tbl.synced.equals(false))
      ..orderBy([
        (t) => OrderingTerm.asc(t.updatedAt)
      ]);
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
}
