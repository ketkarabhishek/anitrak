part of 'lib_page_bloc.dart';

abstract class LibPageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LibPageLoading extends LibPageState {}

class LibPageData extends LibPageState {
  final Stream<List<LibraryItem>> currentEntriesStream;
  final Stream<List<LibraryItem>> completedEntriesStream;
  final Stream<List<LibraryItem>> plannedEntriesStream;
  final Stream<List<LibraryItem>> onholdEntriesStream;
  final Stream<List<LibraryItem>> droppedEntriesStream;

  LibPageData({
    required this.currentEntriesStream,
    required this.completedEntriesStream,
    required this.plannedEntriesStream,
    required this.onholdEntriesStream,
    required this.droppedEntriesStream,
  });
}
