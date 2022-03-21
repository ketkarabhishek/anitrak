import 'package:anitrak/src/models/library_item.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/repositories/media_library_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lib_page_event.dart';
part 'lib_page_state.dart';

class LibPageBloc extends Bloc<LibPageEvent, LibPageState> {
  LibPageBloc(this.mediaEntriesRepo) : super(LibPageLoading()) {
    on<LibraryFetchedEvent>((event, emit) {
      final currentStream = mediaEntriesRepo.getLibraryStream(status: MediaEntryStatus.watching);
      final completedStream =
          mediaEntriesRepo.getLibraryStream(status: MediaEntryStatus.completed);
      final plannedStream =
          mediaEntriesRepo.getLibraryStream(status: MediaEntryStatus.planned);
      final droppedStream = mediaEntriesRepo.getLibraryStream(status: MediaEntryStatus.dropped);
      final onholdStream = mediaEntriesRepo.getLibraryStream(status: MediaEntryStatus.onHold);

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
  }

  final MediaLibraryRepo mediaEntriesRepo;
}
