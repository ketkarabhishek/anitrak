import 'package:anitrak/src/models/media_mapping.dart';
import 'package:drift/drift.dart';

@UseRowClass(MediaMapping)
class MediaMappings extends Table {
  TextColumn get id => text()();
  IntColumn get anilist => integer()();
  IntColumn get kitsu => integer()();
  IntColumn get mal => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
