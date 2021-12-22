import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/repositories/media_entries_repo.dart';
import 'package:bloc/bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._mediaEntriesRepo) : super(DashboardInitial()) {
    on<DashboardInitialized>((event, emit) {
      final recentsStream = _mediaEntriesRepo.getMediaEntries(status: 'CURRENT', limit: 10);
      emit(DashboardData(recentsStream));
    });

    on<RecentsUpdated>((event, emit) async {
      await _mediaEntriesRepo.updateMediaEntry(event.updatedMediaEntry);
    });
  }

  final MediaEntriesRepo _mediaEntriesRepo;
}