part of 'media_page_cubit.dart';

abstract class MediaPageCubitState {
}

class MediaPageInitial extends MediaPageCubitState{}

class MediaPageWithEntry extends MediaPageCubitState {
  final MediaEntry mediaEntry;

  MediaPageWithEntry(this.mediaEntry);
}