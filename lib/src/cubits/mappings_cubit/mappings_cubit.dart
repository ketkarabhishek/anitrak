import 'package:anitrak/src/repositories/media_library_repo.dart';
import 'package:anitrak/src/repositories/preferences_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'mappings_state.dart';

class MappingsCubit extends Cubit<MappingsState> {
  MappingsCubit(this._mediaLibraryRepo, this._preferencesRepo)
      : super(Initial());

  final MediaLibraryRepo _mediaLibraryRepo;

  final PreferencesRepo _preferencesRepo;

  void initializeMappings() async {
    final firstTime = await _preferencesRepo.firstTime ?? true;
    if (firstTime) {
      refreshMappings();
      return;
    }

    final refreshDate = await _preferencesRepo.mappingDate;
    final date = DateTime.parse(refreshDate ?? DateTime.now().toString());
    if (DateTime.now().difference(date).inDays > 7) {
      refreshMappings();
    }
    // await refreshMappings();
  }

  Future<void> refreshMappings() async {
    emit(Loading());
    await _mediaLibraryRepo.deleteAllMediaMapping();
    await _mediaLibraryRepo.refreshMediaMappings();
    _preferencesRepo.setMappingDate(DateTime.now().toString());
    emit(Success());
  }
}
