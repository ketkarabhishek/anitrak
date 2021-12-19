part of 'lib_page_bloc.dart';

abstract class LibPageEvent {}

class LibraryFetchedEvent extends LibPageEvent{}

class LibraryEntryUpdated extends LibPageEvent{
  final MediaEntry updatedMediaEntry;

  LibraryEntryUpdated(this.updatedMediaEntry);
}