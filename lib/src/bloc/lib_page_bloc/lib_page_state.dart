part of 'lib_page_bloc.dart';

abstract class LibPageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LibPageLoading extends LibPageState {}

class LibPageData extends LibPageState {
  final Stream<List<MediaEntry>> currentEntriesStream;
  final Stream<List<MediaEntry>> completedEntriesStream;
  final Stream<List<MediaEntry>> plannedEntriesStream;
  final Stream<List<MediaEntry>> onholdEntriesStream;
  final Stream<List<MediaEntry>> droppedEntriesStream;

  LibPageData({
    required this.currentEntriesStream,
    required this.completedEntriesStream,
    required this.plannedEntriesStream,
    required this.onholdEntriesStream,
    required this.droppedEntriesStream,
  });
}
