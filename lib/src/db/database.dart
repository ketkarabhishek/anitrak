import 'dart:async';

import 'package:anitrak/src/db/media_entry_dao.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [MediaEntry])
abstract class DataBase extends FloorDatabase {
  MediaEntryDao get mediaEntryDao;
}
