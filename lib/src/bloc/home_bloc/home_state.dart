part of 'home_bloc.dart';

enum HomeStatus { initial, success, failure }

class HomeState extends Equatable {
  const HomeState(
      {this.mediaList = const <Media>[],
      this.status = HomeStatus.initial,
      required this.mediaListStream});

  final List<Media> mediaList;
  final HomeStatus status;
  final Stream<List<MediaEntry>> mediaListStream;

  HomeState copyWith({
    List<Media>? mediaList,
    HomeStatus? status,
    Stream<List<MediaEntry>>? mediaListStream,
  }) {
    return HomeState(
        mediaList: mediaList ?? this.mediaList,
        status: status ?? this.status,
        mediaListStream: mediaListStream ?? this.mediaListStream);
  }

  @override
  List<Object> get props => [];
}
