import 'package:anitrak/src/database/database.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class MediaEntry extends Insertable<MediaEntry> {
  final String id;
  final int alEntryId;
  final String status;
  final int score;
  final int progress;
  final int repeat;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? media;
  final bool synced;

  static const String current = 'CURRENT';
  static const String completed = 'COMPLETED';
  static const String planned = 'PLANNING';
  static const String onHold = 'PAUSED';
  static const String dropped = 'DROPPED';

  MediaEntry({
    required this.id,
    required this.alEntryId,
    required this.media,
    required this.status,
    required this.score,
    required this.progress,
    required this.repeat,
    required this.createdAt,
    required this.updatedAt,
    required this.synced,
  });

  MediaEntry.fromAnilistJson(Map<String, dynamic> json, String mediaId)
      : id = const Uuid().v4(),
        alEntryId = json['id'],
        status = json['status'],
        score = json['score'],
        progress = json['progress'] ?? 0,
        repeat = json['repeat'],
        createdAt = DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
        updatedAt = DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
        media = mediaId,
        synced = true;

  MediaEntry.createNewEntry(
      {required String mediaId, String mstatus = "CURRENT"})
      : id = const Uuid().v4(),
        alEntryId = 0,
        status = mstatus,
        score = 0,
        progress = 0,
        repeat = 0,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        media = mediaId,
        synced = false;

  Map<String, dynamic> toMap() {
    return {
      'alEntryId': alEntryId,
      'status': status,
      'score': score,
      'progress': progress,
      'repeat': repeat,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'media': media,
      'synced': synced,
    };
  }

  Map<String, dynamic> toAnilistMap({required int mediaId}) {
    var varMap = {
      'id': alEntryId != 0 ? alEntryId : null,
      'mediaId': mediaId,
      'status': status,
      'score': score,
      'progress': progress,
      'repeat': repeat,
    };
    return varMap;
  }

  MediaEntry copyWith({
    int? alEntryId,
    String? status,
    int? score,
    int? progress,
    int? repeat,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? media,
    bool? synced,
  }) {
    return MediaEntry(
        id: id,
        alEntryId: alEntryId ?? this.alEntryId,
        media: media ?? this.media,
        status: status ?? this.status,
        score: score ?? this.score,
        progress: progress ?? this.progress,
        repeat: repeat ?? this.repeat,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        synced: synced ?? this.synced);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return MediaEntriesCompanion(
      id: Value(id),
      alEntryId: Value(alEntryId),
      status: Value(status),
      score: Value(score),
      progress: Value(progress),
      repeat: Value(repeat),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      media: Value(media),
      synced: Value(synced),
    ).toColumns(nullToAbsent);
  }
}
