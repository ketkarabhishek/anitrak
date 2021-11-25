import 'package:anitrak/src/db/database.dart';
import 'package:anitrak/src/db/dbhelper.dart';
import 'package:anitrak/src/db/media_entry_dao.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/services/anilist/anilist_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_state.dart';
part 'app_event.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this.db) : super(const AppState()) {
    on<ImportAnilistAppEvent>((event, emit) async {
      emit(state.copyWith(importingAnilist: true));
      await _importAnilistLibrary();
      emit(state.copyWith(importingAnilist: false));
    });

    on<InitialAppEvent>((event, emit){
    });
  }

  final AnilistClient client = AnilistClient.create();
  final DataBase db;

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

  @override
  void onChange(Change<AppState> change) {
    print(change.nextState.importingAnilist);
    super.onChange(change);
  }
}
