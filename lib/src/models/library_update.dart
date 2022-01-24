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

  LibraryUpdate({
    required this.id,
    required this.type,
    required this.mediaEntryId,
    required this.anilist,
    required this.kitsu,
    required this.mal,
  });

  LibraryUpdate.createNewUpdate(LibraryUpdateType type, this.mediaEntryId)
      : id = const Uuid().v4(),
        type = type.index,
        anilist = false,
        kitsu = false,
        mal = false;

  LibraryUpdate copyWith({
    bool? anilist,
    bool? kitsu,
    bool? mal,
  }) {
    return LibraryUpdate(
      id: id,
      mediaEntryId: mediaEntryId,
      type: type,
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
    ).toColumns(nullToAbsent);
  }
}
