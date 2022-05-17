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
  final int malMediaId;
  final int kitsuMediaId;
  final String color;

  final int format;
  final int season;
  final int year;
  final int status;
  final String coverImage;

  MediaFormat get mediaFormat => MediaFormat.values[format];
  MediaSeason get mediaSeason => MediaSeason.values[season];
  MediaStatus get mediaStatus => MediaStatus.values[status];

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
    required this.kitsuMediaId,
    required this.format,
    required this.season,
    required this.year,
    required this.status,
    required this.coverImage,
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
        malMediaId = json['idMal'] ?? 0,
        kitsuMediaId = 0,
        format = formatFromApi(json['format']).index,
        season = seasonFromApi(json['season'] ?? "").index,
        status = statusFromApi(json['status']).index,
        year = json['seasonYear'] ?? 0,
        coverImage = json['bannerImage'] ?? json['coverImage']['large'];

  MediaModel.fromKitsuJson(Map<String, dynamic> json)
      : id = const Uuid().v4(),
        alMediaId = 0,
        kitsuMediaId = int.parse(json['id']),
        description = json['description']['en'] ?? "",
        duration = Duration(seconds: json['episodeLength'] ?? 0).inMinutes,
        title = json['titles']['romanized'] ?? "",
        poster = json['posterImage']['original']['url'],
        color = json['posterImage']['blurhash'] ?? "",
        total = json['episodeCount'] ?? 0,
        malMediaId = json['idMal'] ?? 0,
        format = formatFromApi(json['subtype']).index,
        season = seasonFromApi(json['season'] ?? "").index,
        status = statusFromApi(json['status']).index,
        year = DateTime.parse(json['startDate']).year,
        coverImage = (json['bannerImage']['views'] as List).isNotEmpty ? json['bannerImage']['views'][0]['url'] : json['posterImage']['original']['url'];

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

  MediaModel copyWith({
    int? alMediaId,
    String? description,
    int? duration,
    String? title,
    String? poster,
    String? color,
    int? total,
    int? malMediaId,
    int? kitsuMediaId,
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
        kitsuMediaId: kitsuMediaId ?? this.kitsuMediaId,
        format: format,
        season: season,
        status: status,
        year: year,
        coverImage: coverImage);
  }

  static MediaType typeFromAnilist(String anilistType) {
    switch (anilistType) {
      case "ANIME":
        return MediaType.anime;
      case "MANGA":
        return MediaType.manga;
      default:
        return MediaType.anime;
    }
  }

  static MediaSeason seasonFromApi(String anilistSeason) {
    switch (anilistSeason) {
      case "WINTER":
        return MediaSeason.winter;
      case "SPRING":
        return MediaSeason.spring;
      case "SUMMER":
        return MediaSeason.summer;
      case "FALL":
        return MediaSeason.fall;
      default:
        return MediaSeason.winter;
    }
  }

  static MediaFormat formatFromApi(String anilistFormat) {
    switch (anilistFormat) {
      case "TV":
        return MediaFormat.tv;
      case "MOVIE":
        return MediaFormat.movie;
      case "SPECIAL":
        return MediaFormat.special;
      case "OVA":
        return MediaFormat.ova;
      case "ONA":
        return MediaFormat.ona;
      default:
        return MediaFormat.tv;
    }
  }

  static MediaStatus statusFromApi(String anilistFormat) {
    switch (anilistFormat) {
      case "FINISHED":
        return MediaStatus.finished;
      case "RELEASING":
        return MediaStatus.current;
      case "CURRENT":
        return MediaStatus.current;
      default:
        return MediaStatus.tba;
    }
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
      kitsuMediaId: Value(kitsuMediaId),
      format: Value(format),
      status: Value(status),
      year: Value(year),
      season: Value(season),
      coverImage: Value(coverImage),
    ).toColumns(nullToAbsent);
  }
}

// Media Type
enum MediaType { anime, manga }

extension MediaTypeExt on MediaType {
  String get displayTitle {
    switch (this) {
      case MediaType.anime:
        return "Anime";
      case MediaType.manga:
        return "Manga";
    }
  }
}

// Season
enum MediaSeason { winter, spring, summer, fall }

extension MediaSeasonExt on MediaSeason {
  String get displayTitle {
    switch (this) {
      case MediaSeason.winter:
        return "Winter";
      case MediaSeason.spring:
        return "Spring";
      case MediaSeason.summer:
        return "Summer";
      case MediaSeason.fall:
        return "Fall";
    }
  }
}

// Format
enum MediaFormat { tv, movie, special, ova, ona, music }

extension MediaFormatExt on MediaFormat {
  String get displayTitle {
    switch (this) {
      case MediaFormat.tv:
        return "TV";
      case MediaFormat.movie:
        return "Movie";
      case MediaFormat.special:
        return "Special";
      case MediaFormat.ova:
        return "OVA";
      case MediaFormat.ona:
        return "ONA";
      case MediaFormat.music:
        return "Music";
    }
  }
}

//Airing Status
enum MediaStatus { finished, current, tba }

extension MediaStatusExt on MediaStatus {
  String get displayTitle {
    switch (this) {
      case MediaStatus.finished:
        return "Finished";
      case MediaStatus.current:
        return "Airing";
      case MediaStatus.tba:
        return "TBA";
    }
  }
}
