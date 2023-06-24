import 'package:anitrak/src/database/database.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class MediaMapping extends Insertable<MediaMapping> {
  final String id;
  final int anilist;
  final int kitsu;
  final int mal;

  MediaMapping({
    required this.id,
    required this.anilist,
    required this.kitsu,
    required this.mal,
  });

  MediaMapping.fromJson(Map<String, dynamic> json)
      : id = const Uuid().v4(),
        anilist = json['anilist_id'] ?? 0,
        kitsu = json['kitsu_id'] ?? 0,
        mal = json['mal_id'] ?? 0;

  MediaMapping copyWith({
    int? anilist,
    int? kitsu,
    int? mal,
  }) {
    return MediaMapping(
      id: id,
      kitsu: kitsu ?? this.kitsu,
      mal: mal ?? this.mal,
      anilist: anilist ?? this.anilist,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return MediaMappingsCompanion(
      id: Value(id),
      anilist: Value(anilist),
      kitsu: Value(kitsu),
      mal: Value(mal),
    ).toColumns(nullToAbsent);
  }
}
