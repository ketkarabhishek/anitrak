import 'package:anitrak/src/database/media_table.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:drift/drift.dart';

@UseRowClass(MediaEntry)
class MediaEntries extends Table {
  TextColumn get id => text()();
  IntColumn get alEntryId => integer()();
  TextColumn get status => text()();
  IntColumn get score => integer()();
  IntColumn get progress => integer()();
  IntColumn get repeat => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  BoolColumn get synced => boolean()();

  TextColumn get media => text().nullable().references(Media, #id)();

  @override
  Set<Column> get primaryKey => {id};

}