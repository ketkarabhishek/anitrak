import 'package:anitrak/src/database/database.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class MediaEntry extends Insertable<MediaEntry> {
  final String id;
  final int alEntryId;
  final int status;
  final int score;
  final int progress;
  final int repeat;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime startedAt;
  final DateTime completedAt;

  final String? media;
  final bool synced;

  MediaEntryStatus get entryStatus => MediaEntryStatus.values[status];

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
    required this.startedAt,
    required this.completedAt,
    required this.synced,
  });

  MediaEntry.fromAnilistJson(Map<String, dynamic> json, String mediaId)
      : id = const Uuid().v4(),
        alEntryId = json['id'],
        status = _convertAnilistStatus(json['status']).index,
        score = json['score'],
        progress = json['progress'] ?? 0,
        repeat = json['repeat'],
        createdAt = DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
        updatedAt = DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
        startedAt = DateTime(json['startedAt']['year'] ?? 1970,
            json['startedAt']['month'] ?? 1, json['startedAt']['day'] ?? 1),
        completedAt = DateTime(json['completedAt']['year'] ?? 1970,
            json['completedAt']['month'] ?? 1, json['completedAt']['day'] ?? 1),
        media = mediaId,
        synced = true;

  MediaEntry.createNewEntry({required String mediaId, int mstatus = 1})
      : id = const Uuid().v4(),
        alEntryId = 0,
        status = mstatus,
        score = 0,
        progress = 0,
        repeat = 0,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        startedAt = DateTime.now(),
        completedAt = DateTime.now(),
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
      // 'id': alEntryId != 0 ? alEntryId : null,
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
    int? status,
    int? score,
    int? progress,
    int? repeat,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startedAt,
    DateTime? completedAt,
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
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt ?? this.completedAt,
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
      startedAt: Value(startedAt),
      completedAt: Value(completedAt),
      media: Value(media),
      synced: Value(synced),
    ).toColumns(nullToAbsent);
  }

  static MediaEntryStatus _convertAnilistStatus(String anilistStatus) {
    switch (anilistStatus) {
      case "CURRENT":
        return MediaEntryStatus.watching;
      case "COMPLETED":
        return MediaEntryStatus.completed;
      case "PLANNING":
        return MediaEntryStatus.planned;
      case "PAUSED":
        return MediaEntryStatus.onHold;
      case "DROPPED":
        return MediaEntryStatus.dropped;
      default:
        return MediaEntryStatus.watching;
    }
  }
}

enum MediaEntryStatus { watching, completed, planned, onHold, dropped }

extension MediaEntryStatusExt on MediaEntryStatus {
  String get displayTitle {
    switch (this) {
      case MediaEntryStatus.watching:
        return "Watching";
      case MediaEntryStatus.completed:
        return "Completed";
      case MediaEntryStatus.planned:
        return "Planned";
      case MediaEntryStatus.onHold:
        return "On Hold";
      case MediaEntryStatus.dropped:
        return "Dropped";
    }
  }
}
