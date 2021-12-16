import 'package:anitrak/src/database/database.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class MediaEntry extends Insertable<MediaEntry> {
  final String id;
  final int alEntryId;
  final int alMediaId;
  final String status;
  final int score;
  final int progress;
  final int repeat;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String title;
  final String poster;
  final String color;
  final int total;
  final int? malMediaId;
  final bool synced;

  MediaEntry({
    required this.id,
    required this.alEntryId,
    required this.title,
    required this.alMediaId,
    required this.poster,
    required this.status,
    required this.score,
    required this.progress,
    required this.repeat,
    required this.createdAt,
    required this.updatedAt,
    required this.color,
    required this.total,
    required this.malMediaId,
    required this.synced,
  });

  MediaEntry.fromAnilistJson(Map<String, dynamic> json)
      : id = const Uuid().v4(),
        alEntryId = json['id'],
        alMediaId = json['mediaId'],
        status = json['status'],
        score = json['score'],
        progress = json['progress'] ?? 0,
        repeat = json['repeat'],
        createdAt = DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
        updatedAt = DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
        title = json['media']['title']['romaji'],
        poster = json["media"]['coverImage']['large'],
        color = json["media"]['coverImage']['color'] ?? "",
        total = json['media']['episodes'] ?? 0,
        malMediaId = json['media']['idMal'],
        synced = true;

  Map<String, dynamic> toMap() {
    return {
      'alEntryId': alEntryId,
      'alMediaId': alMediaId,
      'status': status,
      'score': score,
      'progress': progress,
      'repeat': repeat,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'title': title,
      'poster': poster,
      'color': color,
      'total': total,
      'malMediaId': malMediaId,
      'synced': synced,
    };
  }

  Map<String, dynamic> toAnilistMap() {
    return {
      'id': alEntryId,
      'mediaId': alMediaId,
      'status': status,
      'score': score,
      'progress': progress,
      'repeat': repeat,
    };
  }

  MediaEntry copyWith({
    int? alEntryId,
    int? alMediaId,
    String? status,
    int? score,
    int? progress,
    int? repeat,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    String? poster,
    String? color,
    int? total,
    int? malMediaId,
    bool? synced,
  }) {
    return MediaEntry(
      id: id,
      alEntryId: alEntryId ?? this.alEntryId,
      title: title ?? this.title,
      alMediaId: alMediaId ?? this.alMediaId,
      poster: poster ?? this.poster,
      status: status ?? this.status,
      score: score ?? this.score,
      progress: progress ?? this.progress,
      repeat: repeat ?? this.repeat,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      color: color ?? this.color,
      total: total ?? this.total,
      malMediaId: malMediaId ?? this.malMediaId,
      synced: synced ?? this.synced
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return MediaEntriesCompanion(
      id: Value(id),
      alEntryId: Value(alEntryId),
      status: Value(status),
      score: Value(score),
      alMediaId: Value(alMediaId),
      progress: Value(progress),
      repeat: Value(repeat),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      title: Value(title),
      poster: Value(poster),
      color: Value(color),
      total: Value(total),
      malMediaId: Value(malMediaId),
      synced: Value(synced),
    ).toColumns(nullToAbsent);
  }
}
