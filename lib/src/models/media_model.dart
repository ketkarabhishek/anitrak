import 'package:anitrak/src/database/database.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class MediaModel extends Insertable<MediaModel> {
  final String id;
  final String title;
  final String poster;
  final String description;
  final int total;
  final int duration;
  final int alMediaId;
  final int? malMediaId;
  final String color;

  MediaModel({
    required this.id,
    required this.title,
    required this.alMediaId,
    required this.poster,
    required this.description,
    required this.duration,
    required this.color,
    required this.total,
    required this.malMediaId,
  });

  MediaModel.fromAnilistJson(Map<String, dynamic> json)
      : id = const Uuid().v4(),
        alMediaId = json['id'],
        description = json['description'] ?? "",
        duration = json['duration'] ?? 0,
        title = json['title']['romaji'] ?? "",
        poster = json['coverImage']['large'],
        color = json['coverImage']['color'] ?? "",
        total = json['episodes'] ?? 0,
        malMediaId = json['idMal'] ?? 0;

  Map<String, dynamic> toMap() {
    return {
      'alMediaId': alMediaId,
      'status': description,
      'score': duration,
      'title': title,
      'poster': poster,
      'color': color,
      'total': total,
      'malMediaId': malMediaId,
    };
  }

  // Map<String, dynamic> toAnilistMap() {
  //   return {
  //     'id': alEntryId,
  //     'mediaId': alMediaId,
  //     'status': status,
  //     'score': score,
  //     'progress': progress,
  //     'repeat': repeat,
  //   };
  // }

  MediaModel copyWith({
    int? alMediaId,
    String? description,
    int? duration,
    String? title,
    String? poster,
    String? color,
    int? total,
    int? malMediaId,
  }) {
    return MediaModel(
      id: id,
      title: title ?? this.title,
      alMediaId: alMediaId ?? this.alMediaId,
      poster: poster ?? this.poster,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      color: color ?? this.color,
      total: total ?? this.total,
      malMediaId: malMediaId ?? this.malMediaId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return MediaCompanion(
      id: Value(id),
      description: Value(description),
      title: Value(title),
      duration: Value(duration),
      alMediaId: Value(alMediaId),
      poster: Value(poster),
      color: Value(color),
      total: Value(total),
      malMediaId: Value(malMediaId),
    ).toColumns(nullToAbsent);
  }
}