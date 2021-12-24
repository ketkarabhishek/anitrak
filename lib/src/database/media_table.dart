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

  @override
  Set<Column> get primaryKey => {id};
}
