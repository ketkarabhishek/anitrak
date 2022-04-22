import 'package:anitrak/src/models/library_item.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/repositories/media_library_repo.dart';
import 'package:bloc/bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._mediaLibraryRepo) : super(DashboardInitial()) {
    on<DashboardInitialized>((event, emit) {
      final recentsStream = _mediaLibraryRepo.getLibraryStream();
      recentsStream.listen((library) {
        if (library.isEmpty) {
          add(
            DashboardStateUpdated(
              DashboardEmpty(),
            ),
          );
          return;
        }
        final recentsList = library
            .where((item) => item.mediaEntry.entryStatus == MediaEntryStatus.watching)
            .take(10)
            .toList();
        recentsList.sort(((a, b) => b.mediaEntry.updatedAt.compareTo(a.mediaEntry.updatedAt)));
        final totalEpisodes = library
            .map((e) => e.mediaEntry.progress)
            .reduce((value, element) => value + element);
        final totalTime = library
            .map((e) => e.mediaEntry.progress * e.media.duration)
            .reduce((value, element) => value + element);
        final currentCount = library
            .where((item) => item.mediaEntry.entryStatus == MediaEntryStatus.watching)
            .length;
        final completedCount = library
            .where((item) => item.mediaEntry.entryStatus == MediaEntryStatus.completed)
            .length;
        final plannedCount = library
            .where((item) => item.mediaEntry.entryStatus == MediaEntryStatus.planned)
            .length;
        final onHoldCount = library
            .where((item) => item.mediaEntry.entryStatus == MediaEntryStatus.onHold)
            .length;
        final droppedCount = library
            .where((item) => item.mediaEntry.entryStatus == MediaEntryStatus.dropped)
            .length;
        final totalEntries = library.length;

        add(DashboardStateUpdated(DashboardData(
          recentsList,
          totalEntries,
          currentCount,
          completedCount,
          plannedCount,
          onHoldCount,
          droppedCount,
          totalEpisodes,
          Duration(minutes: totalTime).inDays,
        )));
      });
    });

    on<RecentsUpdated>((event, emit) async {
      await _mediaLibraryRepo.updateMediaEntry(event.updatedMediaEntry);
    });

    on<DashboardStateUpdated>((event, emit) async {
      emit(event.dashboardState);
    });
  }

  final MediaLibraryRepo _mediaLibraryRepo;
}
