import 'package:anitrak/src/database/media_table.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:drift/drift.dart';

@UseRowClass(MediaEntry)
class MediaEntries extends Table {
  TextColumn get id => text()();
  IntColumn get alEntryId => integer()();
  IntColumn get kitsuEntryId => integer()();
  IntColumn get status => integer()();
  IntColumn get score => integer()();
  IntColumn get progress => integer()();
  IntColumn get repeat => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime()();

  BoolColumn get synced => boolean()();

  TextColumn get media => text().nullable().references(Media, #id)();

  @override
  Set<Column> get primaryKey => {id};

}