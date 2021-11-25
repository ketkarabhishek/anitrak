import 'package:anitrak/src/db/database.dart';
import 'package:anitrak/src/models/media.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/services/anilist/anilist_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';
part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this.db)
      : super(HomeState(
            mediaListStream: db.mediaEntryDao.findAllMediaEntriesAsStream())) {
    on<HomeInitialized>((event, emit) => emit(state.copyWith(status: HomeStatus.success)));
    on<HomeAnilistImported>((event, emit) async {
      // _addTest(db.mediaEntryDao);
      await _importAnilistLibrary();
    });
  }

  final DataBase db;
  final AnilistClient client = AnilistClient.create();

  // void _addTest(MediaEntryDao dao) {
  //   dao.insertMediaEntry(MediaEntry(
  //       alEntryId: 4346,
  //       alMediaId: 46346,
  //       title: "Test",
  //       score: 6,
  //       updatedAt: 463574,
  //       createdAt: 634657,
  //       progress: 7,
  //       poster:
  //           "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx133965-9TZBS4m4yvED.png",
  //       status: "CURRENT",
  //       repeat: 1));
  // }

  Future<void> _importAnilistLibrary() async {
    final json = await client.getMediaListCollection(561580, "ANIME");
    final lists = json['lists'] as List;
    final filteredList =
        lists.where((element) => !element['isCustomList']).toList();
    final mediaLists = filteredList
        .map<List<MediaEntry>>((e) {
          final l = e['entries'] as List;
          return l
              .map<MediaEntry>((e) => MediaEntry.fromAnilistJson(e))
              .toList();
        })
        .toList()
        .reduce((value, element) => value + element);
    await db.mediaEntryDao.replaceMediaEntries(mediaLists);
    return;
  }
}
