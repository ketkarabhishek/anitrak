import 'package:anitrak/src/models/library_item.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/repositories/media_library_repo.dart';
import 'package:bloc/bloc.dart';

part 'media_page_state.dart';

class MediaPageCubit extends Cubit<MediaPageCubitState> {
  MediaPageCubit(this.mediaLibraryRepo) : super(MediaPageInitial());

  final MediaLibraryRepo mediaLibraryRepo;

  void getMediaEntry(int alMediaId) async{
    final entry = await mediaLibraryRepo.getMediaEntry(alMediaId: alMediaId);

    entry == null ? emit(MediaPageInitial()) : emit(MediaPageWithEntry(entry));
  }

  void insertLibraryEntry(LibraryItem libraryItem) async {
    await mediaLibraryRepo.insertLibraryItem(libraryItem);
    emit(MediaPageWithEntry(libraryItem.mediaEntry));
  }

  void updateMediaEntry(MediaEntry mediaEntry) async {
    await mediaLibraryRepo.updateMediaEntry(mediaEntry);
    emit(MediaPageWithEntry(mediaEntry));
  }

  void deleteMediaEntry(LibraryItem mediaEntry) async {
    await mediaLibraryRepo.deleteLibraryItem(mediaEntry);
  }

  void setMediaEntry(MediaEntry mediaEntry){
    emit(MediaPageWithEntry(mediaEntry));
  }
}