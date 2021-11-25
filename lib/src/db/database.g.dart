// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorDataBase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DataBaseBuilder databaseBuilder(String name) =>
      _$DataBaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DataBaseBuilder inMemoryDatabaseBuilder() => _$DataBaseBuilder(null);
}

class _$DataBaseBuilder {
  _$DataBaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$DataBaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$DataBaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<DataBase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$DataBase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$DataBase extends DataBase {
  _$DataBase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MediaEntryDao? _mediaEntryDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MediaEntry` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `alEntryId` INTEGER NOT NULL, `alMediaId` INTEGER NOT NULL, `status` TEXT NOT NULL, `score` INTEGER, `progress` INTEGER NOT NULL, `repeat` INTEGER NOT NULL, `createdAt` INTEGER NOT NULL, `updatedAt` INTEGER NOT NULL, `title` TEXT NOT NULL, `poster` TEXT NOT NULL, `color` TEXT NOT NULL, `total` INTEGER, `malMediaId` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MediaEntryDao get mediaEntryDao {
    return _mediaEntryDaoInstance ??= _$MediaEntryDao(database, changeListener);
  }
}

class _$MediaEntryDao extends MediaEntryDao {
  _$MediaEntryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _mediaEntryInsertionAdapter = InsertionAdapter(
            database,
            'MediaEntry',
            (MediaEntry item) => <String, Object?>{
                  'id': item.id,
                  'alEntryId': item.alEntryId,
                  'alMediaId': item.alMediaId,
                  'status': item.status,
                  'score': item.score,
                  'progress': item.progress,
                  'repeat': item.repeat,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt,
                  'title': item.title,
                  'poster': item.poster,
                  'color': item.color,
                  'total': item.total,
                  'malMediaId': item.malMediaId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MediaEntry> _mediaEntryInsertionAdapter;

  @override
  Stream<List<MediaEntry>> findAllMediaEntriesAsStream() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM MediaEntry WHERE status = \'CURRENT\'',
        mapper: (Map<String, Object?> row) => MediaEntry(
            id: row['id'] as int?,
            alEntryId: row['alEntryId'] as int,
            title: row['title'] as String,
            alMediaId: row['alMediaId'] as int,
            poster: row['poster'] as String,
            status: row['status'] as String,
            score: row['score'] as int?,
            progress: row['progress'] as int,
            repeat: row['repeat'] as int,
            createdAt: row['createdAt'] as int,
            updatedAt: row['updatedAt'] as int,
            color: row['color'] as String,
            total: row['total'] as int?,
            malMediaId: row['malMediaId'] as int?),
        queryableName: 'MediaEntry',
        isView: false);
  }

  @override
  Stream<List<MediaEntry>> findAllMediaEntries() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM MediaEntry WHERE status = CURRENT',
        mapper: (Map<String, Object?> row) => MediaEntry(
            id: row['id'] as int?,
            alEntryId: row['alEntryId'] as int,
            title: row['title'] as String,
            alMediaId: row['alMediaId'] as int,
            poster: row['poster'] as String,
            status: row['status'] as String,
            score: row['score'] as int?,
            progress: row['progress'] as int,
            repeat: row['repeat'] as int,
            createdAt: row['createdAt'] as int,
            updatedAt: row['updatedAt'] as int,
            color: row['color'] as String,
            total: row['total'] as int?,
            malMediaId: row['malMediaId'] as int?),
        queryableName: 'MediaEntry',
        isView: false);
  }

  @override
  Future<void> deleteAllMediaEntries() async {
    await _queryAdapter.queryNoReturn('DELETE FROM MediaEntry');
  }

  @override
  Future<void> insertMediaEntries(List<MediaEntry> mediaEntries) async {
    await _mediaEntryInsertionAdapter.insertList(
        mediaEntries, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertMediaEntry(MediaEntry mediaEntry) async {
    await _mediaEntryInsertionAdapter.insert(
        mediaEntry, OnConflictStrategy.abort);
  }

  @override
  Future<void> replaceMediaEntries(List<MediaEntry> mediaEntries) async {
    if (database is sqflite.Transaction) {
      await super.replaceMediaEntries(mediaEntries);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$DataBase(changeListener)
          ..database = transaction;
        await transactionDatabase.mediaEntryDao
            .replaceMediaEntries(mediaEntries);
      });
    }
  }
}
