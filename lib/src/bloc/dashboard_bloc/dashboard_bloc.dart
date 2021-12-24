import 'package:anitrak/src/models/library_item.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/repositories/media_library_repo.dart';
import 'package:bloc/bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._mediaLibraryRepo) : super(DashboardInitial()) {
    on<DashboardInitialized>((event, emit) {
      final recentsStream = _mediaLibraryRepo.getLibraryStream(status: 'CURRENT', limit: 10);
      emit(DashboardData(recentsStream));
    });

    on<RecentsUpdated>((event, emit) async {
      await _mediaLibraryRepo.updateMediaEntry(event.updatedMediaEntry);
    });
  }

  final MediaLibraryRepo _mediaLibraryRepo;
}