import 'package:anitrak/src/models/media_model.dart';
import 'package:anitrak/src/repositories/media_library_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  
  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  SearchBloc(this._mediaLibraryRepo) : super(SearchLoading()) {
    on<MediaSearchEvent>(
      (event, emit) async {
        emit(SearchLoading());
        final mediaList =
            await _mediaLibraryRepo.getAnilistMedia(search: event.search);
        emit(SearchData(mediaList));
      },
      transformer: debounce<MediaSearchEvent>(
        const Duration(milliseconds: 500),
      ),
    );
  }

  final MediaLibraryRepo _mediaLibraryRepo;
}
