import 'package:anitrak/src/database/database.dart';
import 'package:anitrak/src/database/library_update_table.dart';
import 'package:anitrak/src/models/library_update.dart';
import 'package:drift/drift.dart';

part 'library_update_dao.g.dart';

@DriftAccessor(tables: [LibraryUpdates])
class LibraryUpdateDao extends DatabaseAccessor<MyDatabase>
    with _$LibraryUpdateDaoMixin {
  LibraryUpdateDao(MyDatabase db) : super(db);

  Stream<List<LibraryUpdate>> getLibraryUpdates(
      {int? type, bool? anilist, bool? kitsu, bool? mal}) {
    final query = select(libraryUpdates);
    if (anilist != null) {
      query.where((tbl) => tbl.anilist.equals(anilist));
    }
    if (kitsu != null) {
      query.where((tbl) => tbl.kitsu.equals(kitsu));
    }
    if (mal != null) {
      query.where((tbl) => tbl.mal.equals(mal));
    }

    if (type != null) {
      query.where((tbl) => tbl.type.equals(type));
    }

    return query.watch();
  }

  Future<void> insertLibraryUpdate(LibraryUpdate entry) async {
    await into(libraryUpdates).insert(entry);
  }

  Future<void> updateLibraryUpdate(LibraryUpdate entry) async {
    await update(libraryUpdates).replace(entry);
  }

  Future<void> deleteAllLibraryUpdates() async {
    await delete(libraryUpdates).go();
  }

  Future<void> deleteLibraryUpdate({required String mediaEntryId}) async {
    final query = delete(libraryUpdates)
      ..where((tbl) => tbl.mediaEntryId.equals(mediaEntryId));
    await query.go();
  }
}
