// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class MediaCompanion extends UpdateCompanion<MediaModel> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> poster;
  final Value<String> description;
  final Value<int> total;
  final Value<int> duration;
  final Value<int> alMediaId;
  final Value<int?> malMediaId;
  final Value<String> color;
  const MediaCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.poster = const Value.absent(),
    this.description = const Value.absent(),
    this.total = const Value.absent(),
    this.duration = const Value.absent(),
    this.alMediaId = const Value.absent(),
    this.malMediaId = const Value.absent(),
    this.color = const Value.absent(),
  });
  MediaCompanion.insert({
    required String id,
    required String title,
    required String poster,
    required String description,
    required int total,
    required int duration,
    required int alMediaId,
    this.malMediaId = const Value.absent(),
    required String color,
  })  : id = Value(id),
        title = Value(title),
        poster = Value(poster),
        description = Value(description),
        total = Value(total),
        duration = Value(duration),
        alMediaId = Value(alMediaId),
        color = Value(color);
  static Insertable<MediaModel> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? poster,
    Expression<String>? description,
    Expression<int>? total,
    Expression<int>? duration,
    Expression<int>? alMediaId,
    Expression<int?>? malMediaId,
    Expression<String>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (poster != null) 'poster': poster,
      if (description != null) 'description': description,
      if (total != null) 'total': total,
      if (duration != null) 'duration': duration,
      if (alMediaId != null) 'al_media_id': alMediaId,
      if (malMediaId != null) 'mal_media_id': malMediaId,
      if (color != null) 'color': color,
    });
  }

  MediaCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? poster,
      Value<String>? description,
      Value<int>? total,
      Value<int>? duration,
      Value<int>? alMediaId,
      Value<int?>? malMediaId,
      Value<String>? color}) {
    return MediaCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      poster: poster ?? this.poster,
      description: description ?? this.description,
      total: total ?? this.total,
      duration: duration ?? this.duration,
      alMediaId: alMediaId ?? this.alMediaId,
      malMediaId: malMediaId ?? this.malMediaId,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (poster.present) {
      map['poster'] = Variable<String>(poster.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (alMediaId.present) {
      map['al_media_id'] = Variable<int>(alMediaId.value);
    }
    if (malMediaId.present) {
      map['mal_media_id'] = Variable<int?>(malMediaId.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('poster: $poster, ')
          ..write('description: $description, ')
          ..write('total: $total, ')
          ..write('duration: $duration, ')
          ..write('alMediaId: $alMediaId, ')
          ..write('malMediaId: $malMediaId, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $MediaTable extends Media with TableInfo<$MediaTable, MediaModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _posterMeta = const VerificationMeta('poster');
  @override
  late final GeneratedColumn<String?> poster = GeneratedColumn<String?>(
      'poster', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int?> total = GeneratedColumn<int?>(
      'total', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _durationMeta = const VerificationMeta('duration');
  @override
  late final GeneratedColumn<int?> duration = GeneratedColumn<int?>(
      'duration', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _alMediaIdMeta = const VerificationMeta('alMediaId');
  @override
  late final GeneratedColumn<int?> alMediaId = GeneratedColumn<int?>(
      'al_media_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _malMediaIdMeta = const VerificationMeta('malMediaId');
  @override
  late final GeneratedColumn<int?> malMediaId = GeneratedColumn<int?>(
      'mal_media_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String?> color = GeneratedColumn<String?>(
      'color', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        poster,
        description,
        total,
        duration,
        alMediaId,
        malMediaId,
        color
      ];
  @override
  String get aliasedName => _alias ?? 'media';
  @override
  String get actualTableName => 'media';
  @override
  VerificationContext validateIntegrity(Insertable<MediaModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('poster')) {
      context.handle(_posterMeta,
          poster.isAcceptableOrUnknown(data['poster']!, _posterMeta));
    } else if (isInserting) {
      context.missing(_posterMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('al_media_id')) {
      context.handle(
          _alMediaIdMeta,
          alMediaId.isAcceptableOrUnknown(
              data['al_media_id']!, _alMediaIdMeta));
    } else if (isInserting) {
      context.missing(_alMediaIdMeta);
    }
    if (data.containsKey('mal_media_id')) {
      context.handle(
          _malMediaIdMeta,
          malMediaId.isAcceptableOrUnknown(
              data['mal_media_id']!, _malMediaIdMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaModel(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      alMediaId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}al_media_id'])!,
      poster: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}poster'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description'])!,
      duration: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}duration'])!,
      color: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}color'])!,
      total: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}total'])!,
      malMediaId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}mal_media_id']),
    );
  }

  @override
  $MediaTable createAlias(String alias) {
    return $MediaTable(attachedDatabase, alias);
  }
}

class MediaEntriesCompanion extends UpdateCompanion<MediaEntry> {
  final Value<String> id;
  final Value<int> alEntryId;
  final Value<String> status;
  final Value<int> score;
  final Value<int> progress;
  final Value<int> repeat;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> synced;
  final Value<String?> media;
  const MediaEntriesCompanion({
    this.id = const Value.absent(),
    this.alEntryId = const Value.absent(),
    this.status = const Value.absent(),
    this.score = const Value.absent(),
    this.progress = const Value.absent(),
    this.repeat = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.media = const Value.absent(),
  });
  MediaEntriesCompanion.insert({
    required String id,
    required int alEntryId,
    required String status,
    required int score,
    required int progress,
    required int repeat,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool synced,
    this.media = const Value.absent(),
  })  : id = Value(id),
        alEntryId = Value(alEntryId),
        status = Value(status),
        score = Value(score),
        progress = Value(progress),
        repeat = Value(repeat),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        synced = Value(synced);
  static Insertable<MediaEntry> custom({
    Expression<String>? id,
    Expression<int>? alEntryId,
    Expression<String>? status,
    Expression<int>? score,
    Expression<int>? progress,
    Expression<int>? repeat,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? synced,
    Expression<String?>? media,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alEntryId != null) 'al_entry_id': alEntryId,
      if (status != null) 'status': status,
      if (score != null) 'score': score,
      if (progress != null) 'progress': progress,
      if (repeat != null) 'repeat': repeat,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (synced != null) 'synced': synced,
      if (media != null) 'media': media,
    });
  }

  MediaEntriesCompanion copyWith(
      {Value<String>? id,
      Value<int>? alEntryId,
      Value<String>? status,
      Value<int>? score,
      Value<int>? progress,
      Value<int>? repeat,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? synced,
      Value<String?>? media}) {
    return MediaEntriesCompanion(
      id: id ?? this.id,
      alEntryId: alEntryId ?? this.alEntryId,
      status: status ?? this.status,
      score: score ?? this.score,
      progress: progress ?? this.progress,
      repeat: repeat ?? this.repeat,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      media: media ?? this.media,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (alEntryId.present) {
      map['al_entry_id'] = Variable<int>(alEntryId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (repeat.present) {
      map['repeat'] = Variable<int>(repeat.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (media.present) {
      map['media'] = Variable<String?>(media.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaEntriesCompanion(')
          ..write('id: $id, ')
          ..write('alEntryId: $alEntryId, ')
          ..write('status: $status, ')
          ..write('score: $score, ')
          ..write('progress: $progress, ')
          ..write('repeat: $repeat, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('synced: $synced, ')
          ..write('media: $media')
          ..write(')'))
        .toString();
  }
}

class $MediaEntriesTable extends MediaEntries
    with TableInfo<$MediaEntriesTable, MediaEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaEntriesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _alEntryIdMeta = const VerificationMeta('alEntryId');
  @override
  late final GeneratedColumn<int?> alEntryId = GeneratedColumn<int?>(
      'al_entry_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String?> status = GeneratedColumn<String?>(
      'status', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int?> score = GeneratedColumn<int?>(
      'score', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _progressMeta = const VerificationMeta('progress');
  @override
  late final GeneratedColumn<int?> progress = GeneratedColumn<int?>(
      'progress', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _repeatMeta = const VerificationMeta('repeat');
  @override
  late final GeneratedColumn<int?> repeat = GeneratedColumn<int?>(
      'repeat', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool?> synced = GeneratedColumn<bool?>(
      'synced', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (synced IN (0, 1))');
  final VerificationMeta _mediaMeta = const VerificationMeta('media');
  @override
  late final GeneratedColumn<String?> media = GeneratedColumn<String?>(
      'media', aliasedName, true,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultConstraints: 'REFERENCES media (id)');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        alEntryId,
        status,
        score,
        progress,
        repeat,
        createdAt,
        updatedAt,
        synced,
        media
      ];
  @override
  String get aliasedName => _alias ?? 'media_entries';
  @override
  String get actualTableName => 'media_entries';
  @override
  VerificationContext validateIntegrity(Insertable<MediaEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('al_entry_id')) {
      context.handle(
          _alEntryIdMeta,
          alEntryId.isAcceptableOrUnknown(
              data['al_entry_id']!, _alEntryIdMeta));
    } else if (isInserting) {
      context.missing(_alEntryIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    } else if (isInserting) {
      context.missing(_progressMeta);
    }
    if (data.containsKey('repeat')) {
      context.handle(_repeatMeta,
          repeat.isAcceptableOrUnknown(data['repeat']!, _repeatMeta));
    } else if (isInserting) {
      context.missing(_repeatMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    } else if (isInserting) {
      context.missing(_syncedMeta);
    }
    if (data.containsKey('media')) {
      context.handle(
          _mediaMeta, media.isAcceptableOrUnknown(data['media']!, _mediaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaEntry(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      alEntryId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}al_entry_id'])!,
      media: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}media']),
      status: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status'])!,
      score: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}score'])!,
      progress: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}progress'])!,
      repeat: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}repeat'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      synced: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $MediaEntriesTable createAlias(String alias) {
    return $MediaEntriesTable(attachedDatabase, alias);
  }
}

class LibraryUpdatesCompanion extends UpdateCompanion<LibraryUpdate> {
  final Value<String> id;
  final Value<int> type;
  final Value<String> mediaEntryId;
  final Value<bool> anilist;
  final Value<bool> kitsu;
  final Value<bool> mal;
  const LibraryUpdatesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.mediaEntryId = const Value.absent(),
    this.anilist = const Value.absent(),
    this.kitsu = const Value.absent(),
    this.mal = const Value.absent(),
  });
  LibraryUpdatesCompanion.insert({
    required String id,
    required int type,
    required String mediaEntryId,
    required bool anilist,
    required bool kitsu,
    required bool mal,
  })  : id = Value(id),
        type = Value(type),
        mediaEntryId = Value(mediaEntryId),
        anilist = Value(anilist),
        kitsu = Value(kitsu),
        mal = Value(mal);
  static Insertable<LibraryUpdate> custom({
    Expression<String>? id,
    Expression<int>? type,
    Expression<String>? mediaEntryId,
    Expression<bool>? anilist,
    Expression<bool>? kitsu,
    Expression<bool>? mal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (mediaEntryId != null) 'media_entry_id': mediaEntryId,
      if (anilist != null) 'anilist': anilist,
      if (kitsu != null) 'kitsu': kitsu,
      if (mal != null) 'mal': mal,
    });
  }

  LibraryUpdatesCompanion copyWith(
      {Value<String>? id,
      Value<int>? type,
      Value<String>? mediaEntryId,
      Value<bool>? anilist,
      Value<bool>? kitsu,
      Value<bool>? mal}) {
    return LibraryUpdatesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      mediaEntryId: mediaEntryId ?? this.mediaEntryId,
      anilist: anilist ?? this.anilist,
      kitsu: kitsu ?? this.kitsu,
      mal: mal ?? this.mal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (mediaEntryId.present) {
      map['media_entry_id'] = Variable<String>(mediaEntryId.value);
    }
    if (anilist.present) {
      map['anilist'] = Variable<bool>(anilist.value);
    }
    if (kitsu.present) {
      map['kitsu'] = Variable<bool>(kitsu.value);
    }
    if (mal.present) {
      map['mal'] = Variable<bool>(mal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryUpdatesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('mediaEntryId: $mediaEntryId, ')
          ..write('anilist: $anilist, ')
          ..write('kitsu: $kitsu, ')
          ..write('mal: $mal')
          ..write(')'))
        .toString();
  }
}

class $LibraryUpdatesTable extends LibraryUpdates
    with TableInfo<$LibraryUpdatesTable, LibraryUpdate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryUpdatesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int?> type = GeneratedColumn<int?>(
      'type', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _mediaEntryIdMeta =
      const VerificationMeta('mediaEntryId');
  @override
  late final GeneratedColumn<String?> mediaEntryId = GeneratedColumn<String?>(
      'media_entry_id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES media_entries (id)');
  final VerificationMeta _anilistMeta = const VerificationMeta('anilist');
  @override
  late final GeneratedColumn<bool?> anilist = GeneratedColumn<bool?>(
      'anilist', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (anilist IN (0, 1))');
  final VerificationMeta _kitsuMeta = const VerificationMeta('kitsu');
  @override
  late final GeneratedColumn<bool?> kitsu = GeneratedColumn<bool?>(
      'kitsu', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (kitsu IN (0, 1))');
  final VerificationMeta _malMeta = const VerificationMeta('mal');
  @override
  late final GeneratedColumn<bool?> mal = GeneratedColumn<bool?>(
      'mal', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (mal IN (0, 1))');
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, mediaEntryId, anilist, kitsu, mal];
  @override
  String get aliasedName => _alias ?? 'library_updates';
  @override
  String get actualTableName => 'library_updates';
  @override
  VerificationContext validateIntegrity(Insertable<LibraryUpdate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('media_entry_id')) {
      context.handle(
          _mediaEntryIdMeta,
          mediaEntryId.isAcceptableOrUnknown(
              data['media_entry_id']!, _mediaEntryIdMeta));
    } else if (isInserting) {
      context.missing(_mediaEntryIdMeta);
    }
    if (data.containsKey('anilist')) {
      context.handle(_anilistMeta,
          anilist.isAcceptableOrUnknown(data['anilist']!, _anilistMeta));
    } else if (isInserting) {
      context.missing(_anilistMeta);
    }
    if (data.containsKey('kitsu')) {
      context.handle(
          _kitsuMeta, kitsu.isAcceptableOrUnknown(data['kitsu']!, _kitsuMeta));
    } else if (isInserting) {
      context.missing(_kitsuMeta);
    }
    if (data.containsKey('mal')) {
      context.handle(
          _malMeta, mal.isAcceptableOrUnknown(data['mal']!, _malMeta));
    } else if (isInserting) {
      context.missing(_malMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LibraryUpdate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryUpdate(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      type: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      mediaEntryId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}media_entry_id'])!,
      anilist: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}anilist'])!,
      kitsu: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}kitsu'])!,
      mal: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}mal'])!,
    );
  }

  @override
  $LibraryUpdatesTable createAlias(String alias) {
    return $LibraryUpdatesTable(attachedDatabase, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $MediaTable media = $MediaTable(this);
  late final $MediaEntriesTable mediaEntries = $MediaEntriesTable(this);
  late final $LibraryUpdatesTable libraryUpdates = $LibraryUpdatesTable(this);
  late final MediaLibraryDao mediaLibraryDao =
      MediaLibraryDao(this as MyDatabase);
  late final LibraryUpdateDao libraryUpdateDao =
      LibraryUpdateDao(this as MyDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [media, mediaEntries, libraryUpdates];
}
