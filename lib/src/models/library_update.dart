import 'package:anitrak/src/database/database.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

enum LibraryUpdateType {
  create,
  update,
  delete,
}

class LibraryUpdate extends Insertable<LibraryUpdate> {
  final String id;
  final int type;
  final String mediaEntryId;
  final bool anilist;
  final bool kitsu;
  final bool mal;
  final int alEntryId;

  LibraryUpdate({
    required this.id,
    required this.type,
    required this.mediaEntryId,
    required this.anilist,
    required this.kitsu,
    required this.mal,
    required this.alEntryId,
  });

  LibraryUpdate.createNewUpdate(LibraryUpdateType type, this.mediaEntryId, {int? alEntryId})
      : id = const Uuid().v4(),
        type = type.index,
        anilist = false,
        kitsu = false,
        mal = false,
        alEntryId = alEntryId ?? 0;

  LibraryUpdate copyWith({
    bool? anilist,
    bool? kitsu,
    bool? mal,
  }) {
    return LibraryUpdate(
      id: id,
      mediaEntryId: mediaEntryId,
      type: type,
      alEntryId: alEntryId,
      kitsu: kitsu ?? this.kitsu,
      mal: mal ?? this.mal,
      anilist: anilist ?? this.anilist,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return LibraryUpdatesCompanion(
      id: Value(id),
      type: Value(type),
      mediaEntryId: Value(mediaEntryId),
      anilist: Value(anilist),
      kitsu: Value(kitsu),
      mal: Value(mal),
      alEntryId: Value(alEntryId)
    ).toColumns(nullToAbsent);
  }
}
