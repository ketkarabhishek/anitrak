import 'package:anitrak/src/models/media_model.dart';
import 'package:drift/drift.dart';

@UseRowClass(MediaModel)
class Media extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get poster => text()();
  TextColumn get description => text()();
  IntColumn get total => integer()();
  IntColumn get duration => integer()();
  IntColumn get alMediaId => integer()();
  IntColumn get malMediaId => integer().nullable()();
  TextColumn get color => text()();

  IntColumn get status => integer()();
  IntColumn get format => integer()();
  IntColumn get season => integer()();
  IntColumn get year => integer()();
  TextColumn get coverImage => text()();

  @override
  Set<Column> get primaryKey => {id};
}
