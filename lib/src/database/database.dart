import 'package:anitrak/src/database/library_update_dao.dart';
import 'package:anitrak/src/database/library_update_table.dart';
import 'package:anitrak/src/database/media_entry_table.dart';
import 'package:anitrak/src/database/media_library_dao.dart';
import 'package:anitrak/src/database/media_mapping_table.dart';
import 'package:anitrak/src/database/media_table.dart';
import 'package:anitrak/src/models/library_update.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/models/media_model.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'dart:io';

import '../models/media_mapping.dart';

part 'database.g.dart';


LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [MediaEntries, Media, LibraryUpdates, MediaMappings], daos: [MediaLibraryDao, LibraryUpdateDao,])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    }
    
  );
  
}