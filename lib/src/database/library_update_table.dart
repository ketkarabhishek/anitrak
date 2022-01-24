import 'package:anitrak/src/database/media_entry_table.dart';
import 'package:anitrak/src/models/library_update.dart';
import 'package:drift/drift.dart';

@UseRowClass(LibraryUpdate)
class LibraryUpdates extends Table{
  TextColumn get id => text()();
  IntColumn get type => integer()();
  TextColumn get mediaEntryId => text().references(MediaEntries, #id)();
  BoolColumn get anilist => boolean()();
  BoolColumn get kitsu => boolean()();
  BoolColumn get mal => boolean()();

   @override
  Set<Column> get primaryKey => {id};
}