import 'package:floor/floor.dart';

@Entity()
class MediaEntry {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int alEntryId;
  final int alMediaId;
  final String status;
  final int? score;
  final int progress;
  final int repeat;
  final int createdAt;
  final int updatedAt;

  final String title;
  final String poster;
  final String color;
  final int? total;
  final int? malMediaId;

  MediaEntry({
    this.id,
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
  });

  MediaEntry.fromDb(Map<String, dynamic> json)
      : id = json['id'],
        alEntryId = json['alEntryId'],
        alMediaId = json['alMediaId'],
        status = json['status'],
        score = json['score'],
        progress = json['progress'],
        repeat = json['repeat'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        title = json['title'],
        poster = json['poster'],
        color = json['color'],
        total = json['total'],
        malMediaId = json['malMediaId'];

  MediaEntry.fromAnilistJson(Map<String, dynamic> json)
      : id = null,
        alEntryId = json['id'],
        alMediaId = json['mediaId'],
        status = json['status'],
        score = json['score'],
        progress = json['progress'],
        repeat = json['repeat'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        title = json['media']['title']['romaji'],
        poster = json["media"]['coverImage']['large'],
        color = json["media"]['coverImage']['color'] ?? "",
        total = json['media']['episodes'],
        malMediaId = json['media']['idMal'];
        

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
    };
  }
}
