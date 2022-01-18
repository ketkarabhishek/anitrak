part of 'search_bloc.dart';

abstract class SearchState {}

class SearchLoading extends SearchState {}

class SearchData extends SearchState {
  final List<MediaModel> mediaList;

  SearchData(this.mediaList);
}
