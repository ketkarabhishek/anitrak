import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/repositories/media_entries_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lib_page_event.dart';
part 'lib_page_state.dart';

class LibPageBloc extends Bloc<LibPageEvent, LibPageState> {
  LibPageBloc(this.mediaEntriesRepo) : super(LibPageLoading()) {
    on<LibraryFetchedEvent>((event, emit) {
      final currentStream = mediaEntriesRepo.getMediaEntries(status: 'CURRENT');
      final completedStream =
          mediaEntriesRepo.getMediaEntries(status: 'COMPLETED');
      final plannedStream =
          mediaEntriesRepo.getMediaEntries(status: 'PLANNING');
      final droppedStream = mediaEntriesRepo.getMediaEntries(status: 'DROPPED');
      final onholdStream = mediaEntriesRepo.getMediaEntries(status: 'PAUSED');

      emit(
        LibPageData(
          currentEntriesStream: currentStream,
          completedEntriesStream: completedStream,
          plannedEntriesStream: plannedStream,
          droppedEntriesStream: droppedStream,
          onholdEntriesStream: onholdStream,
        ),
      );
    });

    on<LibraryEntryUpdated>((event, emit) async {
      await mediaEntriesRepo.updateMediaEntry(event.updatedMediaEntry);
    });
  }

  final MediaEntriesRepo mediaEntriesRepo;
}
