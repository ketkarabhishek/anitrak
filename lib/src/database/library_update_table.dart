import 'package:anitrak/src/models/library_update.dart';
import 'package:drift/drift.dart';

@UseRowClass(LibraryUpdate)
class LibraryUpdates extends Table{
  TextColumn get id => text()();
  IntColumn get type => integer()();
  TextColumn get mediaEntryId => text()();
  BoolColumn get anilist => boolean()();
  BoolColumn get kitsu => boolean()();
  BoolColumn get mal => boolean()();
  IntColumn get alEntryId => integer()();

   @override
  Set<Column> get primaryKey => {id};
}