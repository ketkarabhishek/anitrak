part of 'search_bloc.dart';

abstract class SearchEvent {}

class MediaSearchEvent extends SearchEvent{
  final String? search;

  MediaSearchEvent({required this.search});
}