import 'package:anitrak/src/models/media_entry.dart';
import 'package:drift/drift.dart';

@UseRowClass(MediaEntry)
class MediaEntries extends Table {
  TextColumn get id => text()();
  IntColumn get alEntryId => integer()();
  IntColumn get alMediaId => integer()();
  TextColumn get status => text()();
  IntColumn get score => integer()();
  IntColumn get progress => integer()();
  IntColumn get repeat => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get title => text()();
  TextColumn get poster => text()();
  TextColumn get color => text()();
  IntColumn get total => integer()();
  IntColumn get malMediaId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};

}